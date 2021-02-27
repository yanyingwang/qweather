#lang at-exp racket/base



(require http-client
         (file "private/core.rkt"))
(provide (all-defined-out))


(define (warning/now location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"])
  (http-get (api-qweather)
            #:path "/warning/now"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang)))

(define (warning/list #:range [range "cn"]
                      #:gzip [gzip "y"])
  (http-get (api-qweather)
            #:path "/warning/now"
            #:data (hasheq 'range range
                           'gzip gzip)))