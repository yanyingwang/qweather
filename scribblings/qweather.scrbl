#lang scribble/manual
@require[@for-label[qweather
                    racket/base
                    racket/contract
                    http-client]
         scribble-rainbow-delimiters]

@script/rainbow-delimiters*

@title{qweather}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
@defmodule[qweather]
Racket wrapper of Qweather(和风天气) API.
@itemlist[
@item{@smaller{Qweather's official quick start guide: @url{https://dev.qweather.com/docs/start/}}}
@item{@smaller{Qweather's official terms explaination：@url{https://dev.qweather.com/docs/start/glossary/}}}
@item{@smaller{Qweather's official API doc: @url{https://dev.qweather.com/docs/api/}}}
]

@(table-of-contents)

@section{Usage Example}
@subsection{Setup Qweather API key and API Host}

@racketinput[
(current-qweather-key "your-qweather-app-key")
(current-qweather-domain "your-qweather-API-domain")
]
@subsection{Get the location id of a city}
@racketinput[
(http-response-body
  (city/lookup "新郑"))
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
]
@subsection{Get the weather forecasting of a city}
@racketinput[
(http-response-body
  (weather/now "101180106"))
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
]

@section{API}
@subsection{Parameters}
@defparam[current-qweather-key v string? #:value ""]{
This key will be automatically included when requesting Qweather's APIs. You can see your key after logining Qweather website and creating an app for your account.
}

@defparam[current-qweather-domain v string? #:value "devapi.qweather.com"]{
Notice: Public API domain had be terminated: @url{https://blog.qweather.com/announce/public-api-domain-change-to-api-host/}. You will have to use your own API domain for the API request.
}


@deftogether[(
@defparam[current-qweather-range v string? #:value "world"]
@defparam[current-qweather-number v number? #:value 10]
@defparam[current-qweather-lang v string? #:value "en"]
@defparam[current-qweather-localtime v boolean? #:value #f]
)]{
@itemlist[
@item{Those parameters are used to control the default values of procedure's arguments, which are described at @secref["wrapped-apis"].}
@item{The valid values of those parameters are very much dictated by the correspondingly available values of procedure's arguments that are specified at @secref["wrapped-apis"].}
]
For example,
@itemlist[
@item{
@racket[(city/lookup "xinzheng")] is same as @linebreak[]
@racket[(city/lookup "xinzheng" #:range "cn")] if I set parameter with below code: @linebreak[]
@racket[(current-qweather-range "cn")].
}
@item{
And in this case, @linebreak[]
the valid values of @racket[current-qweather-range] should be @linebreak[]
@litchar{world} and @litchar{cn} @linebreak[]
because the valid values of @racket[range], as an argument of @racket[city/lookup], @linebreak[]
are @litchar{world} and @litchar{cn}.
}
]
}

@subsection[#:tag "wrapped-apis"]{Wrapped APIs}
@subsubsection{Searching cities}
@defmodule[qweather/city]
The official doc: @url{https://dev.qweather.com/docs/api/geoapi/}

@defproc[(city/lookup [location string?]
                      [#:adm adm string? ""]
                      [#:range range (or/c "world" "cn") (current-qweather-range)]
                      [#:number number number? (current-qweather-number)]
                      [#:lang lang string? (current-qweather-lang)])
http-response]


@defproc[(city/top [#:range range (or/c "world" "cn") (current-qweather-range)]
                   [#:number number number? (current-qweather-number)]
                   [#:lang lang string? (current-qweather-lang)])
http-response]


@defproc[(poi/lookup [location string?]
                      [#:type type string? "scenic"]
                      [#:city city string? ""]
                      [#:number number number? (current-qweather-number)]
                      [#:lang lang string? (current-qweather-lang)])
http-response]


@defproc[(poi/range [location string?]
                    [#:type type string? "scenic"]
                    [#:radius radius number? 10]
                    [#:number number number? (current-qweather-number)]
                    [#:lang lang string? (current-qweather-lang)])
http-response]



@subsubsection{Weather forecasting}
@defmodule[qweather/forecast]
The official doc: @url{https://dev.qweather.com/docs/api/weather/}

@defproc[(weather/now [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response]

@deftogether[(
@defproc[(weather/3d [location string?]
                     [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                     [#:lang lang string? (current-qweather-lang)]
                     [#:unit unit (or/c "m" "i") "m"])
http-response]
@defproc[(weather/7d [location string?]
                     [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                     [#:lang lang string? (current-qweather-lang)]
                     [#:unit unit (or/c "m" "i") "m"])
http-response]
@defproc[(weather/10d [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response]
@defproc[(weather/15d [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response]
)]

@deftogether[(
@defproc[(weather/24h [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response]
@defproc[(weather/72h [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)]
                      [#:unit unit (or/c "m" "i") "m"])
http-response]
@defproc[(weather/168h [location string?]
                       [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                       [#:lang lang string? (current-qweather-lang)]
                       [#:unit unit (or/c "m" "i") "m"])
http-response]
)]

@subsubsection{Disaster warning}
@defmodule[qweather/warning]
The official doc: @url{https://dev.qweather.com/docs/api/warning/}

@defproc[(warning/now [location string?]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)]
                      [#:lang lang string? (current-qweather-lang)])
http-response]

@defproc[(warning/list
                      [#:range range (or/c "cn") (current-qweather-range)]
                      [#:gzip gzip (or/c "y" "n") (current-qweather-gzip)])
http-response]



@subsubsection{AI}
@defmodule[qweather/extend]
This section extended Qweather API to AI functions, which will directly tell you if there is severe weathers in the next.
@bold{This only support to put out the chinese currently.}

@defproc[(weather/24h/severe-weather-ai [location string?]
                      [#:lang lang string? (current-qweather-lang)])
string?]
