#lang at-exp racket/base

(require http-client
         racket/format
         (file "params.rkt"))
(provide (all-defined-out))

(current-http-client/debug #t)

(define (geoapi-qweather)
  (http-connection @~a{https://@(current-qweather-domain)/geo/v2/}
                   (hasheq 'X-QW-Api-Key (current-qweather-key))
                   (hasheq)))

(define (api-qweather)
  (http-connection @~a{https://@(current-qweather-domain)/weather/v1/}
                   (hasheq 'X-QW-Api-Key (current-qweather-key))
                   (hasheq)))


(define (api-qweatheralert)
  (http-connection @~a{https://@(current-qweather-domain)/weatheralert/v1/}
                   (hasheq 'X-QW-Api-Key (current-qweather-key))
                   (hasheq)))
