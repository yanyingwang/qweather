#lang at-exp racket/base

(require http-client
         racket/format
         (file "params.rkt"))
(provide (all-defined-out))

(define (geoapi-qweather)
  (http-connection "https://geoapi.qweather.com/v2"
                   (hasheq)
                   (hasheq 'key (current-qweather-key))))

(define (api-qweather)
  (http-connection @~a{https://@(current-qweather-domain)/v7}
                   (hasheq)
                   (hasheq 'key (current-qweather-key))))
