#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;    What is this?    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    This file creates the data structures and objects required to construct
;;;;      a maze object.  A maze is a list of rows, and each row is a list of
;;;;      cells.  Each cell contains its row number, column number, and a list
;;;;      of booleans denoting which directions one is allowed to move in from
;;;;      that particular cell.

;;;;;;;;;;;;;;;    How to create and use the maze object    ;;;;;;;;;;;;;;;;;;;
;;;;    To create a maze object called maze, type the following: 
;;;;      (define maze (make-maze [size])), where [size] is the size you want
;;;;      your maze to be.
;;;;    To call a member function called 'member that takes an argument arg,
;;;;      type the following: ((maze 'member) arg)).
;;;;    Member functions are included in the maze object and are fairly self-
;;;;      explanatory (more documentation will be added later).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;    Procedures for constructing maze    ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sample cell: (column row left down up right)
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

;;;;;;;;;;;;;;;;;    Accessor functions    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Getters for all parts of the cell
(define column car)
(define row cadr)
(define (flags cell) (caddr cell))
(define (left cell) (car (flags cell)))
(define (down cell) (cadr (flags cell)))
(define (up cell) (caddr (flags cell)))
(define (right cell) (cadddr (flags cell)))

;; Getter for row
(define (get-row row-num maze)
  (define (get-row-helper remaining-maze)
    (if (= row-num (cadaar remaining-maze))
        (car remaining-maze)
        (get-row-helper (cdr remaining-maze))))
  (get-row-helper maze))

;; Map over a particular row
(define (row-map procedure row-number maze)
  (map procedure (get-row row-number maze)))
  
;; Map over the whole maze
(define (maze-map procedure maze height)
  (define (map-over-rows row-num return)
    (if (= row-num height)
        return
        (map-over-rows (+ row-num 1)
                       (cons (row-map procedure row-num maze) return))))
  (map-over-rows 0 '()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;    Procedures for making maze random    ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (randtf)
  (list-ref '(#f #t #t #f #t #t #f #t #t #f #t) (random 10)))

(define (randdir)
  (begin (define rand (random 4))
         (cond ((= rand 0) 'left)
               ((= rand 1) 'down)
               ((= rand 2) 'up)
               ((= rand 3) 'right))))

(define (rand-flags-if-false cell)
         (list
          (column cell)
          (row cell)
          (list (if (eq? (left cell) #t)
                    #t
                    (randtf))
                (if (eq? (down cell) #t)
                    #t
                    (randtf))
                (if (eq? (up cell) #t)
                    #t
                    (randtf))
                (if (eq? (right cell) #t)
                    #t
                    (randtf)))))

(define (set-walls dimension)
  (define (set-walls-helper cell)
    (cond ((= (row cell) 0) (list (column cell)
                                  (row cell)
                                  (list #f
                                        (down cell)
                                        (up cell)
                                        (right cell))))
          ((= (column cell) 0) (list (column cell)
                                     (row cell)
                                     (list (left cell)
                                                      #f
                                                      (up cell)
                                                      (right cell))))
          ((= (row cell) (- dimension 1)) (list (column cell)
                                                (row cell)
                                                (list (left cell)
                                                      (down cell)
                                                      (up cell)
                                                      #f)))
          ((= (column cell) (- dimension 1)) (list (column cell)
                                                   (row cell)
                                                (list (left cell)
                                           (down cell)
                                           #f
                                           (right cell))))
          (else cell)))
  set-walls-helper)

(define (make-outer-walls maze dimension)
  (maze-map (set-walls dimension) maze dimension))

(define (make-random maze dimension)
  (maze-map rand-flags-if-false maze dimension))

(define (make-path maze)
  maze)
  
(define (make-random-maze dimension)
  (make-outer-walls
   (make-random
    (make-path
     (maze-constructor dimension)) dimension) dimension))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Maze object    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-maze height)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;    Define the maze    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define maze (make-random-maze height))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Getters    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Getter for maze -- returns maze structure
  (define (get-maze)
    maze)
  
  ;; Getter for values in cell -- version where you pass coordinates
  (define (get-cell-values-coords part row column)
    (cond ((equal? part 'left) (car (get-directions-list row column)))
          ((equal? part 'down) (cadr (get-directions-list row column)))
          ((equal? part 'up) (caddr (get-directions-list row column)))
          ((equal? part 'right) (cadddr (get-directions-list row column)))
          ((equal? part 'dir-list) (get-directions-list row column))
          ((equal? part 'cell) (get-cell row column))))
  
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

  ;; Getter for the height of the maze
  (define (get-height)
    (- height 0))
  
  ;; Get cell based on coords -- not for user
  (define (get-cell row-num column-num)
    (define (helper current-column-num row)
      (if (= column-num current-column-num)
          (car row)
          (helper (+ current-column-num 1) (cdr row))))
    (helper 0 (get-row row-num)))
  
  ;; Getter for directions list in cell
  (define (get-directions-list row-num column-num)
    (caddr (get-cell row-num column-num)))
  
  ;; Getter for row
  (define (get-row row-num)
    (define (get-row-helper remaining-maze)
      (if (= row-num (cadaar remaining-maze))
          (car remaining-maze)
          (get-row-helper (cdr remaining-maze))))
    (get-row-helper maze))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;    Mapping Functions    ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Map over a particular row
  (define (row-map procedure row-number)
    (map procedure (get-row row-number)))
  
  ;; Map over the whole maze
  (define (maze-map procedure)
    (define (map-over-rows row-num return)
      (if (= row-num height)
          return
          (map-over-rows (+ row-num 1)
                         (cons (row-map procedure row-num) return))))
    (map-over-rows 0 '()))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Dispatch    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define (dispatch message)
    (cond ((eq? message 'get-cell-values-coords) get-cell-values-coords)
          ((eq? message 'get-cell-values-cell) get-cell-values-cell)
          ((eq? message 'get-max-cell) get-max-cell)
          ((eq? message 'get-min-cell) get-min-cell)
          ((eq? message 'get-height) get-height)
          ((eq? message 'row-map) row-map)
          ((eq? message 'maze-map) maze-map)
          ((eq? message 'get-maze) get-maze)))
  
  dispatch)

;;;;;;;;;;;;    So that this can be included in other programs    ;;;;;;;;;;;;;

(provide make-maze)
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   EOF    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; testing functions
;
;(define maze (make-maze 3))
;((maze 'get-maze))
;(define maze (maze-constructor 3))
;(define (row-map-test cell)
;  (list 3 3 (caddr cell)))
