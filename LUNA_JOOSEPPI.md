# Labyrinth-solving game in Racket

## Jooseppi Luna
### 29 April 2017

# Overview
This project creates random mazes that the user could solve by moving through the maze using keyboard inputs using arrow keys with sound effects.  The main part of the project that I tackled was implementing the maze.

The maze is represented as a list of rows, which are represented as a list of cells.  Each cell is a list built in the following pattern: '(column row (left down up right)), where column and row are the coordinates of a particular cell, and the list of directions contains #t/#f flags to show which directions can be moved in from a particular cell.  Other class concepts used in the construction of the maze are discussed below and include recursion, mapping over lists, data abstraction and object-oriented programming, and function composition.

**Authorship note:** All of the code described here was written by me.

# Libraries Used
Libraries?  None.  Real men don't need no stinkin' libraries.

# Key Code Excerpts
Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Five examples are shown and they are individually numbered. 

## 1. Recursion

The following code creates a global object, ```drive-client``` that is used in each of the subsequent API calls:

```
(define drive-client
  (oauth2-client
   #:id "548798434144-6s8abp8aiqh99bthfptv1cc4qotlllj6.apps.googleusercontent.com"
   #:secret "<email me for secret if you want to use my API>"))
 ```
 
 While using global objects is not a central theme in the course, it's necessary to show this code to understand
 the later examples.
 
## 2. Mapping over lists

A set of procedures was created to operate on the core ```drive-file``` object. Drive-files may be either
actual file objects or folder objects. In Racket, they are represented as a hash table.

```folder?``` accepts a ```drive-file```, inspects its ```mimeType```, and returns ```#t``` or ```#f```:

```
(define (folder? drive-file)
  (string=? (hash-ref drive-file 'mimeType "nope") "application/vnd.google-apps.folder"))
```

Another object produced by the Google Drive API is a list of drive-file objects ("```drive#fileList```"). 
When converted by the JSON library,
this list appears as hash map. 

```get-files``` retrieves a list of the files themselves, and ```get-id``` retrieves the unique ID
associated with a ```drive#fileList``` object:

```
(define (get-files obj)
  (hash-ref obj 'files))

(define (get-id obj)
  (hash-ref obj 'id))
```

## 3. Object-Oriented Programming and Data Abstraction

The low-level routine for interacting with Google Drive is named ```list-children```. This accepts an ID of a 
folder object, and optionally, a token for which page of results to produce.

A lot of the work here has to do with pagination. Because it's a web interface, one can only obtain a page of
results at a time. So it's necessary to step through each page. When a page is returned, it includes a token
for getting the next page. The ```list-children``` just gets one page:

```
(define (list-children folder-id . next-page-token)
  (read-json
   (get-pure-port
    (string->url (string-append "https://www.googleapis.com/drive/v3/files?"
                                "q='" folder-id "'+in+parents"
                                "&key=" (send drive-client get-id)
                                (if (= 1 (length next-page-token))
                                    (string-append "&pageToken=" (car next-page-token))
                                    "")
;                                "&pageSize=5"
                                ))
    token)))
```

The interesting routine is ```list-all-children```. This routine is directly invoked by the user.
It optionally accepts a page token; when it's used at top level this parameter will be null.

The routine uses ```let*``` to retrieve one page of results (using the above ```list-children``` procedure)
and also possibly obtain a token for the next page.

If there is a need to get more pages, the routine uses ```append``` to pre-pend the current results with 
a recursive call to get the next page (and possibly more pages).

Ultimately, when there are no more pages to be had, the routine terminates and returns the current page. 

This then generates a recursive process from the recursive definition.
```
(define (list-all-children folder-id . next-page-token)
  (let* ((this-page (if (= 0 (length next-page-token))
                      (list-children folder-id)
                      (list-children folder-id (car next-page-token))))
         (page-token (hash-ref this-page 'nextPageToken #f)))
    (if page-token
        (append (get-files this-page)
              (list-all-children folder-id page-token))
        (get-files this-page))))
```

## 4. Function Composition

The ```list-all-children``` procedure creates a list of all objects contained within a given folder.
These objects include the files themselves and other folders.

The ```filter``` abstraction is then used with the ```folder?``` predicate to make a list of subfolders
contained in a given folder:

```
(define (list-folders folder-id)
  (filter folder? (list-all-children folder-id)))
```
