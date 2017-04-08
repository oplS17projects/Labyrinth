#lang racket

;; sample cell: (column row left down up right)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;    Procedures for constructing maze    ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define list of directions; same as h j k l in Vim, the greatest text editor
(define directions-list
  (list #f #f #f #f))

;; Constructor for cell object
(define (make-cell pos-in-row row-id-number)
  (list pos-in-row row-id-number directions-list))

;; Constructor for a row in a maze
(define (make-row row-id-number length)
  (define (make-row-helper counter cell-list)
    (if (= 0 counter)
        cell-list
        (make-row-helper (- counter 1)
                         (cons (make-cell (- counter 1) row-id-number)
                               cell-list))))
  (make-row-helper length '()))

;; Constructor for the maze
(define (maze-constructor dimension)
  (define (make-maze-helper counter dimension row-list)
    (if (= 0 counter)
        row-list
        (make-maze-helper (- counter 1)
                          dimension
                          (cons (make-row (- counter 1) dimension) row-list))))
  (make-maze-helper dimension dimension '()))

;; Contructor for randomized maze -- this is still coming

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Maze object    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-maze height)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;    Define the maze    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define maze (maze-constructor height))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Getters    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Getter for maze -- returns maze structure
  (define (get-maze)
    maze)
  
  ;; Getter for values in cell -- version where you pass coordinates
  (define (get-cell-values-coords part row cell)
    (cond ((equal? part 'left) (car (get-directions-list row cell)))
          ((equal? part 'down) (cadr (get-directions-list row cell)))
          ((equal? part 'up) (caddr (get-directions-list row cell)))
          ((equal? part 'right) (cadddr (get-directions-list row cell)))
          ((equal? part 'dir-list) (get-directions-list row cell))
          ((equal? part 'cell) (get-cell row cell))))
  
  ;; Getter for values in cell -- version where you pass cell
  (define (get-cell-values-cell part cell)
    (begin (define directions (caddr cell))
           (cond ((equal? part 'left) (car directions))
                 ((equal? part 'down) (cadr directions))
                 ((equal? part 'up) (caddr directions))
                 ((equal? part 'right) (cadddr directions))
                 ((equal? part 'dir-list) directions)
                 ((equal? part 'row) (cadr cell))
                 ((equal? part 'column) (car cell)))))
  
  ;; Getter for cell with max coordinates
  (define (get-max-cell)
    (get-cell-values-coords 'cell (- height 1) (- height 1)))
  
  ;; Getter for cell with min coordinates
  (define (get-min-cell)
    (get-cell-values-coords 'cell 0 0))
  
  ;; Get cell based on coords -- not for user
  (define (get-cell row-num cell-num)
    (define (helper current-cell-num row)
      (if (= cell-num current-cell-num)
          (car row)
          (helper (+ current-cell-num 1) (cdr row))))
    (helper 0 (get-row row-num)))
  
  ;; Getter for directions list in cell
  (define (get-directions-list row-num cell-num)
    (caddr (get-cell row-num cell-num)))
  
  ;; Getter for row
  (define (get-row row-num)
    (define (get-row-helper remaining-maze)
      (if (= row-num (cadaar remaining-maze))
          (car remaining-maze)
          (get-row-helper (cdr remaining-maze))))
    (get-row-helper maze))
  
  ;; Map over a particular row
  (define (row-map procedure row-number)
    (map procedure (get-row row-number)))
  
  ;; Map
  (define (maze-map procedure)
    (define (map-over-rows row-num return)
      (if (= row-num height)
          return
          (map-over-rows (+ row-num 1)
                         (cons (row-map procedure row-num) return))))
    (map-over-rows 0 '()))
  
  (define (dispatch message)
    (cond ((eq? message 'get-cell-values-coords) get-cell-values-coords)
          ((eq? message 'get-cell-values-cell) get-cell-values-cell)
          ((eq? message 'get-max-cell) get-max-cell)
          ((eq? message 'get-min-cell) get-min-cell)
          ((eq? message 'row-map) row-map)
          ((eq? message 'maze-map) maze-map)
          ((eq? message 'get-maze) get-maze)))
  
  dispatch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;    Procedures for making maze random    ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Seeds random with time
;(make-pseudo-random-generator)
;
;(define (random-true-false)
;  (if (= (random 3) 2)
;      #f
;      #t))
;;;NEED TO FIGURE OUT OUTER WALLS YO
;;; function for setting each direction flag randomly
;;;    this function takes in a cell and returns a cell
;(define (set-flags cell)
;  (list
;   (get-cell-values-cell 'column cell)
;   (get-cell-values-cell 'row cell)
;   (make-random-dir-list (get-cell-values-cell 'directions-list cell))))
;
;(define (make-random-dir-list dir-list)
;  (if (null? dir-list)
;      '()
;      (if (car dir-list)
;          (cons #t (make-random-dir-list cdr dir-list))
;          (cons (random-true-false) (make-random-dir-list cdr dir-list)))))
;
;;; function for mapping over entire list with set-flags
;(maze-map set-flags test-maze)
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   EOF    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; testing functions
;
;(define maze (make-maze 3))
;((maze 'get-maze))
;(define (row-map-test cell)
;  (list 3 3 (caddr cell)))
