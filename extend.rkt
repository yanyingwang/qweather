#lang at-exp racket/base

(require racket/string
         racket/list
         gregor
         (only-in (file "forecast.rkt")
                  weather/now
                  weather/24h))


(define lst/0
  (cons (now/moment)
        (hash-ref
         (hash-ref (http-response-body (weather/now "101180106")) 'now)
         'text)))

(define lst/24
  (for/list ([e (hash-ref (http-response-body (weather/24h "101180106"))
                          'hourly)])
    (cons  (iso8601->moment (hash-ref e 'fxTime))
           (hash-ref e 'text))))

(define lst/25
  (sort (list* lst/0 lst/24) moment<? #:key car))


(define (changing-pred lst)
  (let ([str (cdr lst)])
    (or (string-contains? str "雨")
        (string-contains? str "雪")
        (string-contains? str "冰"))))

(define changing/index (index-where lst/25 changing-pred))
(define changing/content (list-ref lst/25 changing/index))
(define changing/content+1 (list-ref lst/25 (add1 changing/index)))
(define changing/content+2 (list-ref lst/25 (add1 (add1 changing/index))))
(define changing/content+3 (list-ref lst/25 (add1 (add1 (add1 changing/index)))))
