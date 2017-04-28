#lang racket

(require "maze.rkt")
(require "music-player.rkt")
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)


(define maze (make-maze 20))
; ((maze 'get-maze))

(define (wall x y color)
  (rectangle x y "solid" color))

(define window_size 1000)

(define field
  (empty-scene window_size window_size "gray"))

(define (tile size row column)
  (let* ((left-c (if ((maze 'get-cell-values-coords) 'left row column) "gray" "brown"))
         (down-c (if ((maze 'get-cell-values-coords) 'down row column) "gray" "brown"))
         (up-c (if ((maze 'get-cell-values-coords) 'up row column) "gray" "brown"))
         (right-c (if ((maze 'get-cell-values-coords) 'right row column) "gray" "brown")))
  (place-image (wall (/ size 4) size left-c) 0 (/ size 2)
               (place-image (wall size (/ size 4) up-c) (/ size 2) 0
                            (place-image (wall size (/ size 4) down-c) (/ size 2) size
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
      #t))
    (map-help 0 0))

;; creates the blob for moving through the maze and some constants for the sprite
(define BLOB-right
  (overlay/offset
    (circle (/ window_size ((maze 'get-height)) 14) "solid" "black")
   (- 0 (/ window_size ((maze 'get-height)) 6)) (/ window_size ((maze 'get-height)) 15)
   (circle (/ window_size ((maze 'get-height)) 3) "solid" "yellow")))

(define BLOB-left
  (overlay/offset
    (circle (/ window_size ((maze 'get-height)) 14) "solid" "black")
   (/ window_size ((maze 'get-height)) 6) (/ window_size ((maze 'get-height)) 15)
   (circle (/ window_size ((maze 'get-height)) 3) "solid" "yellow")))

(define p1-posn
  (make-posn (/ window_size ((maze 'get-height)) 2) (/ window_size ((maze 'get-height)) 2)))

(define current-image
  (list BLOB-right))

;; functions for updating the position of the player
;
;  check if you can move in that position.
;  if so, update position
;  else, don't update.  (play a sound to indicate collison??)
;  for left and right, always update image sprite even if you can't move.
;;

;; method for getting row and column number given a position
;  
;  take current x or y and subtract half of a box (going down to the next closest
;  divide by the whole box. (gets the row or column number)
;  works because index starts at 0
;;

;; actually column row

;(/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
 ;                                 (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))

;(define move_bool #f)

;(define (can_move direction)
;(set! move_bool ((maze 'get-cell-values-coords) direction
 ;                                               (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
  ;                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
   ;                                             )))

(define (can_move direction)
  (cond [(equal? direction 'right)
         (if (= (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) (- ((maze 'get-height)) 1))
             #f
         (and ((maze 'get-cell-values-coords) direction
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))
              ((maze 'get-cell-values-coords) 'left
                                              (+ (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) 1)
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))))]
        [(equal? direction 'left)
         (if (= (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) 0)
             #f
         (and ((maze 'get-cell-values-coords) direction
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))
              ((maze 'get-cell-values-coords) 'right
                                              (- (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) 1)
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))))]
        [(equal? direction 'up)
         (if (= (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) 0)
             #f
         (and ((maze 'get-cell-values-coords) direction
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))
              ((maze 'get-cell-values-coords) 'down
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (- (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) 1))))]
        [(equal? direction 'down)
         (if (= (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))) (- ((maze 'get-height)) 1))
             #f
         (and ((maze 'get-cell-values-coords) direction
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height)))))
              ((maze 'get-cell-values-coords) 'up
                                              (/ (- (posn-x p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))
                                              (+ 1 (/ (- (posn-y p1-posn) (/ window_size ((maze 'get-height)) 2)) (/ window_size ((maze 'get-height))))))))]))

(define (update_blob_right)
  (if (can_move 'right)
      (begin (set! p1-posn (make-posn (+ (posn-x p1-posn) (/ window_size ((maze 'get-height)))) (posn-y p1-posn)))
                (set! current-image (list BLOB-right)) ((tunez 'play) beep))
         (begin (set! current-image (list BLOB-right)) ((tunez 'play) boop)))
  )

(define (update_blob_left)
  (if (can_move 'left)
      (begin (set! p1-posn (make-posn (- (posn-x p1-posn) (/ window_size ((maze 'get-height)))) (posn-y p1-posn)))
             (set! current-image (list BLOB-left)) ((tunez 'play) beep))
      (begin (set! current-image (list BLOB-left)) ((tunez 'play) boop)))
  )

(define (update_blob_up)
  (if (can_move 'up)
      (begin (set! p1-posn (make-posn (posn-x p1-posn) (- (posn-y p1-posn) (/ window_size ((maze 'get-height)))))) ((tunez 'play) beep))
      ((tunez 'play) boop))
  )

(define (update_blob_down)
  (if (can_move 'down)
      (begin (set! p1-posn (make-posn (posn-x p1-posn) (+ (posn-y p1-posn) (/ window_size ((maze 'get-height)))))) ((tunez 'play) beep))
      ((tunez 'play) boop))
  )

;; rendering function

(define (player1 posn)
  (place-images
   current-image
   (list p1-posn)
   field))

; define names or sounds to ake code prettier
(define beep "beep.wav")
(define boop "boop.wav")
(define fail "fail.wav")

; create a music player object
(define tunez (music-player (list beep boop fail)))


(create-map)

(provide player1)
(provide update_blob_left)
(provide update_blob_right)
(provide update_blob_up)
(provide update_blob_down)