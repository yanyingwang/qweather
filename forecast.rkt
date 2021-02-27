#lang at-exp racket/base

(require http-client
         (file "private/core.rkt"))
(provide (all-defined-out))

(define (weather/now location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "/weather/now"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/3d location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "/weather/now"
            #:data (weather/3d 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/7d location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "/weather/now"
            #:data (weather/7d 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/10d location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "/weather/now"
            #:data (weather/10d 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/15d location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "/weather/now"
            #:data (weather/15d 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/24h location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/24h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/72h location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/72h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))

(define (weather/168h location
                     #:gzip [gzip "y"]
                     #:lang [lang "en"]
                     #:unit [unit "m"])
  (http-get (api-qweather)
            #:path "weather/168h"
            #:data (hasheq 'location location
                           'gzip gzip
                           'lang lang
                           'unit unit)))
