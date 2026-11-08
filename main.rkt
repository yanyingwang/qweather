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



(require (file "private/params.rkt")
         (file "city.rkt")
         (file "forecast.rkt")
         #;(file "warning.rkt")
         #;(file "extend.rkt")
         #;(file "ai-d.rkt"))

(provide (all-from-out (file "private/params.rkt")
                       (file "city.rkt")
                       (file "forecast.rkt")
                       #;(file "warning.rkt")
                       #;(file "extend.rkt")
                       #;(file "ai-d.rkt")))
