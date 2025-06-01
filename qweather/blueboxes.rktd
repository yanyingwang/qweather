1306
((3) 0 () 4 ((q lib "qweather/forecast.rkt") (q lib "qweather/main.rkt") (q lib "qweather/city.rkt") (q lib "qweather/warning.rkt")) () (h ! (equal) ((c def c (c (? . 2) q poi/lookup)) q (1648 . 13)) ((c def c (c (? . 1) q current-qweather-gzip)) q (476 . 5)) ((c def c (c (? . 0) q weather/now)) q (2666 . 9)) ((c def c (c (? . 0) q weather/168h)) q (5094 . 9)) ((c def c (c (? . 1) q current-qweather-key)) q (0 . 5)) ((q def ((lib "qweather/extend.rkt") weather/24h/severe-weather-ai)) q (5906 . 5)) ((c def c (c (? . 1) q current-qweather-lang)) q (588 . 5)) ((c def c (c (? . 1) q current-qweather-range)) q (243 . 5)) ((c def c (c (? . 2) q poi/range)) q (2159 . 13)) ((c def c (c (? . 0) q weather/3d)) q (3014 . 9)) ((c def c (c (? . 0) q weather/24h)) q (4398 . 9)) ((c def c (c (? . 3) q warning/list)) q (5716 . 4)) ((c def c (c (? . 1) q current-qweather-domain)) q (109 . 5)) ((c def c (c (? . 1) q current-qweather-number)) q (361 . 5)) ((c def c (c (? . 0) q weather/15d)) q (4050 . 9)) ((c def c (c (? . 0) q weather/10d)) q (3702 . 9)) ((c def c (c (? . 3) q warning/now)) q (5446 . 7)) ((c def c (c (? . 0) q weather/7d)) q (3358 . 9)) ((c def c (c (? . 0) q weather/72h)) q (4746 . 9)) ((c def c (c (? . 2) q city/top)) q (1248 . 9)) ((c def c (c (? . 2) q city/lookup)) q (701 . 13))))
parameter
(current-qweather-key) -> string?
(current-qweather-key v) -> void?
  v : string?
 = ""
parameter
(current-qweather-domain) -> string?
(current-qweather-domain v) -> void?
  v : string?
 = "devapi.qweather.com"
parameter
(current-qweather-range) -> string?
(current-qweather-range v) -> void?
  v : string?
 = "world"
parameter
(current-qweather-number) -> number?
(current-qweather-number v) -> void?
  v : number?
 = 10
parameter
(current-qweather-gzip) -> string?
(current-qweather-gzip v) -> void?
  v : string?
 = "y"
parameter
(current-qweather-lang) -> string?
(current-qweather-lang v) -> void?
  v : string?
 = "en"
procedure
(city/lookup  location            
             [#:adm adm           
              #:range range       
              #:number number     
              #:gzip gzip         
              #:lang lang])   -> http-response
  location : string?
  adm : string? = ""
  range : (or/c "world" "cn") = (current-qweather-range)
  number : number? = (current-qweather-number)
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
procedure
(city/top [#:range range       
           #:number number     
           #:gzip gzip         
           #:lang lang])   -> http-response
  range : (or/c "world" "cn") = (current-qweather-range)
  number : number? = (current-qweather-number)
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
procedure
(poi/lookup  location            
            [#:type type         
             #:city city         
             #:number number     
             #:gzip gzip         
             #:lang lang])   -> http-response
  location : string?
  type : string? = "scenic"
  city : string? = ""
  number : number? = (current-qweather-number)
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
procedure
(poi/range  location            
           [#:type type         
            #:radius radius     
            #:number number     
            #:gzip gzip         
            #:lang lang])   -> http-response
  location : string?
  type : string? = "scenic"
  radius : number? = 10
  number : number? = (current-qweather-number)
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
procedure
(weather/now  location          
             [#:gzip gzip       
              #:lang lang       
              #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/3d  location          
            [#:gzip gzip       
             #:lang lang       
             #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/7d  location          
            [#:gzip gzip       
             #:lang lang       
             #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/10d  location          
             [#:gzip gzip       
              #:lang lang       
              #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/15d  location          
             [#:gzip gzip       
              #:lang lang       
              #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/24h  location          
             [#:gzip gzip       
              #:lang lang       
              #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/72h  location          
             [#:gzip gzip       
              #:lang lang       
              #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(weather/168h  location          
              [#:gzip gzip       
               #:lang lang       
               #:unit unit]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
  unit : (or/c "m" "i") = "m"
procedure
(warning/now  location          
             [#:gzip gzip       
              #:lang lang]) -> http-response
  location : string?
  gzip : (or/c "y" "n") = (current-qweather-gzip)
  lang : string? = (current-qweather-lang)
procedure
(warning/list [#:range range #:gzip gzip]) -> http-response
  range : (or/c "cn") = (current-qweather-range)
  gzip : (or/c "y" "n") = (current-qweather-gzip)
procedure
(weather/24h/severe-weather-ai  location          
                               [#:lang lang]) -> string?
  location : string?
  lang : string? = (current-qweather-lang)
