#lang info
(define collection "qweather")
(define deps '("base" "at-exp-lib" "http-client" "gregor" "timable"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib" "scribble-rainbow-delimiters"))
(define scribblings '(("scribblings/qweather.scrbl" ())))
(define pkg-desc "racket wrapper of qweather api")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
