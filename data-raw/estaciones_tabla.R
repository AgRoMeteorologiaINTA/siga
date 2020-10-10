## code to prepare `estaciones` dataset goes here

estaciones_tabla <- data.table::fread("data-raw/estaciones_tabla.csv")

colnames(estaciones_tabla) <- tolower(colnames(estaciones_tabla))
colnames(estaciones_tabla) <- gsub(" ", "_", colnames(estaciones_tabla))


estaciones_tabla <- estaciones_tabla[longitud < -40]

data.table::setcolorder(estaciones_tabla, "id_interno")
data.table::setcolorder(estaciones_tabla, "id_interno")

data.table::setnames(estaciones_tabla, c("id_interno", "id", "longitud", "latitud"),
                     c("id", "id_alternativo", "lon", "lat"))
estaciones_tabla[, hasta := NULL]
estaciones_tabla[, desde := lubridate::dmy(desde)]

usethis::use_data(estaciones_tabla, overwrite = TRUE, internal = TRUE)

