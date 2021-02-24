#lang info
(define collection "qweather")
(define deps '("base" "gregor-lib" "at-exp-lib" "http-client"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/qweather.scrbl" ())))
(define pkg-desc "racket wrapper of qweather api")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
