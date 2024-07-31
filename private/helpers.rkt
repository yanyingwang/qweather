#lang at-exp racket/base

(require timable/gregor gregor racket/format racket/string)
(provide (all-defined-out))


(define (severe-weather? i)
  (severe-weather-str? (car i)))
(define (severe-weather-str? str)
  (or (string-contains? str "雨")
      (string-contains? str "雪")
      (string-contains? str "冰")))


(define (->cn-day-text m)
  (cond
    [(= (->day m)
        (->day (today)))
     "今天"]
    [(= (->day m)
        (->day (days-from-now 1)))
     "明天"]
    [(= (->day m)
        (->day (days-from-now 2)))
     "后天"]
    [(= (->day m)
        (->day (days-from-now 3)))
     "大后天"]
    [else @~a{@(->month m)月@(->day m)日}]
    )
  )

(define (->cn-hour-text m) ;; fix: 11:40 should be 12点
  (case (->hours m)
    [(00) "凌晨0点"]
    [(01) "凌晨1点"]
    [(02) "凌晨2点"]
    [(03) "凌晨3点"]
    [(04) "清晨4点"]
    [(05) "清晨5点"]
    [(06) "早上6点"]
    [(07) "早上7点"]
    [(08) "上午8点"]
    [(09) "上午9点"]
    [(10) "上午10点"]
    [(11) "上午11点"]
    [(12) "中午12点"]
    [(13) "下午1点"]
    [(14) "下午2点"]
    [(15) "下午3点"]
    [(16) "下午4点"]
    [(17) "下午5点"]
    [(18) "晚上6点"]
    [(19) "晚上7点"]
    [(20) "晚上8点"]
    [(21) "晚上9点"]
    [(22) "夜晚10点"]
    [(23) "深夜11点"]
    )
  )

(define (->cn-dt-text dt)
  (if (< (minutes-between (now) dt) 60)
      @~a{@(minutes-between (now) dt)分钟后}
      (string-append (->cn-day-text dt) (->cn-hour-text dt)))
  )
