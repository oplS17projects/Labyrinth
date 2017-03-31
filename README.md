# Labyrinth

### Statement
This project creates random mazes with at least one guaranteed throughpath that the user can solve by moving through the maze using keyboard inputs (probably arrow keys).  If time allows, stretch goals include hiding prizes in the maze and a multiplayer version.  Jess is interested in the project because she likes computer graphics and the game logic; Jooseppi is interested in it because he likes designing abstract data structures to solve real-world problems.

### Analysis
The labyrinth game is implemented using the 2hdtp/universe library.  There are four main parts to it: the game logic, the playing field, the music player, and the maze object.  

The game logic takes input from the keyboard and from the game field and directs the field and the music player in changing state corresponding to events both on the field (hitting a maze wall) and from the user (keyboard).  The game logic will most likely be implemented as a procedure that takes in a series of arguments and calls a procedure or procedures to change the state of the playing field.  This is an example of functional programming, because the output of the game logic procedure is solely dependent on the inputs and does not produce any side effects.  

The playing field is implemented as an object (LOOK THIS UP IN HDTP) that is a background image.  It has a maze image, blob image, and time-passed display on it.  The maze image is constructed using data from the maze object, the blob is a sprite that moves through the maze, and the time-passed display displays how long the player has ben playing the game.  JESS COULD YOU TALK ABOUT THE MUSIC PLAYER HERE.  

The maze object is an opaque object (this is an example of object-oriented programming and data abstraction) that uses a list of coordinates and true/false values to represent the maze.  Each entry in the list represents a block in the maze; a block has two numbers that describe its coordinates, and a list of four true/false values indicating what directions a player is allowed to move in.  It is built with a constructor that uses tail recursion to build the list.  The path through the maze will be set by a recursive procedure that uses rand (and so state modification) to set a path through the maze, and then a mapping function will randomly set the rest of the direction flags in the object to true o false with consideration to surrounding flags to make sure that object actually looks like a maze (i.e., with lots of possible paths, not just lots of incoherent lines).

- Will you use data abstraction? How?     yes, maze object     jess says yes also for music player 
- Will you use recursion? How?            yes, building, walking maze   
- Will you use map/filter/reduce? How?    maybe/probably, set maze direction values to true/false   jess says also need for block
- Will you use object-orientation? How?   yeah sure, maze object      jess says music player, all of our objects will be objects
- Will you use functional approaches to processing your data? How?  "Are we even processing the data?"  -Jess
- Will you use state-modification approaches? How? (If so, this should be encapsulated within objects. `set!` pretty much should only exist inside an object.)      we will probably use rand, I assume that has a built-in state modification? and music player says Jess
- Will you build an expression evaluator, like we did in the symbolic differentatior and the metacircular evaluator?  hahahaha.... no
- Will you use lazy evaluation approaches?  no idea maybe jess -probably not

**Your project will be graded, in part, by the extent to which you adopt approaches from the course into your implementation, _and_ your discussion about this.**

### Deliverable and Demonstration
Explain exactly what you'll have at the end. What will it be able to do at the live demo?
The aim for the project is to produce a single-player labyrinth game that a player will be able to play by moving a sprite through the maze to solve it.  At the live demo, we hope to have the game working such that a person will be able to walk up to the computer, start a game, and solve mazes under a time clock.  We might potentially build the game to keep track of players and scores to see who does the best.  Optional extras (stretch goals) include hiding prizes in the labyrinth for a player to collect and having a multiplayer version where two people start from different parts of the maze and both try to reach the end while collecting as many prizes as possible.

### Evaluation of Results
The project will be successful if it generates a good labyrinth that the user can solve by  moving through with a sprite.  A good labyrinth is defined as a labyrinth that has at least one solution and no obvious solutions.

## Architecture Diagram
Upload the architecture diagram you made for your slide presentation to your repository, and include it in-line here.

Create several paragraphs of narrative to explain the pieces and how they interoperate.

## Schedule

### First Milestone (Sun Apr 9)
Which portion of the work will be completed (and committed to Github) by this day?

Getting a working maze structure. Testing for keyboard control.

### Second Milestone (Sun Apr 16)
Which portion of the work will be completed (and committed to Github) by this day? 

Get the maze into the field. Also bring in other objects such as blob and music player.

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])
What additionally will be completed before the public presentation?

Getting a working game. Meaning refining game logic and collision detection. 

## Group Responsibilities
Here each group member gets a section where they, as an individual, detail what they are responsible for in this project. Each group member writes their own Responsibility section. Include the milestones and final deliverable.

Please use Github properly: each individual must make the edits to this file representing their own section of work.

### Jessica J. Lai @sagishi
Music player, game and field logic. 

### Jooseppi J. Luna @DaBigTuna
Jooseppi will be in charge of building the underlying labyrinth data structure and drawing the labyrinth for the field.

### Shared responsibilities
Jess and Jooseppi will share reponsibility for keyboard control, animation, event handling and the overall design of the game.
