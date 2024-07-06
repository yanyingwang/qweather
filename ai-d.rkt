#lang racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         timable/gregor
         http-client
         (file "private/params.rkt")
         (file "private/helpers.rkt")
         (file "forecast.rkt"))


(define (weather/15d/severe-weather-ai lid)
  (define roster0
    (http-response-body (weather/15d lid)))
  (define roster1
    (cdr (hash-ref roster0 'daily)))
  (define roster2
    (map (lambda (e)
           (define d (parse-date (hash-ref e 'fxDate) "yyy-MM-dd"))
           (define ttd (hash-ref e 'textDay) )
           (define ttn (hash-ref e 'textNight))
           (define tt
             (if (string=? ttd ttn)
                 ttd (~a ttd "转" ttn)))
           (cons d tt))
         roster1))
  (define roster3
    (map (lambda (e)
           (cons (car e)
                 (cond [(string-contains? (cdr e) "雨") "雨"]
                       [(string-contains? (cdr e) "雪") "雪"]
                       [else ""])) )
         roster2))
  (define roster3a
    (take roster3 7))
  (define roster3b
    (drop roster3 7))
  (define roster3a/y
    (filter (lambda (e) (string=? "雨" (cdr e))) roster3a))
  (define roster3a/x
    (filter (lambda (e) (string=? "雪" (cdr e))) roster3a))
  (define roster3b/y
    (filter (lambda (e) (string=? "雨" (cdr e))) roster3b))
  (define roster3b/x
    (filter (lambda (e) (string=? "雪" (cdr e))) roster3b))

  (define t0 "未来7天")
  (define t1
    (cond
      [(not (empty? roster3a/y))
       (~a "有" (length roster3a/y) "天下雨")]
      [(not (empty? roster3a/x))
       (~a "有" (length roster3a/x) "天下雪")]
      ["无降水天气"]))
  (define t2 "。")
  (define t3 "未来7—14天")
  (define t4
    (cond
      [(not (empty? roster3b/y))
       (~a "有" (length roster3b/y) "天下雨")]
      [(not (empty? roster3b/x))
       (~a "有" (length roster3b/x) "天下雪")]
      ["无降水天气。"]))
  (define t5 "。")
  (string-append t0 t1 t2 t3 t4 t5)
  )