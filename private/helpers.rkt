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

(define (->weather-v7 entry)
  (hash 'fxDate (hash-ref entry 'forecastStartTime)
        'sunrise (hash-ref (hash-ref entry 'astro) 'sunrise)
        'sunset	(hash-ref (hash-ref entry 'astro) 'sunset)
        'moonrise (hash-ref (hash-ref entry 'astro) 'moonrise)
        'moonset (hash-ref (hash-ref entry 'astro) 'moonset)
        'moonPhaseEn (hash-ref (hash-ref entry 'astro) 'moonPhase)
        'moonPhase (->moonPhaseCn (hash-ref (hash-ref entry 'astro) 'moonPhase))
        'tempMax (hash-ref (hash-ref entry 'temperatureMax) 'value)
        'tempMin (hash-ref (hash-ref entry 'temperatureMin) 'value)
        'textDay (hash-ref (hash-ref (hash-ref entry 'daytime) 'condition) 'text)
        'textNight (hash-ref (hash-ref (hash-ref entry 'nighttime) 'condition) 'text)
        'windDirDayEn (hash-ref (hash-ref (hash-ref (hash-ref entry 'daytime) 'wind) 'direction) 'compass)
        'windDirDay	(->windDirCn (hash-ref (hash-ref (hash-ref (hash-ref entry 'daytime) 'wind) 'direction) 'compass))
        'windScaleDay	(hash-ref (hash-ref (hash-ref entry 'daytime) 'wind) 'scale)
        'windDirNightEn (hash-ref (hash-ref (hash-ref (hash-ref entry 'nighttime) 'wind) 'direction) 'compass)
        'windDirNight	(->windDirCn (hash-ref (hash-ref (hash-ref (hash-ref entry 'nighttime) 'wind) 'direction) 'compass))
        'windScaleNight	(hash-ref (hash-ref (hash-ref entry 'nighttime) 'wind) 'scale)
        'humidityDay (hash-ref (hash-ref entry 'daytime) 'humidity)
        'humidityNight (hash-ref (hash-ref entry 'nighttime) 'humidity)
        )
  )

(define (->moonPhaseCn txt)
  (hash-ref (hash "new-moon" "新月"
                  "waxing-crescent" "蛾眉月"
                  "first-quarter" "上弦月"
                  "waxing-gibbous" "盈凸月"
                  "full-moon" "满月"
                  "waning-gibbous" "亏凸月"
                  "last-quarter" "下弦月"
                  "waning-crescent" "残月") txt))


(define (->windDirCn txt)
  (hash-ref (hash "n" "北风"
                  "nne" "东北偏北风"
                  "ne" "东北风"
                  "ene" "东北偏东风"
                  "e" "东风"
                  "ese" "东南偏东风"
                  "se" "东南风"
                  "sse" "东南偏南风"
                  "s" "南风"
                  "ssw" "西南偏南风"
                  "sw" "西南风"
                  "wsw" "西南偏西风"
                  "w" "西风"
                  "wnw" "西北偏西风"
                  "nw" "西北风"
                  "nnw" "西北偏北风"
                  "none" "无持续风向"
                  "vrb" "风向变化不定"
                  ) txt))
