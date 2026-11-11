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
            #:data (hasheq 'days days
                           'localTime localtime
                           'lang lang)))

(define (weather/hourly latitude longitude [hours 24]
                        #:localtime [localtime (current-qweather-localtime)]
                        #:lang [lang (current-qweather-lang)])
  (http-get (api-qweather)
            #:path (string-join `("hourly" ,latitude ,longitude) "/")
            #:data (hasheq 'hours hours
                           'localTime localtime
                           'lang lang)))
