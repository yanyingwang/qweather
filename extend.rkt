#lang at-exp racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         timable/gregor
         http-client
         (file "private/params.rkt")
         (file "forecast.rkt"))
(provide weather/24h/severe-weather-ai)

;; (require debug/repl
;;          racket/trace)


(define (severe-weather? lst)
  (let ([str (car lst)])
    (or (string-contains? str "雨")
        (string-contains? str "雪")
        (string-contains? str "冰"))))

(define (converting-step1 lst)
  (let loop ([lst lst]
             [item '()]
             [result '()]
             [i 0])
    (cond
      [(and (empty? lst)
            (not (empty? item)))
       (define result-item (append item (list i)))
       (append result (list result-item))]
      [(empty? lst) result]
      [(empty? item)
       (loop (cdr lst) (append item (car lst)) result (add1 i))]
      [(or (and (not (severe-weather? item))
                (not (severe-weather? (car lst))))
           (and (string=? (car item)
                          (caar lst))))
       (loop (cdr lst) item result (add1 i))] ;; add count of item: (add1 i)
      [else
       (define result-item (append item (list i)))
       (loop lst '() (append result (list result-item)) 0)]))) ;; append i to item and then move item to result and reset i to 0

(define (converting-step2 lst)
  (let loop ([lst lst]
             [prev-item '()]
             [result #f]
             [i 0])
    (cond [(= (length lst) 0)
           @~a{@|result|。}]
          [(= i 0)
           (define new-result
             (cond
               [(= (length lst) 1)
                (if (severe-weather? (car lst))
                    @~a{当前正在下@(first (car lst))并将持续下约(third (car lst)小时)}
                    "24小时内无雨，请放心出行")]
               [(> (length lst) 1)
                (if (severe-weather? (car lst))
                    @~a{当前正在下@(first (car lst))，但}
                    "")]
               [else (error "code shouldn't get here")]))
           (loop (cdr lst) (car lst) new-result (add1 i))]
          [(>= i 1)
           (define curr-item (car lst))
           (define curr-item/time (second curr-item))
           (define prev-item/time (second prev-item))
           (define gap-minutes (minutes-between prev-item/time curr-item/time))
           (define gap-minutes/from-now-on (minutes-between (now/moment) curr-item/time))
           (define weather-txt
             (if (severe-weather? curr-item)
                 (if (severe-weather? prev-item)
                     @~a{会转成下@(first curr-item)并持续约@(third curr-item)小时，}
                     @~a{会开始下@(first curr-item)约@(third curr-item)小时，})
                 (~a (car prev-item) "会停约" @(third curr-item) "小时；\n")))
           (define new-result
             (cond
               [(= i 1)
                (define time-txt
                  (cond
                    [(< gap-minutes/from-now-on 60)
                     @~a{@|gap-minutes|分钟后}]
                    [(moment<? curr-item/time
                               (at-end/on-day (now/moment)))
                     @~a{今天@(->hours curr-item/time)点}]
                    [(moment>=? curr-item/time
                                (at-end/on-day (now/moment)))
                     @~a{明天@(->hours curr-item/time)点}]
                    [(moment>=? curr-item/time
                                (+days (at-end/on-day (now/moment)) 1))
                     @~a{后天@(->hours curr-item/time)点}]
                    [(moment>=? curr-item/time
                                (+days (at-end/on-day (now/moment)) 2))
                     @~a{大后天@(->hours curr-item/time)点}]
                    [else
                     @~a{@(->day curr-item/time)日@(->hours curr-item/time)点}]))
                @~a{@|result|预计@|time-txt|@|weather-txt|}]
               [(> i 1)
                (define time-txt
                  (if (moment<? curr-item/time (at-end/on-day prev-item/time))
                      @~a{@(->hours curr-item/time)点}
                      @~a{翌日@(->hours curr-item/time)点}))
                @~a{@|result|其后@|time-txt|@|weather-txt|}]
               [else (error "code shouldn't get here")]))
           (loop (cdr lst)(car lst) new-result (add1 i))])))

(define (weather/24h/severe-weather-ai lid)
  (define nowa
    (list (hash-ref
           (hash-ref (http-response-body (weather/now lid #:lang "cn")) 'now)
           'text)
          (now/moment)))
  (define lst/24
    (let* ([resp (hash-ref (http-response-body (weather/24h lid #:lang "cn") )
                           'hourly)]
           [lst (for/list ([e resp])
                  (list (hash-ref e 'text)
                        (iso8601->moment (hash-ref e 'fxTime))))])
      (sort lst moment<? #:key cadr)))
  (define roster
    (list* nowa lst/24))
  (define roster1 (converting-step1 roster))
  (define roster2 (converting-step2 roster1))
  roster2)

#|
(weather/24h/severe-weather-ai "101180106") ;郑州
(weather/24h/severe-weather-ai "101020100") ;上海
(weather/24h/severe-weather-ai "101230401") ;莆田
(weather/24h/severe-weather-ai "101070101") ;沈阳
|#
