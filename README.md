# Labyrinth

### Statement
This project creates random mazes that the user could solve by moving through the maze using keyboard inputs using arrow keys with sound effects. 

Jess is interested in the project because she likes computer graphics and the game design. 
Jooseppi is interested in it because he likes designing abstract data structures to solve real-world problems.

## Architecture Diagram
This is the architecture diagram for Labyrinth:
![architecture-diagram](/labyrinth-architecture-diagram-updated.png?raw=true "architecture-diagram")
From the above diagram, we can see that the central part of the game is the logic, which controls the playing field and the music player.  The game logic takes input from the user (via the keyboard) and from the game field and directs the field and the music player in changing state corresponding to events on the field and commands from the user.  

The playing field is implemented as a world using the 2hdtp teachpack.  It has a field image which is made up of a gray background and the walls of the maze is build on top of it. The character sprite is placed on to the field and then the whole image is rendered to the screen. The maze image is constructed using the direction list from the maze object to determine where to place walls. The position of the sprite moves in response to commands from the game logic updated by keyboard input from the user.  

The music player is an object that takes a list of music files, (a track), and has methods for play, playlist, and loop.  Play takes the name of a music file and finds the corresponding entry in the track and plays it once.  Playlist takes a list of music files and plays it in order.  Loop takes the name of a music file and a count and plays a signle music file or playlist for a specified number of times. The game logic calls the music player to play sound files depending on what is happening in the game in response to keyboard input. 

Tha maze is created by drawing tiles for all blocks into the field. The tiles are drawn from the direction list of a certain block in the maze object and then drawn into the field at it's corresponding position. The maze object uses a list as its underlying implementation.  Each entry in the list represents a block in the maze; a block has two numbers that describe its coordinates, and a list of four true/false values indicating what directions a player is allowed to move in. The direction list for the maze is generated at random. Functions have been built to select a random path in the maze and then open/block all the rest of the paths. (It doesn't work correctly yet)

### Analysis

###Libaries used

```
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)
(require racket/gui)

(require "maze.rkt")
(require "draw-maze.rkt")
(require "music-player.rkt")

```

Open source libraries.
* The ```2htdp/image``` library provided the ability to draw images for the the game. 
* The ```2htdp/universe``` library provided the ability to obtain key input and create a universe.
* The ```lang/posn``` library provided the ability to create a position defining the location of the sprite in the field.
* The ```racket/gui``` library provided the ability to play sounds from a music file.

Our own libraries.
* The ```maze.rkt``` library provided the data structure for the maze.
* The ```draw-maze.rkt``` library provided the ability to draw the maze and render the sprite inside the maze.
* The ```music-player.rkt``` library provided the data structure for the music player.

```
``



###Key Code Excerpts

This project uses many of the concepts we have learned in this class, such as...

- Data abstraction:

Data abstraction is used in the maze structure, where the list describing the maze is hidden inside a maze object and only accessible via accessor functions. 

```
(define (maze-constructor dimension)
(define (make-maze-helper counter dimension row-list)
(if (= 0 counter)
row-list
(make-maze-helper (- counter 1)
dimension
(cons (make-row (- counter 1) dimension) row-list))))
(make-maze-helper dimension dimension '()))


(define (get-cell-values-coords part row column)
(cond ((equal? part 'left) (car (get-directions-list row column)))
((equal? part 'down) (cadr (get-directions-list row column)))
((equal? part 'up) (caddr (get-directions-list row column)))
((equal? part 'right) (cadddr (get-directions-list row column)))
((equal? part 'dir-list) (get-directions-list row column))
((equal? part 'cell) (get-cell row column))))
``


- Recursion:

Tail recursion is used to build the maze.

Tail recursion is also used to place the tiles in to the field. State modification is also used to continue updating the state of the field until the whole maze has been placed in.


```
(define (create-map)
(define (map-help cur-row cur-col)
(if (< cur-col ((maze 'get-height)))
(if (< cur-row ((maze 'get-height)))
(begin (place-tile cur-row cur-col) (set! cur-row (+ 1 cur-row)) (map-help cur-row cur-col))
(begin (set! cur-col (+ 1 cur-col)) (set! cur-row 0) (map-help cur-row cur-col)))
#t))
(map-help 0 0))
``


- Mapping over lists:

Mapping will be used for setting the rest of the direction flags in the maze object and may also be used for moving the sprite in the maze.

```
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
``

- Object-orientation:

The maze and music player are implemented as objects.

```
(define (music-player track)
(define (play name)
(play-sound (first (member name track)) #f) #f)
(define (loop name count)
(if (> count 0) (begin (set! count (- count 1)) (if(pair? name) (playlist name) (play name)) (loop name count))
#f))
(define (playlist list)
(for-each (lambda (name) (play name)) list)#f)
(define (option method)
(cond ((eq? method 'play) play)
((eq? method 'loop) loop)
((eq? method 'playlist) playlist)
(else (error "Unknown option: music player"
method))))
option)
``

- State-modification:

The music player uses state modification to for the loop function, and rand, which is implemented using state-modification, will probably be used for building the maze.

```
(define (loop name count)
(if (> count 0) (begin (set! count (- count 1)) (if(pair? name) (playlist name) (play name)) (loop name count))
#f))
``

### Deliverable and Demonstration
In the project, we have created a single-player labyrinth game that a player will be able to play by moving a sprite through a maze using up down left right arrow keys. At the live demo, we will let others walk up to the computer, start a game, and solve a maze.  

### Evaluation of Results
The project is successful if it generates a good labyrinth that the user can solve by moving through with a sprite.  A good labyrinth is defined as a labyrinth that has at least one solution and no obvious solutions.

There is no obvious solution, it is randomized, but we were unable to guarantee a path.

## Schedule

### First Milestone (Sun Apr 9)
By the first milestone, we created a working maze object and implemented functionality to draw the maze using the underlying data structure. The music player was created before this point for a previous exploration.

Work done:
Jooseppi completed a basic structure of the maze object, started working on randomizing the maze.
Jessica used the maze object and wrote functions that generated the image of the field with the maze.

We have also discussed future implementation methods for collision detection and movement to set the project up in the right direction.

### Second Milestone (Sun Apr 16)
By the second milestone, we had taken the maze, sprite and music player and integrated them into the field created using 2HDTP/universe; e.g., the sprite, and have the music player at least somewhat connected to the game.

Work done:

We put the blob and maze in the same world and implemented a simple demo for key detection using the music player where different sounds are played based on which key is struck.

### Public Presentation (Fri Apr 28)
For the public presentation, we have successfully receive keyboard input from a user to move the sprite in the correct direction. We have also successfully implement collision detection (detecting whether a sprite will collide with a wall if it moves in a particular direction) based on the direction list for the block that the sprite is currently in.

Although we have a randomized maze, we do not have a guaranteed path yet.


## Group Responsibilities

### Jessica J. Lai @sagishi
Jess was in charge of incorporating music in to the game. Jess is also in charge of developing and prototyping for game and field logic for the control methods of the game and final implementation of keyboard control, animation, and event handling (such as collision detection, playing sounds, changing sprites). 

### Jooseppi J. Luna @DaBigTuna
Jooseppi was in charge of building the underlying labyrinth data structure and drawing the labyrinth for the field and prototyping keyboard control.

### Shared responsibilities
Jess and Jooseppi shared reponsibility the overall design of the game and coming up with the design concepts used.
