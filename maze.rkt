#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;    Procedures related to the construction of the maze    ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; sample cell: (column row left down up right)

;; define list of directions; same as h j k l in Vim, the greatest text editor
(define directions-list
  (list #f #f #f #f))

;; constructor for cell object
(define (make-cell pos-in-row row-id-number)
  (list pos-in-row row-id-number directions-list))

;; constructor for a row in a maze
(define (make-row row-id-number length)
  (define (make-row-helper counter cell-list)
    (if (= 0 counter)
        cell-list
        (make-row-helper (- counter 1)
                         (cons (make-cell (- counter 1) row-id-number)
                               cell-list))))
  (make-row-helper length '()))

;; constructor for the maze
(define (make-maze height)
  (define (make-maze-helper counter height row-list)
    (if (= 0 counter)
        row-list
        (make-maze-helper (- counter 1)
                          height
                          (cons (make-row (- counter 1) height) row-list))))
  (make-maze-helper height height '()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;    Getter and Setters for Maze    ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Getter for direction in cell
(define (get-direction row cell direction)
  (cond ((equal? direction 'left) (car (get-directions-list row cell)))
        ((equal? direction 'down) (cadr (get-directions-list row cell)))
        ((equal? direction 'up) (caddr (get-directions-list row cell)))
        ((equal? direction 'right) (cadddr (get-directions-list row cell)))))

;; Getter for cell
(define (get-directions-list row-num cell-wanted)
  (define (get-cell cell-num row-of-cells)
    (if (= cell-num (car row-of-cells))
        (caddr row-of-cells)
        (get-cell (cdr row-of-cells) cell-num)))
  (get-cell (get-row row-num) cell-wanted))

;; Getter for row
(define (get-row row-num)
  (define (get-row-helper remaining-maze)
    (if (= row-num (cadaar remaining-maze))
        (car remaining-maze)
        (get-row-helper (cdr remaining-maze))))
  (get-row-helper maze))

;; Getter for column ;; NOT FINISHED THIS WILL NOT WORK RN
(define (get-column column-num)
  (define (get-row-helper remaining-maze)
    (if (= column-num (cadaar remaining-maze))
        (car remaining-maze)
        (get-row-helper (cdr remaining-maze))))
  (get-row-helper maze))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;    Debugging Functions    ;;;;;;;;;;;;;;;;;;;;;;;;;;

(define maze-size 10)

(define maze (make-maze maze-size))