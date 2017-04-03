# Labyrinth

### Statement
This project creates random mazes with at least one guaranteed solution that the user can solve by moving through the maze using keyboard inputs (probably arrow keys).  If time allows, stretch goals include hiding prizes in the maze and a multiplayer version.  Jess is interested in the project because she likes computer graphics and the game logic; Jooseppi is interested in it because he likes designing abstract data structures to solve real-world problems.

## Architecture Diagram
This is the architecture diagram for Labyrinth:
![architecture-diagram](/labyrinth-architecture-diagram-updated.png?raw=true "architecture-diagram")
From the above diagram, we can see that the central part of the game is the logic, which controls the playing field and the music player.  The game logic takes input from the user (via the keyboard) and from the game field and directs the field and the music player in changing state corresponding to events on the field and commands from the user.  

The playing field is implemented as a world using the 2hdtp teachpack.  It has a background image, maze image, and character sprite on it.  The maze image is constructed using data from the maze object, and the sprite is an object in its own right that moves in response to commands from the game logic.  

The music player is an object that takes a list of music files, (a track), and has methods for play, playlist, and loop.  Play takes the name of a music file and finds the corresponding entry in the track and plays it once.  Playlist takes a list of music files and plays it in order.  Loop takes the name of a music file and a count and plays a signle music file or playlist for a specified number of times.  The game logic can call the music player with any of the methods depending on what is happening in the game. 

The maze is drawn from a maze object that sends information to the maze in the field.  The maze object uses a list as its underlying implementation.  Each entry in the list represents a block in the maze; a block has two numbers that describe its coordinates, and a list of four true/false values indicating what directions a player is allowed to move in.  Functions will be built to select a random path in the maze and then open/block all the rest of the paths.  

### Analysis
This project uses many of the concepts we have learned in this class, such as...
- ...data abstraction.  Data abstraction is used in the maze structure, where the list describing the maze is hidden inside a maze object and only accessible via accessor functions.  The music player also uses data abstraction, hiding the actual music behind a wall of functions that give different play options.
- ...recursion.  Tail recursion is used to build the maze, and the procedure for making a path through the maze will most likely also use recursion.
- ...mapping over lists.  Mapping will be used for setting the rest of the direction flags in the maze object and may also be used for moving the sprite in the maze.
- ...object-orientation.  The maze and music player are implemented as objects.
- ...state-modification. The music player uses state modification to for the loop function, and rand, which is implemented using state-modification, will probably be used for building the maze.

### Deliverable and Demonstration
The aim for the project is to produce a single-player labyrinth game that a player will be able to play by moving a sprite through a maze.  At the live demo, we hope to have the game working such that a person will be able to walk up to the computer, start a game, and solve mazes under a time clock.  We might potentially build the game to keep track of players and scores to see who does the best.  Optional extras (stretch goals) include hiding prizes in the labyrinth for a player to collect and having a multiplayer version where two people start from different parts of the maze and both try to reach the end while collecting as many prizes as possible.

### Evaluation of Results
The project will be successful if it generates a good labyrinth that the user can solve by  moving through with a sprite.  A good labyrinth is defined as a labyrinth that has at least one solution and no obvious solutions.

## Schedule

### First Milestone (Sun Apr 9)
By the first milestone, we hope to have the maze object working and drawing reasonably good mazes.  This will also require the part of the field object that draws the maze to be working.  Doing this will involve finishing the maze object and refining it so that it draws realistic mazes.

### Second Milestone (Sun Apr 16)
By the second milestone, we hope to have a maze integrated into the field along with the other objects required; e.g., the sprite, and have the music player at least somewhat connected to the game.

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28)
For the public presentation, we will have to successfully receive keyboard input from a user, refine the game logic, implement collision detection (detecting whether a sprite will collide with a wall if it moves in a particular direction), and generally have the game ready to be played. 

## Group Responsibilities

### Jessica J. Lai @sagishi
Jess will be in charge of incorporating music in to the game (whether that means exploring rsound or improving the current Music player for more customized support using rsound and other methods). Jess is also in charge of developing and prototyping for game and field logic for the control methods of the game. 

### Jooseppi J. Luna @DaBigTuna
Jooseppi will be in charge of building the underlying labyrinth data structure and drawing the labyrinth for the field.

### Shared responsibilities
Jess and Jooseppi will share reponsibility for keyboard control, animation, event handling and the overall design of the game.
