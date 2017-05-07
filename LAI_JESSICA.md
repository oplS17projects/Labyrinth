# Labyrinth-solving game in Racket

## Jessica Lai
### 29 April 2017

# Overview
This project creates random mazes that the user could solve by moving through the maze using keyboard inputs using arrow keys with sound effects.  Jooseppi (@DaBigTuna) and I worked on the project together, where he focused on the maze data structure and I focused on the GUI.

The playing field is implemented as a world using the 2hdtp teachpack.  It has a field image which is made up of a gray background and the walls of the maze is build on top of it using recursion. The character sprite is placed on to the field and then the whole image is rendered to the screen. The maze image is constructed using the direction list from the maze object to determine where to place walls. The position of the sprite moves in response to commands from the game logic updated by keyboard input from the user.  

The music player is an object that takes a list of music files, (a track), and has methods for play, playlist, and loop.  Play takes the name of a music file and finds the corresponding entry in the track and plays it once.  Playlist takes a list of music files and plays it in order.  Loop takes the name of a music file and a count and plays a signle music file or playlist for a specified number of times. The game logic calls the music player to play sound files depending on what is happening in the game in response to keyboard input. 

**Authorship note:** All of the code described here was written by me.

``` racket
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)
(require racket/gui)

(require "maze.rkt") (written by Jooseppi)
(require "draw-maze.rkt") (written by Me)
(require "music-player.rkt") (written by Me)
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
`

## 1. Recursion

- Recursion:

Tail recursion is used to build the maze and to place the tiles in to the field. State modification is also used to continue updating the state of the field until the whole maze has been placed in the field.  Below is an excerpt of code that is used to place the tiles in the field when drawing the maze.

``` racket
(define (create-map)
  (define (map-help cur-row cur-col)
    (if (< cur-col ((maze 'get-height)))
        (if (< cur-row ((maze 'get-height)))
            (begin (place-tile cur-row cur-col) (set! cur-row (+ 1 cur-row)) (map-help cur-row cur-col))
            (begin (set! cur-col (+ 1 cur-col)) (set! cur-row 0) (map-help cur-row cur-col)))
        #t))
  (map-help 0 0))
```
 
## 2. Object-orientation:

The music player is implemented as an object.  Below is an excerpt of the code for the music player.

``` racket
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
```

The music player takes a track has three method, play, loop, and playlist. And to use it, you pass it the name
of the song for a list of the songs you want to play and it will play it in that order. Play takes the name of the song and find the first occurance in track using member(which returns the rest of the list) and then use first to extract it to play. There is also function composition since loop and playlist are built using play. Playlist calls play on each song in the list it recieves. Loop takes in a counter(how many times) and uses state modification to decrement the counter.

We only ended up using play in our game though.


## 3. State-modification:

The music player uses state modification for the loop function.

``` racket
(define (loop name count)
  (if (> count 0) 
      (begin (set! count (- count 1)) 
             (if (pair? name) 
                 (playlist name) 
                 (play name)) 
             (loop name count))
      #f))
```

## 4. Functional approaches:

Many of the function I wrote are built on top of each other.

Create map is based on place tile

```
(begin (place-tile cur-row cur-col) (set! cur-row (+ 1 cur-row)) (map-help cur-row cur-col))
```

Place tile is based on tile.

```
  (place-image (tile size row column) (+ (* row size) (/ size 2)) (+ (* column size) (/ size 2)) field)
```

Tile is based on wall

```
(place-image (wall (/ size 4) size left-c) 0 (/ size 2)
(place-image (wall size (/ size 4) up-c) (/ size 2) 0
(place-image (wall size (/ size 4) down-c) (/ size 2) size
(place-image (wall (/ size 4) size right-c) size (/ size 2)
(rectangle size size "solid" "gray")))
```

## 5. Using Let*:

Because of the way place-image is set up, I decided to use let* to define the color of each wall(depending on if you can move in that direction or not) before the placement. If you can move in the direction, the color would be gray, which blends into the background. Otherwise the color will be brown to indicate a wall.

``` racket
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
```
