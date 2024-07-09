#lang at-exp racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         http-client
         (file "private/params.rkt")
         (file "private/helpers.rkt")
         (file "forecast.rkt"))
(provide weather/24h/severe-weather-ai)

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
  (let loop ([prv-item '()]
             [lst lst]
             [i 0])
    (cond
      [(empty? lst) lst]
      [(= i 0)
       (define ai-txt
         (cond
           [(and (= (length lst) 1)
                 (not (severe-weather? (car lst))))
            "24小时内无降水天气。"]
           [(and (= (length lst) 1)
                 (severe-weather? (car lst)))
            @~a{当前正在下@(first (car lst))并将持续下约(third (car lst)小时)}]
           [(and (> (length lst) 1)
                 (severe-weather? (car lst)))
            @~a{当前正在下@(first (car lst))，但}]
           [(and (> (length lst) 1)
                 (not (severe-weather? (car lst))))
            "预计"]))
       (cons ai-txt
             (loop (car lst) (cdr lst) (add1 i)))]
      [(>= i 1)
       (define cur-item (car lst))
       (define cur-item/s (car cur-item)) ; status
       (define cur-item/dt (cadr cur-item)) ;datetime
       (define cur-item/n (caddr cur-item)) ; lasting number
       (define prv-item/s (car prv-item))
       (define prv-item/n (caddr prv-item))
       (define prv-item/dt (cadr prv-item))
       (define ai-txt2
         (if (severe-weather? cur-item)
             (if (severe-weather? prv-item)
                 @~a{会转成下@|cur-item/s|并持续约@|cur-item/n|小时，}
                 (if (>= i 2)
                     @~a{会重新下@|cur-item/s|约@|cur-item/n|小时，}
                     @~a{会开始下@|cur-item/s|约@|cur-item/n|小时，}))
             @~a{@|prv-item/s|会停；}))
       (define ai-txt
         (string-append (->cn-dt-text cur-item/dt) ai-txt2))
       (cons ai-txt
             (loop (car lst) (cdr lst) (add1 i)))]
      )))

(define (weather/24h/severe-weather-ai lid)
  (define roster (weather/25h lid))
  (define roster1 (converting-step1 roster))
  (define roster2 (converting-step2 roster1))
  (define roster3 (string-join roster2 ""))
  (define roster4 (regexp-replace #rx"(；|，)$" (string-trim roster3) "。"))
  roster4)


#|
(weather/24h/severe-weather-ai "101180106") ;郑州
(weather/24h/severe-weather-ai "101020100") ;上海
(weather/24h/severe-weather-ai "101230401") ;莆田
(weather/24h/severe-weather-ai "101070101") ;沈阳
|#

#;(module+ text
  ;; (check-equal? (+ 2 2) 4)
  ;; (define (now)
  ;;   (datetime 2024 7 4 5 10))
  (list (list "多云" (now) 2)
        (list "小雨" (+hours (now) 2) 22))

  (list (list "多云" (now) 2)
        (list "小雨" (+hours (now) 2) 11)
        (list "多云" (+hours (now) 13) 11))

  (list (list "多云" (now) 2)
        (list "小雨" (+hours (now) 2) 1)
        (list "中雨" (+hours (now) 3) 10)
        (list "多云" (+hours (now) 13) 11))

  (list (list "多云" (now) 2)
        (list "小雨" (+hours (now) 2) 1)
        (list "中雨" (+hours (now) 3) 10)
        (list "大雨" (+hours (now) 17) 5)
        (list "多云" (+hours (now) 22) 3))

  (list (list "小雨" (now) 1)
        (list "中雨" (+hours (now) 1) 10)
        (list "大雨" (+hours (now) 11) 5)
        (list "多云" (+hours (now) 16) 10))

  (list (list "小雨" (now) 1)
        (list "中雨" (+minutes (now) 20) 10)
        (list "大雨" (+hours (now) 12) 5)
        (list "多云" (+hours (now) 17) 10))

  (list (list "小雨" (now) 4)
        (list "中雨" (+hours (now) 4) 1)
        (list "多云" (+hours (now) 5) 10)
        (list "爆雨" (+hours (now) 15) 5)
        (list "多云" (+hours (now) 20) 5))

  )
