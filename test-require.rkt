#lang racket

(require "maze.rkt")
(require 2htdp/image)

(define maze (make-maze 40))
((maze 'get-maze))

(define (wall x y color)
  (rectangle x y "solid" color))

(define window_size 400)

(define field
  (empty-scene window_size window_size "gray"))

(define (tile size row column)
  (let* ((left-c (if ((maze 'get-cell-values-coords) 'left row column) "gray" "brown"))
         (down-c (if ((maze 'get-cell-values-coords) 'down row column) "gray" "brown"))
         (up-c (if ((maze 'get-cell-values-coords) 'up row column) "gray" "brown"))
         (right-c (if ((maze 'get-cell-values-coords) 'right row column) "gray" "brown")))
  (place-image (wall (/ size 4) size left-c) 0 (/ size 2)
               (place-image (wall size (/ size 4) down-c) (/ size 2) 0
                            (place-image (wall size (/ size 4) up-c) (/ size 2) size
                                         (place-image (wall (/ size 4) size right-c) size (/ size 2)
                                                      (rectangle size size "solid" "gray")))))))

; (tile (/ window_size ((maze 'get-height))) 1 1)

;(define (place-tile row column)
 ; (let ([size (/ window_size ((maze 'get-height)))])
  ;  (place-image (tile size row column) (+ (* row size) (/ size 2)) (+ (* column size) (/ size 2)) (field))))

; (place-tile 1 1)

(define (place-tile row column)
  (let ((size (/ window_size ((maze 'get-height)))))
    (set! field
    (place-image (tile size row column) (+ (* row size) (/ size 2)) (+ (* column size) (/ size 2)) field))))

(define (create-map)
  (define (map-help cur-row cur-col)
    (if (< cur-col ((maze 'get-height)))
        (if (< cur-row ((maze 'get-height)))
            (begin (place-tile cur-row cur-col) (set! cur-row (+ 1 cur-row)) (map-help cur-row cur-col))
            (begin (set! cur-col (+ 1 cur-col)) (set! cur-row 0) (map-help cur-row cur-col)))
      field))
    (map-help 0 0))
      
