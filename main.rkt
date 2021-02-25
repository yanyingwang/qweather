#lang racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included LICENSE-MIT and LICENSE-APACHE files.
;; If you would prefer to use a different license, replace those files with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html



(require http-client)

(define current-qweather-key (make-parameter ""))
;; (define current-qweather-public-id (make-parameter ""))

(define geoapi-qweather
  (http-connection "https://geoapi.qweather.com"
                   (hasheq)
                   ;; (hasheq 'Content-Type "application/x-www-form-urlencoded")
                   (hasheq 'key (current-qweather-key))))
(define devapi-qweather
  (http-connection "https://devapi.qweather.com"
                   (hasheq)
                   (hasheq 'key (current-qweather-key))))
(define api-qweather
  (http-connection "https://devapi.qweather.com"
                   (hasheq)
                   (hasheq 'key (current-qweather-key))))



(define (city/lookup location)
  (http-get geoapi-qweather
            #:path "/v2/city/lookup"
            #:data (hasheq 'location location )))

(define (weather/now location)
  (http-get devapi-qweather
            #:path "/v7/weather/now"
            #:data (hasheq 'location location ))
  )

(define (weather/3d location)
  (http-get geoapi-qweather
            #:path "/v7/weather/3d"
            #:data (hasheq 'location location ))
  )

(define (weather/7d location)
  (http-get geoapi-qweather
            #:path "/v7/weather/7d"
            #:data (hasheq 'location location ))
  )

(define (weather/10d location)
  (http-get geoapi-qweather
            #:path "/v7/weather/10d"
            #:data (hasheq 'location location ))
  )

(define (weather/15d location)
  (http-get geoapi-qweather
            #:path "/v7/weather/15d"
            #:data (hasheq 'location location ))
  )




























(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (check-equal? (+ 2 2) 4))

(module+ main
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  (require racket/cmdline)
  (define who (box "world"))
  (command-line
    #:program "my-program"
    #:once-each
    [("-n" "--name") name "Who to say hello to" (set-box! who name)]
    #:args ()
    (printf "hello ~a~n" (unbox who))))
