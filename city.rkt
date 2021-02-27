#lang at-exp racket/base

(require http-client
         (file "private/core.rkt"))
(provide (all-defined-out))

(define (city/lookup location
                     #:adm [adm ""]
                     #:range [range "world"]
                     #:number [number 10]
                     #:gzip [gzip "y"]
                     #:lang [lang "en"])
  (http-get (geoapi-qweather)
            #:path "/city/lookup"
            #:data (hasheq 'location location
                           'adm adm
                           'range range
                           'number number
                           'gzip gzip
                           'lang lang)))

(define (city/top #:range [range "world"]
                  #:number [number 10]
                  #:gzip [gzip "y"]
                  #:lang [lang "en"])
  (http-get (geoapi-qweather)
            #:path "/city/top"
            #:data (hasheq 'range range
                           'number number
                           'gzip gzip
                           'lang lang)))

(define (poi/lookup location
                    #:type [type "scenic"]
                    #:city [city ""]
                    #:number [number 10]
                    #:gzip [gzip "y"]
                    #:lang [lang "en"])
  (http-get (geoapi-qweather)
            #:path "/poi/lookup"
            #:data (hasheq 'location location
                           'type type
                           'city city
                           'number number
                           'gzip gzip
                           'lang lang)))

;; (http-response-body (poi/range "116.4,39.1"))
(define (poi/range location
                    #:type [type "scenic"]
                    #:radius [radius 5]
                    #:number [number 10]
                    #:gzip [gzip "y"]
                    #:lang [lang "en"])
  (http-get (geoapi-qweather)
            #:path "/poi/range"
            #:data (hasheq 'location location
                           'type type
                           'radius radius
                           'number number
                           'gzip gzip
                           'lang lang)))
