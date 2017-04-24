#lang racket

(require "draw-maze.rkt")
(require "music-player.rkt")
(require 2htdp/image)
(require 2htdp/universe)

; define names or sounds to ake code prettier
(define beep "beep.wav")
(define boop "boop.wav")
(define fail "fail.wav")

; create a music player object
(define tunez (music-player (list beep boop fail)))

; define a function that plays music based on keyboard events
(define (play-tunez w a-key)
  (cond ((key=? a-key "left") (begin ((tunez 'play) beep) w))
        ((key=? a-key "right") (begin ((tunez 'play) boop) w))
        (else (begin ((tunez 'play) fail) w))))

; handles state changes for the world
(big-bang 100
          (on-tick sub1)
          (on-key play-tunez)
          (to-draw render-field)
          (stop-when zero?))
