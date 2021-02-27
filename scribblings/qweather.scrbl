#lang scribble/manual
@require[@for-label[qweather
                    racket/base
                    racket/pretty
                    http-client]]

@title{qweather}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
@defmodule[qweather]
@section-index["timable"]
Racket wrapper for Qweather/和风天气 open API. @linebreak[]
Check its official API doc at @url{https://dev.qweather.com/docs/start/}.

@(table-of-contents)


@section{Simple Usage Example}
@codeblock|{
-> (current-qweather-key "your-qweather-app-key")
-> (pretty-print (http-response-body (city/lookup "xinzheng")))
'#hasheq((code . "200")
         (location
          .
          (#hasheq((adm1 . "Henan")
                   (adm2 . "Zhengzhou")
                   (country . "China")
                   (fxLink . "http://hfx.link/2qp1")
                   (id . "101180106")
                   (isDst . "0")
                   (lat . "34.39421")
                   (lon . "113.73966")
                   (name . "Xinzheng")
                   (rank . "33")
                   (type . "city")
                   (tz . "Asia/Shanghai")
                   (utcOffset . "+08:00"))))
         (refer
          .
          #hasheq((license . ("commercial license"))
                  (sources . ("qweather.com")))))
-> (pretty-print (http-response-body (weather/now "101180106")))
'#hasheq((code . "200")
         (fxLink . "http://hfx.link/2qp1")
         (now
          .
          #hasheq((cloud . "98")
                  (dew . "3")
                  (feelsLike . "6")
                  (humidity . "66")
                  (icon . "154")
                  (obsTime . "2021-02-27T17:53+08:00")
                  (precip . "0.0")
                  (pressure . "1018")
                  (temp . "9")
                  (text . "Overcast")
                  (vis . "7")
                  (wind360 . "135")
                  (windDir . "SE")
                  (windScale . "3")
                  (windSpeed . "12")))
         (refer
          .
          #hasheq((license . ("no commercial use"))
                  (sources . ("Weather China"))))
         (updateTime . "2021-02-27T18:26+08:00"))
}|


@section{Reference}
@subsection{Parameters}
@defparam[current-qweather-key v string? #:value ""]{
This key will be automatically include in the requesting of Qweather's APIs, you can get the key through signuping Qweather website and creating an app for your account.
}

@defparam[current-qweather-domain v string? #:value "devapi.qweather.com"]{
For a business version of Qweather account, you need set this parameter to @litchar{api.qweather.com}.
}


@subsection{Searching cities}
@defmodule[qweather/city]
The official doc: @url{https://dev.qweather.com/docs/api/geo/}

@defproc[(city/lookup [location string?]
                      [#:adm adm string? ""]
                      [#:range range (or/c "world" "cn") "world"]
                      [#:number number number? 10]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"])
http-response?]


@defproc[(city/top [#:range range (or/c "world" "cn") "world"]
                   [#:number number number? 10]
                   [#:gzip gzip (or/c "y" "n") "y"]
                   [#:lang lang string? "en"])
http-response?]


@defproc[(poi/lookup [location string?]
                      [#:type type string? "scenic"]
                      [#:city city string? ""]
                      [#:number number number? 10]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"])
http-response?]


@defproc[(poi/range [location string?]
                    [#:type type string? "scenic"]
                    [#:radius radius number? 10]
                    [#:number number number? 10]
                    [#:gzip gzip (or/c "y" "n") "y"]
                    [#:lang lang string? "en"])
http-response?]



@subsection{Weather forecast}
@defmodule[qweather/forecast]
The official doc: @url{https://dev.qweather.com/docs/api/weather/}

@defproc[(weather/now [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]

@deftogether[(
@defproc[(weather/3d [location string?]
                     [#:gzip gzip (or/c "y" "n") "y"]
                     [#:lang lang string? "en"]
                     [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/7d [location string?]
                     [#:gzip gzip (or/c "y" "n") "y"]
                     [#:lang lang string? "en"]
                     [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/10d [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/15d [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
)]

@deftogether[(
@defproc[(weather/24h [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/72h [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/168h [location string?]
                       [#:gzip gzip (or/c "y" "n") "y"]
                       [#:lang lang string? "en"]
                       [#:unit unit (or/c "m" "i") "m"])
http-response?]
)]

@subsection{Disaster warning}
@defmodule[qweather/warning]
The official doc: @url{https://dev.qweather.com/docs/api/warning/}

@defproc[(warning/now [location string?]
                      [#:gzip gzip (or/c "y" "n") "y"]
                      [#:lang lang string? "en"])
http-response?]

@defproc[(warning/list
                      [#:range range (or/c "cn") "cn"]
                      [#:gzip gzip (or/c "y" "n") "y"])
http-response?]


@section{Change Logs}
@itemlist[
@item{}
]
