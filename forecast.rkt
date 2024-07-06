#lang at-exp racket/base

(require http-client gregor
         (file "private/params.rkt")
         (file "private/core.rkt"))
(provide (all-defined-out))

(define (weather/now location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/now"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))


(define (weather/3d location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/3d"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
(define (weather/7d location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/7d"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
(define (weather/10d location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/10d"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
(define (weather/15d location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/15d"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
(define (weather/24h location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/24h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/72h location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/72h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
(define (weather/168h location
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/168h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/25h lid
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)])
  (define nowa
    (list (hash-ref
           (hash-ref (http-response-body (weather/now lid #:lang lang)) 'now)
           'text)
          (now)))
  (define lst/24
    (let* ([resp (hash-ref (http-response-body (weather/24h lid #:lang lang) )
                           'hourly)]
           [lst (for/list ([e resp])
                  (list (hash-ref e 'text)
                        (iso8601->datetime (hash-ref e 'fxTime))))])
      (sort lst datetime<? #:key cadr)))
  (list* nowa lst/24))