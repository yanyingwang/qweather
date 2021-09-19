#lang at-exp racket/base

(require racket/string
         racket/list
         racket/format
         gregor
         http-client
         (file "private/params.rkt")
         (file "forecast.rkt"))
(provide qweather/24h/rainsnowy-ai)

(require debug/repl)

(define base-lst/24 '())
(define lid "")

(define (lst/24)
  (when (empty? base-lst/24)
    (define resp
      (hash-ref (http-response-body (weather/24h lid #:lang "cn") )
                'hourly))
    (define res
      (for/list ([e resp])
        (cons (iso8601->moment (hash-ref e 'fxTime))
              (hash-ref e 'text))))
    (set! base-lst/24 res))
  base-lst/24)

;; (define lst/25
;;   (sort (list* lst/0 lst/24) moment<? #:key car))

(define (rainsnowy/pred lst)
  (define str (cdr lst))
  (or (string-contains? str "雨")
      (string-contains? str "雪")
      (string-contains? str "冰")))

;; (define h (hours-between (now/moment) (car rainsnowy/content)))

(define (starting-text)
  (define nowa-content
    (cons (now/moment)
          (hash-ref
           (hash-ref (http-response-body (weather/now lid #:lang "cn")) 'now)
           'text)))
  (define nowa-weather/time (car nowa-weather))
  (define nowa-weather/state (cdr nowa-weather))

  (define (roster) (take (lst/24) 20))
  (define (rainsnowy/index) (index-where (roster) rainsnowy/pred))
  (define (normal/content) (findf (lambda (e) (not (rainsnowy/pred e))) (roster)))

  (define (rainsnowy/content) (list-ref (roster) (rainsnowy/index)))
  (define (rainsnowy/content+1) (list-ref (roster) (add1 (rainsnowy/index))))
  (define (rainsnowy/content+2) (list-ref (roster) (add1 (add1 (rainsnowy/index)))))
  (define (rainsnowy/content+3) (list-ref (roster) (add1 (add1 (add1 (rainsnowy/index))))))
  (define tmptxt "")

  (debug-repl)

  (define (minutes-between (car nowa-content)
                           (car (rainsnowy/content))))

  (cond
    [(and (rainsnowy/pred nowa-weather)
          (not rainsnowy/index))
     (set! @~a{@当前正在下@(cdr nowa-content)，不过雨在1小时内就会停，并且此后3小时内不会再下。})]
    [(and (rainsnowy/pred nowa-weather)
          (= 0 (rainsnowy/index))
          (string=? (cdr (rainsnowy/content))
                    (cdr (nowa-weather))))
     @~a{当前正在下(cdr rainsnowy/content)，}]
    [(and (rainsnowy/pred nowa-weather)
          (= 0 (rainsnowy/index))
          (not (string=? (cdr (rainsnowy/content))
                         (cdr (nowa-weather))))
          (rainsnowy/pred (nowa-weather)))
     @~a{当前正在下@(cdr rainsnowy/content)，但预计1小时内会转@(cdr (rainsnowy/content)),}]
    [(and (not (= 0 (rainsnowy/index))))
     @~a{当前正在下@(cdr (rainsnowy/content))，但预计@(->hours (car (normal/content)))点前会停，其后1小时内会再开始下@(cdr (rainsnowy/content))，}]))

(define (afterward-text)
  (if (string=? (cdr (rainsnowy/content)) (cdr (rainsnowy/content+1)))
      (if (string=? (cdr (rainsnowy/content+1)) (cdr (rainsnowy/content+2)))
          (if (string=? (cdr (rainsnowy/content+2)) (cdr (rainsnowy/content+3)))
              "一直持续3小时以上。"
              @~a{一直持续近2小时后转@(cdr (rainsnowy/content+3))}) ;;;;;
          (if (string=? (cdr (rainsnowy/content+2)) (cdr (rainsnowy/content+3)))
              @~a{一直持续近1小时后会转@(cdr (rainsnowy/content+2))持续2小时以上。}
              @~a{一直持续近1小时后会转@(cdr (rainsnowy/content+2))持续1小时会再转@(cdr (rainsnowy/content+3))持续1小时以上。}))
      (if (string=? (cdr (rainsnowy/content+1)) (cdr (rainsnowy/content+2)))
          (if (string=? (cdr (rainsnowy/content+2)) (cdr (rainsnowy/content+3)))
              @~a{其后1小时转@(cdr (rainsnowy/content+2))持续2小时以上。}
              @~a{其后1小时转@(cdr (rainsnowy/content+2))持续1小时后再转@(cdr (rainsnowy/content+2))持续1小时以上。})
          (if (string=? (cdr (rainsnowy/content+2)) (cdr (rainsnowy/content+3)))
              @~a{其后1小时转@(cdr (rainsnowy/content+1))持续1小时后再转@(cdr (rainsnowy/content+2))持续2小时以上。}
              @~a{其后1小时转@(cdr (rainsnowy/content+1))持续1小时后转@(cdr (rainsnowy/content+2))持续1小时再转@(cdr (rainsnowy/content+3))持续1小时以上。}))))

(define (qweather/24h/rainsnowy-ai location)
  (set! lid location)
  (string-append (starting-text) (afterward-text)))
