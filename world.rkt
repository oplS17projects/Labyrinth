#lang racket

(require "draw-maze.rkt")
(require "music-player.rkt")
(require 2htdp/image)
(require 2htdp/universe)


; setting up key-board movement for up down left right


;(define (update_blob w)#t)

(define (handle-key-event w a-key)
  (cond [(key=? a-key "left") (begin (update_blob_left) w)]
        [(key=? a-key "right") (begin (update_blob_right) w)]
        [(= (string-length a-key) 1) w]
        [(key=? a-key "up") (begin (update_blob_up) w)]
        [(key=? a-key "down") (begin (update_blob_down) w)]
        [else w]))

; handles state changes for the world
(big-bang 100
      ;    (on-tick sub1)
          (on-key handle-key-event)
          (to-draw player1)
          (stop-when zero?))

