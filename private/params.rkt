#lang racket/base

(provide (all-defined-out))

(define current-qweather-key (make-parameter ""))
(define current-qweather-domain (make-parameter "devapi.qweather.com"))
(define current-qweather-range (make-parameter "world"))
(define current-qweather-number (make-parameter 10))
(define current-qweather-gzip (make-parameter "y"))
(define current-qweather-lang (make-parameter "en"))

;; (define current-qweather-public-id (make-parameter ""))
