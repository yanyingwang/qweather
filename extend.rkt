#lang at-exp racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         http-client
         (file "private/params.rkt")
         (file "forecast.rkt"))

(current-qweather-lang "cn")

(define nowa-weather
  (cons (now/moment)
        (hash-ref
         (hash-ref (http-response-body (weather/now "101180106")) 'now)
         'text)))

(define lst/24
  (for/list ([e (hash-ref (http-response-body (weather/24h "101180106"))
                          'hourly)])
    (cons  (iso8601->moment (hash-ref e 'fxTime))
           (hash-ref e 'text))))

;; (define lst/25
;;   (sort (list* lst/0 lst/24) moment<? #:key car))

(define (rainsnowy/pred lst)
  (let ([str (cdr lst)])
    (or (string-contains? str "雨")
        (string-contains? str "雪")
        (string-contains? str "冰"))))

(define waiting-lst (take lst/24 20))
(define rainsnowy/index (index-where waiting-lst rainsnowy/pred))

(define rainsnowy/content (list-ref waiting-lst rainsnowy/index))
(define rainsnowy/content+1 (list-ref waiting-lst (add1 rainsnowy/index)))
(define rainsnowy/content+2 (list-ref waiting-lst (add1 (add1 rainsnowy/index))))
(define rainsnowy/content+3 (list-ref waiting-lst (add1 (add1 (add1 rainsnowy/index)))))

;; (define h (hours-between (now/moment) (car rainsnowy/content)))

(define (qihou-text)
  (if (string=? (cdr rainsnowy/content) (cdr rainsnowy/content+1))
      (if (string=? (cdr rainsnowy/content+1) (cdr rainsnowy/content+2))
          (if (string=? (cdr rainsnowy/content+2) (cdr rainsnowy/content+3))
              "一直持续3小时以上"
              @~a{一直持续近2小时后转@(cdr rainsnowy/content+3)}) ;;;;;
          (if (string=? (cdr rainsnowy/content+2) (cdr rainsnowy/content+3))
              @~a{一直持续近1小时后转@(cdr rainsnowy/content+2)持续2小时以上}
              @~a{一直持续近1小时后转@(cdr rainsnowy/content+2)持续1小时再转@(cdr rainsnowy/content+3)持续1小时以上}))

      (if (string=? (cdr rainsnowy/content+1) (cdr rainsnowy/content+2))
          (if (string=? (cdr rainsnowy/content+2) (cdr rainsnowy/content+3))
              @~a{其后1小时转@(cdr rainsnowy/content+2)持续2小时以上}
              @~a{其后1小时转@(cdr rainsnowy/content+2)持续1小时后再转@(cdr rainsnowy/content+2)持续1小时以上})
          (if (string=? (cdr rainsnowy/content+2) (cdr rainsnowy/content+3))
              @~a{其后1小时转@(cdr rainsnowy/content+1)持续1小时后再转@(cdr rainsnowy/content+2)持续2小时以上}
              @~a{其后1小时转@(cdr rainsnowy/content+1)持续1小时后转@(cdr rainsnowy/content+2)持续1小时再转@(cdr rainsnowy/content+3)持续1小时以上}))))

(define (qweather/rainsnowy-ai)
  (if (and rainsnowy/index
           (not (string=? (cdr nowa-weather)
                     (cdr rainsnowy/content))))
      @~a{预计今天@(->hours (car rainsnowy/content))点开始下@(cdr rainsnowy/content)，@(qihou-text)。}
      #f))
