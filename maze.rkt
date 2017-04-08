#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;    Debugging Functions    ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define test-maze-size 10)

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
;;;;;;;;;;;;;;;;;;    Getters, Iterator, and Map for Maze    ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Getter for values in cell -- version where you pass maze
(define (get-cell-values-maze part row cell maze)
  (cond ((equal? part 'left) (car (get-directions-list row cell maze)))
        ((equal? part 'down) (cadr (get-directions-list row cell maze)))
        ((equal? part 'up) (caddr (get-directions-list row cell maze)))
        ((equal? part 'right) (cadddr (get-directions-list row cell maze)))
        ((equal? part 'row) (car cell))
        ((equal? part 'column) (cadr cell))))

;; Getter for values in cell -- version where you pass cell
(define (get-cell-values-cell part cell)
  (begin (define directions (caddr cell))
  (cond ((equal? part 'left) (car directions))
        ((equal? part 'down) (cadr directions))
        ((equal? part 'up) (caddr directions))
        ((equal? part 'right) (cadddr directions))
        ((equal? part 'direction-list) directions)
        ((equal? part 'row) (car cell))
        ((equal? part 'column) (cadr cell)))))

;; Getter for cell
(define (get-directions-list row-num cell-wanted maze)
  (define (get-cell cell-num row-of-cells maze)
    (if (= cell-num (car row-of-cells))
        (caddr row-of-cells)
        (get-cell (cdr row-of-cells) cell-num)))
  (get-cell (get-row row-num maze) cell-wanted))

;; Getter for row
(define (get-row row-num maze)
  (define (get-row-helper remaining-maze)
    (if (= row-num (cadaar remaining-maze))
        (car remaining-maze)
        (get-row-helper (cdr remaining-maze))))
  (get-row-helper maze))

;; Map
(define (maze-map procedure maze)
  ; map over columns
  1)

;(define (map proc items)
;  (if (null? items)
;      '()
;      (cons (proc (car items))
;            (map proc (cdr items)))))

(define test-maze (make-maze test-maze-size))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;    Procedures for making maze random    ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Seeds random with time
(make-pseudo-random-generator)

(define (random-true-false)
  (if (= (random 3) 2)
      #f
      #t))
;;NEED TO FIGURE OUT OUTER WALLS YO
;; function for setting each direction flag randomly
;;    this function takes in a cell and returns a cell
(define (set-flags cell)
  (list
   (get-cell-values-cell 'column cell)
   (get-cell-values-cell 'row cell)
   (make-random-dir-list (get-cell-values-cell 'directions-list cell))))

(define (make-random-dir-list dir-list)
  (if (null? dir-list)
      '()
      (if (car dir-list)
          (cons #t (make-random-dir-list cdr dir-list))
          (cons (random-true-false) (make-random-dir-list cdr dir-list)))))

;; function for mapping over entire list with set-flags
(maze-map set-flags test-maze)
