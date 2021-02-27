#lang at-exp racket/base



(require http-client
         (file "private/params.rkt")
         (file "private/core.rkt"))
(provide (all-defined-out))


(define (warning/now location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path "/warning/now"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang)))

(define (warning/list #:gzip [gzip (current-qweather-gzip)]
                      #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path "/warning/list"
            #:data (hasheq 'gzip gzip
                           'lang lang)))