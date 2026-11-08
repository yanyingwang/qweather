#lang at-exp racket/base

(require http-client gregor
         racket/string
         (file "private/params.rkt")
         (file "private/core.rkt"))
(provide (all-defined-out))



(define (weather/current latitude longitude
                 #:localtime [localtime (current-qweather-localtime)]
                 #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path (string-join `("current" ,latitude ,longitude) "/")
            #:data (hasheq 'localTime localtime
                           'lang lang)))

(define (weather/daily latitude longitude [days 7]
                 #:localtime [localtime (current-qweather-localtime)]
                 #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path (string-join `("daily" ,latitude ,longitude) "/")
            #:data (hasheq 'days 7
                           'localTime localtime
                           'lang lang)))

(define (weather/hourly latitude longitude [hours 24]
                        #:localtime [localtime (current-qweather-localtime)]
                        #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path (string-join `("hourly" ,latitude ,longitude) "/")
            #:data (hasheq 'hours 24
                           'localTime localtime
                           'lang lang)))

(define (weatheralert/current latitude longitude
                 #:localtime [localtime (current-qweather-localtime)]
                 #:lang [lang (current-qweather-lang)])
  (http-get (api-qweatheralert)
            #:path (string-join `("current" ,latitude ,longitude) "/")
            #:data (hasheq 'localTime localtime
                           'lang lang)))


#;(define (25h lid
                     #:gzip [gzip (current-qweather-gzip)]
                     #:lang [lang (current-qweather-lang)])
  (define nowa
    (list (hash-ref
           (hash-ref (http-response-body (now lid #:lang lang)) 'now)
           'text)
          (now)))
  (define lst/24
    (let* ([resp (hash-ref (http-response-body (24h lid #:lang lang) )
                           'hourly)]
           [lst (for/list ([e resp])
                  (list (hash-ref e 'text)
                        (iso8601->datetime (hash-ref e 'fxTime))))])
      (sort lst datetime<? #:key cadr)))
  (list* nowa lst/24))