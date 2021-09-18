
<!-- README.md is generated from README.Rmd. Please edit that file -->

# siga

<!-- badges: start -->

<!-- badges: end -->

El paquete {siga} descarga y lee datos del [Sistema de Información y
Gestión Agrometeorológica del INTA](http://siga.inta.gov.ar/).

## Installation

Para instalar la versión de desarrollo desde
[GitHub](https://github.com/) usá:

``` r
# install.packages("remotes")
remotes::install_github("AgRoMeteorologiaINTA/siga")
```

## Ejemplo

A continuación se muestra el uso de las funciones. Podés encontrar estos
ejemplos usos en la viñeta, con

``` r
vignette("descarga-datos", "siga")
#> Warning: vignette 'descarga-datos' not found
```

Para acceder a la información de las estaciones diponibles se puede
utilizar la función `siga_estaciones()`

``` r
library(siga)

estaciones <- siga_estaciones()
#> Descargando estaciones y guardando en /tmp/RtmpNbcjMX/siga_metadatos.csv.

head(estaciones)
#>       id             nombre   tipo   localidad  provincia    lat    lon altura
#> 1: 91008  Maria Grande 2da. Omixom Sin asignar Entre Rios -31.69 -59.65      0
#> 2: 91022       Pueblo Cazes Omixom Sin asignar Entre Rios -32.00 -58.53      0
#> 3: 31009 Los Conquistadores Omixom Sin asignar Entre Rios -30.52 -58.40      0
#> 4: 91023         El Redomon Omixom Sin asignar Entre Rios -31.08 -58.28      0
#> 5: 91024           Basualdo Omixom Sin asignar Entre Rios -30.29 -58.66      0
#> 6: 91001       Hernandarias Omixom Sin asignar Entre Rios -31.20 -59.97      0
#>     ubicacion      desde      hasta
#> 1:     Parana 2017-05-23 2017-10-25
#> 2:      Colon 2017-09-20 2019-01-12
#> 3: Federacion 2017-12-05 2018-05-01
#> 4:  Concordia 2017-03-31 2019-01-12
#> 5:  Feliciano 2017-03-31 2019-01-12
#> 6:     Parana 2017-03-31 2019-01-12
```

Por defecto el archivo con los metadatos de las estaciones se descarga
en un directorio o carpeta temporal pero el argumento `archivo` permite
indicar una dirección donde se guardará el archivo o se leerá el archivo
en caso de que ya exista. Esta base de datos puede cambiar con el tiempo
por lo que el argumento `forzar` permite volver a descargar el archivo
de metadatos en caso de ser necesario.

Los metadatos incluyen una columna `id` con un código único por estación
que puede usarse para darcargar los datos meteorológicos de determinadas
estaciones con la función `siga_datos()`.

``` r
ids <- estaciones[1:2, ]
ids
#>       id            nombre   tipo   localidad  provincia    lat    lon altura
#> 1: 91008 Maria Grande 2da. Omixom Sin asignar Entre Rios -31.69 -59.65      0
#> 2: 91022      Pueblo Cazes Omixom Sin asignar Entre Rios -32.00 -58.53      0
#>    ubicacion      desde      hasta
#> 1:    Parana 2017-05-23 2017-10-25
#> 2:     Colon 2017-09-20 2019-01-12
```

``` r
head(siga_datos(ids))
#>       id      fecha temperatura_abrigo_150cm temperatura_abrigo_150cm_maxima
#> 1: 91008 2017-05-23                       NA                              NA
#> 2: 91008 2017-05-24                17.663890                           20.79
#> 3: 91008 2017-05-25                17.490970                           18.79
#> 4: 91008 2017-05-26                12.687220                           15.46
#> 5: 91008 2017-05-27                 9.509024                           15.44
#> 6: 91008 2017-05-28                10.259720                           13.86
#>    temperatura_abrigo_150cm_minima temperatura_intemperie_5cm_minima
#> 1:                              NA                                NA
#> 2:                           16.09                                NA
#> 3:                           15.06                                NA
#> 4:                            8.81                                NA
#> 5:                            4.34                                NA
#> 6:                            6.53                                NA
#>    temperatura_intemperie_50cm_minima temperatura_suelo_5cm_media
#> 1:                                 NA                          NA
#> 2:                                 NA                          NA
#> 3:                                 NA                          NA
#> 4:                                 NA                          NA
#> 5:                                 NA                          NA
#> 6:                                 NA                          NA
#>    temperatura_suelo_10cm_media temperatura_inte_5cm
#> 1:                           NA                   NA
#> 2:                           NA                   NA
#> 3:                           NA                   NA
#> 4:                           NA                   NA
#> 5:                           NA                   NA
#> 6:                           NA                   NA
#>    temperatura_intemperie_150cm_minima humedad_suelo
#> 1:                                  NA            NA
#> 2:                                  NA            NA
#> 3:                                  NA            NA
#> 4:                                  NA            NA
#> 5:                                  NA            NA
#> 6:                                  NA            NA
#>    precipitacion_pluviometrica precipitacion_cronologica
#> 1:                          NA                        NA
#> 2:                         0.6                       0.0
#> 3:                         0.6                       1.2
#> 4:                         0.0                       0.0
#> 5:                         0.2                       0.0
#> 6:                         0.0                       0.2
#>    precipitacion_maxima_30minutos heliofania_efectiva heliofania_relativa
#> 1:                             NA                  NA                  NA
#> 2:                             NA                  NA                  NA
#> 3:                             NA                  NA                  NA
#> 4:                             NA                  NA                  NA
#> 5:                             NA                  NA                  NA
#> 6:                             NA                  NA                  NA
#>    tesion_vapor_media humedad_media humedad_media_8_14_20 rocio_medio
#> 1:                 NA            NA                    NA          NA
#> 2:           19.36102            95                    93   16.979810
#> 3:           18.52402            97                    95   16.224550
#> 4:           12.39480            90                    86    9.955334
#> 5:            9.96277            84                    82    6.830590
#> 6:           12.78541            97                    97   10.466360
#>    duracion_follaje_mojado velocidad_viento_200cm_media direccion_viento_200cm
#> 1:                      NA                           NA                       
#> 2:                      NA                           NA                      C
#> 3:                      NA                           NA                      C
#> 4:                      NA                           NA                      C
#> 5:                      NA                           NA                      C
#> 6:                      NA                           NA                      C
#>    velocidad_viento_1000cm_media direccion_viento_1000cm
#> 1:                            NA                        
#> 2:                            NA                       C
#> 3:                            NA                       C
#> 4:                            NA                       C
#> 5:                            NA                       C
#> 6:                            NA                       C
#>    velocidad_viento_maxima presion_media radiacion_global horas_frio
#> 1:                      NA            NA               NA         NA
#> 2:                      NA            NA               NA   0.000000
#> 3:                      NA            NA               NA   0.000000
#> 4:                      NA            NA               NA   2.158000
#> 5:                      NA            NA               NA   9.295999
#> 6:                      NA            NA               NA   0.830000
#>    unidades_frio
#> 1:            NA
#> 2:    -17.513020
#> 3:    -11.537010
#> 4:      9.212999
#> 5:     13.446010
#> 6:     12.450010
```

Las estaciones puede tener metadatos extra a los que puede accederse con
la función `siga_metadatos()`.

``` r
siga_metadatos(ids)
#>       id            nombre descripcion   localidad  provincia      lon      lat
#> 1: 91008 Maria Grande 2da.          NA Sin asignar Entre Rios -31.6946 -59.6477
#> 2: 91022      Pueblo Cazes          NA Sin asignar Entre Rios -32.0017 -58.5287
```

Para descargar los datos directamente a archivos existe la función
`siga_descargar()`.

``` r
archivos <- siga_descargar(ids)
archivos
#>       id                     datos                           metadatos
#> 1: 91008 /tmp/RtmpNbcjMX/91008.csv /tmp/RtmpNbcjMX/91008_metadatos.csv
#> 2: 91022 /tmp/RtmpNbcjMX/91022.csv /tmp/RtmpNbcjMX/91022_metadatos.csv
#>    descargado
#> 1:       TRUE
#> 2:       TRUE
```

Nuevamente, por defecto se descargan en un directorio temporal pero se
puede indicar una ubicación permanente con el argumento `dir`.

## Cómo contribuir

Para contribuir con este paquete podés leer la siguiente [guía para
contribuir](https://github.com/AgRoMeteorologiaINTA/siga/blob/master/.github/CONTRIBUTING.md).
Te pedimos también que revises nuestro [Código de
Conducta](https://www.contributor-covenant.org/es/version/2/0/code_of_conduct/code_of_conduct.md).
