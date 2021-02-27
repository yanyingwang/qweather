#lang scribble/manual
@require[@for-label[qweather
                    racket/base
                    racket/pretty
                    http-client]]

@title{qweather}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
@defmodule[qweather]
@section-index["timable"]
Racket wrapper of Qweather(和风天气) API.
@itemlist[
@item{@smaller{Qweather's official quick start guide: @url{https://dev.qweather.com/docs/start/}}}
@item{@smaller{Qweather's official terms explaination：@url{https://dev.qweather.com/docs/start/glossary/}}}
@item{@smaller{Qweather's official API doc: @url{https://dev.qweather.com/docs/api/}}}
]
@(table-of-contents)


@section{Usage Example}
@subsection{Setup Qweather API key}
@codeblock|{
-> (current-qweather-key "your-qweather-app-key")
}|
@subsection{Get the location id of 新郑 city}
@codeblock|{
-> (pretty-print
     (http-response-body
       (city/lookup "新郑")))
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
}|
@subsection{Get the weather forecasting of 新郑 city}
@codeblock|{
-> (pretty-print
     (http-response-body
       (weather/now "101180106")))
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
This key will be automatically included in the requesting of Qweather's APIs, you can get the key through signuping Qweather website and creating an app for your account.
}

@defparam[current-qweather-domain v string? #:value "devapi.qweather.com"]{
For using a business version of Qweather account, you need to set this parameter to @litchar{api.qweather.com}.
}


@deftogether[(
@defparam[current-qweather-range v string? #:value "world"]
@defparam[current-qweather-number v number? #:value 10]
@defparam[current-qweather-gzip v string? #:value "y"]
@defparam[current-qweather-lang v string? #:value "en"]
)]{
@itemlist[
@item{Those parameters are used to controller the default values of procedures arguments described from @secref["wrapped-apis"].}
@item{The available values of those parameters are very much dictated by the correspondingly available values of procedure arguments described from @secref["wrapped-apis"].}
]
For example,
@itemlist[
@item{@racket[(city/lookup "xinzheng")] is same as @linebreak[]
@racket[(city/lookup "xinzheng" #:range "cn")] if I set parameter @linebreak[]
@racket[(current-qweather-range "cn")].}
@item{And for the case, @linebreak[]
the avaiable values of @racket[current-qweather-range] should be @linebreak[]
@litchar{world} and @litchar{cn} because of @linebreak[]
the available values of @racket[range] argument of @racket[city/lookup] is @linebreak[]
@litchar{world} and @litchar{cn}.}
]
}

@subsection[#:tag "wrapped-apis"]{Wrappered APIs}
@subsubsection{Searching cities}
@defmodule[qweather/city]
The official doc: @url{https://dev.qweather.com/docs/api/geo/}

@defproc[(city/lookup [location string?]
                      [#:adm adm string? ""]
                      [#:range range (or/c "world" "cn") (current-qweather-range)]
                      [#:number number number? (current-qweather-number)]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)])
http-response?]


@defproc[(city/top [#:range range (or/c "world" "cn") (current-qweather-range)]
                   [#:number number number? (current-qweather-number)]
                   [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                   [#:lang lang string? (current-qweather-lang)])
http-response?]


@defproc[(poi/lookup [location string?]
                      [#:type type string? "scenic"]
                      [#:city city string? ""]
                      [#:number number number? (current-qweather-number)]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)])
http-response?]


@defproc[(poi/range [location string?]
                    [#:type type string? "scenic"]
                    [#:radius radius number? 10]
                    [#:number number number? (current-qweather-number)]
                    [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                    [#:lang lang string? (current-qweather-lang)])
http-response?]



@subsubsection{Weather forecasting}
@defmodule[qweather/forecast]
The official doc: @url{https://dev.qweather.com/docs/api/weather/}

@defproc[(weather/now [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]

@deftogether[(
@defproc[(weather/3d [location string?]
                     [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                     [#:lang lang string? (current-qweather-lang)]
                     [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/7d [location string?]
                     [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                     [#:lang lang string? (current-qweather-lang)]
                     [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/10d [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/15d [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
)]

@deftogether[(
@defproc[(weather/24h [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/72h [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response?]
@defproc[(weather/168h [location string?]
                       [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                       [#:lang lang string? (current-qweather-lang)]
                       [#:unit unit (or/c "m" "i") "m"])
http-response?]
)]

@subsubsection{Disaster warning}
@defmodule[qweather/warning]
The official doc: @url{https://dev.qweather.com/docs/api/warning/}

@defproc[(warning/now [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)])
http-response?]

@defproc[(warning/list
                      [#:range range (or/c "cn") (current-qweather-range)]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)])
http-response?]


@section{Change Logs}
@itemlist[
@item{}
]
