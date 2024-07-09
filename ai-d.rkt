#lang at-exp racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         http-client
         (file "private/params.rkt")
         (file "private/helpers.rkt")
         (file "forecast.rkt"))

(provide weather/15d/ai)

(define (zhuan ttd ttn)
  (if (string=? ttd ttn)
      ttd (~a ttd "转" ttn)))

(define (weather/15d/ai lid)
  (define roster0
    (http-response-body (weather/15d lid)))
  (define roster1
    (cdr (hash-ref roster0 'daily)))

  (define day1 (car roster1))
  (define day2 (cadr roster1))
  (define day3 (caddr roster1))
  (define day1/x
    @~a{今天@(zhuan (hash-ref day1 'textDay) (hash-ref day1 'textNight))，气温@(hash-ref day1 'tempMin)~@(hash-ref day1 'tempMax)度，@(hash-ref day1 'windDirDay)@(string-replace (hash-ref day1 'windScaleDay) "-" "~")级。})
  (define day1/s
    @~a{日出于@(hash-ref day1 'sunrise)，落于@(hash-ref day1 'sunset)。})
  (define day1/m
    @~a{夜晚的一弯@(hash-ref day1 'moonPhase)，出于@(hash-ref day1 'moonrise)，落于@(hash-ref day1 'moonset)。})
  (define day2+3/x
    @~a{明天@(zhuan (hash-ref day2 'textDay) (hash-ref day2 'textNight))，后天@(zhuan (hash-ref day3 'textDay) (hash-ref day3 'textNight))。})
  (define d1
    (string-append day1/x day1/s day1/m))
  (define d2&3
    @~a{明天@(zhuan (hash-ref day2 'textDay) (hash-ref day2 'textNight))，后天@(zhuan (hash-ref day3 'textDay) (hash-ref day3 'textNight))。})

  (define roster2
    (map (lambda (e)
           (define d (parse-date (hash-ref e 'fxDate) "yyy-MM-dd"))
           (define ttd (hash-ref e 'textDay) )
           (define ttn (hash-ref e 'textNight))
           (define tt (zhuan ttd ttn))
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
  (define roster3/y
    (filter (lambda (e) (string=? "雨" (cdr e))) roster3))
  (define roster3/x
    (filter (lambda (e) (string=? "雪" (cdr e))) roster3))

  (define t0 "未来7天")
  (define t1
    (cond
      [(not (empty? roster3a/y))
       (~a "有" (length roster3a/y) "天下雨")]
      [(not (empty? roster3a/x))
       (~a "有" (length roster3a/x) "天下雪")]
      ["无降水天气"]))
  (define t2 "，")
  (define t3 "未来14天")
  (define t4
    (cond
      [(not (empty? roster3/y))
       (~a "有" (length roster3/y) "天下雨")]
      [(not (empty? roster3/x))
       (~a "有" (length roster3/x) "天下雪")]
      ["无降水天气。"]))
  (define t5 "。")
  (define 7&14d
    (string-append t0 t1 t2 t3 t4 t5))

  (string-append d1 d2&3 7&14d)
  )
