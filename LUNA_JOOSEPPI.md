# Labyrinth-solving game in Racket

## Jooseppi Luna
### 29 April 2017

# Overview
This project creates random mazes that the user could solve by moving through the maze using keyboard inputs using arrow keys with sound effects.  The main part of the project that I tackled was implementing the maze.

The maze is represented as a list of rows, which are represented as a list of cells.  Each cell is a list built in the following pattern: '(column row (left down up right)), where column and row are the coordinates of a particular cell, and the list of directions contains true/false flags to show which directions can be moved in from a particular cell.  Other class concepts used in the construction of the maze are discussed below and include recursion, mapping over lists, data abstraction and object-oriented programming, and function composition.

**Authorship note:** All of the code described here was written by me.

# Libraries Used
Libraries?  None.  Real men don't need no stinkin' libraries.

# Key Code Excerpts
Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Four examples are shown and they are individually numbered. 

## 1. Recursion

Recursion was literally all over the place in this project, but one of the main places it was used was in the construcion of the maze itself.  The maze was constructed by a tail-recursive procedure that consed together a bunch of rows, which were constructed tail-recursively from individual cells.  Below is the code that does this:

``` racket
;; sample cell: (column row (left down up right))

;; Define list of directions; same as h j k l in Vim, the world's greatest 
;;  text editor
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
  ```
 
## 2. Mapping over lists

The maze is constructed with all direction values in all cells set to false, so to change these values, the whole maze is mapped over with a function that randomizes the flags in each cell, and then another function that sets the outer walls of the maze to false so that you can't escape the maze.  Here is the code for `maze-map` and `row-map`, the two mapping functions I built for this project.

``` racket
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
```

And here is an exampe use of maze-map in the function that sets the walls in the maze to false:

``` racket
(define (make-outer-walls maze dimension)
  (maze-map (set-walls dimension) maze dimension))
```

## 3. Object-Oriented Programming and Data Abstraction

The maze object is wrapped in a dispatch function in an example of both object-oriented programming and data abstraction.  Here are two excerpts of the that code.  The first is the beginning of the object, with the first few getter procedures shown, and the second excerpt is the dispatch procedure for the object.

``` racket
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
  
```
``` racket
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
```

## 4. Function Composition

Function composition is all over the place in this code.   One of the better examples of it is in the randomization of the maze, which is accomplished by a two-line procedure that ends up causing nine other user-defined procedures to evaluate.  This is the maze randomization procedure:

``` racket
(define (make-random maze dimension)
  (maze-map rand-flags-if-false maze dimension))
```

This invokes the `maze-map` procedure, described above, with the `rand-flags-if-false` procedure, which takes a cell as an argument and coughs out a cell with all the false flags replaced with random flags.  The true flags are left alone because they define the path through the maze.  It looks like this:

``` racket
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
```

This in turn calls another user-defined procedure, `randtf`, which randomly produces a true/false flag, with bias toward true flags, and six accessor functions, which access all parts of the cell.  The code for these functions is shown below.

``` racket
;; Procedure for randomly generating random true/false values, with bias towards truth
(define (randtf)
  (list-ref '(#f #t #t #f #t #t #f #t #t #f #t) (random 10)))
```

``` racket
;; Getters for all parts of the cell
(define column car)
(define row cadr)
(define (flags cell) (caddr cell))
(define (left cell) (car (flags cell)))
(define (down cell) (cadr (flags cell)))
(define (up cell) (caddr (flags cell)))
(define (right cell) (cadddr (flags cell)))
```
