#' Descarga archivos del SIGA
#'
#' Esta familia de funciones permite leer y descargar archivos con datos
#' meteorológicos y sus metadatos desde SIGA.
#'
#' @param ids Vector de ids con estaciones o un data.frame con una
#' columna llamada "id" con las ids de las estaciones (por ejemplo, el
#' data.frame devuelto por [siga_estaciones()]).
#' @param dir Caracter, directorio donde descargar los datos. Por defecto
#' se descargan los datos en un directorio temporal.
#' @param forzar Forzar la descarga de archivos ya descargados.
#'
#' @return
#' data.frames
#'
#' @examples
#' estaciones <- siga_estaciones()
#' ids <- estaciones[1:2, ]
#' siga_datos(ids)
#'
#' # Metadatos
#' siga_metadatos(ids)
#'
#' # Descarga directa
#' siga_descargar(ids)
#'
#' @export
siga_datos <- function(ids, dir = tempdir(), forzar = FALSE) {
  files <- siga_descargar(ids = ids, dir = dir, forzar = forzar)
  files <- files$datos[files$descargado == TRUE]

  data <- data.table::rbindlist(lapply(files, data.table::fread), fill = TRUE,
                        use.names = TRUE)
  return(data)
}

#' @export
#' @rdname siga_datos
siga_metadatos <- function(ids, dir = tempdir(), forzar = FALSE) {
  files <- siga_descargar(ids = ids, dir = dir, forzar = forzar)
  files <- files$metadatos[files$descargado == TRUE]

  data <- data.table::rbindlist(lapply(files, data.table::fread), fill = TRUE,
                                use.names = TRUE)

  return(data)
}


#' @export
#' @rdname siga_datos
siga_descargar <- function(ids, dir = tempdir(), forzar = TRUE) {
  if (inherits(ids, "data.frame")) {
    ids <- ids$id
  }

  data_files <- file.path(dir, paste0(ids, ".csv"))
  metadata_files <- file.path(dir, paste0(ids, "_metadatos.csv"))
  dir.create(dir, showWarnings = FALSE)

  status <- rep(0, length(ids))

  base <- "http://siga.inta.gob.ar/document/series/"
  filenames <- paste0(ids, ".xls")
  urls <- paste0(base, filenames)
  locations <- file.path(tempdir(), filenames)

  col_types <- c("text", rep("numeric", 21), "text", "numeric", "text", rep("numeric", 9))
  col_types2 <- c("text", rep("numeric", 21), "text", "numeric", "text", rep("numeric", 5))

  for (i in seq_along(ids)) {
    must_download <- forzar || !file.exists(data_files[i])
    if (must_download) {
      download <- try(utils::download.file(url = urls[i], destfile = locations[i], mode = "wb"), silent = TRUE)

      if (inherits(download, "try-error")) {
        status[i] <- 1
        next
      }

      data <- try(suppressWarnings(readxl::read_excel(locations[i], col_types = col_types)), silent = TRUE)

      if (inherits(data, "try-error")) {
        data <- suppressWarnings(readxl::read_excel(locations[i], col_types = col_types2))
      }

      colnames(data) <- tolower(colnames(data))
      data$fecha <- as.Date(strptime(data$fecha, "%Y-%m-%d %H:%M:%S"))
      data$id <- ids[i]
      data.table::setcolorder(data, "id")
      data.table::fwrite(data, data_files[i])

      metadata <- readxl::read_excel(locations[i], sheet = 2,
                                     col_types = c(rep("text", 5), rep("numeric", 2)))
      colnames(metadata)[c(1, 6, 7)] <- c("id", "lon", "lat")

      colnames(metadata) <- tolower(colnames(metadata))

      data.table::fwrite(metadata, metadata_files[i])
    }
  }

  if (any(status != 0)) {
    fails <- paste0(ids[status != 0], collapse = "\n  * ")
    warning("Algunas estaciones no se pudieron descargar:\n  * ", fails)
  }

  return(
    data.table::data.table(
      id = ids,
      datos = data_files,
      metadatos = metadata_files,
      descargado = status == 0)
  )
}



#' Estaciones disponibles en el SIGA
#'
#' La función descarga los metadatos de las estaciones meteorológicas disponibles en el SIGA.
#'
#' @param archivo Caracter, indica la ruta al archivo donde guardará la lista de estaciones.
#' Por defecto se guarda en un directorio temporal.
#' @param forzar Lógico, si es TRUE, fuerza la descarga del archivo de metadatos ya descargado.
#'
#' @return
#' Un data.frame con metadatos de las estaciones.
#'
#' @examples
#' estaciones <- siga_estaciones()
#' head(estaciones)
#'
#' @export
siga_estaciones <- function(archivo = file.path(tempdir(), "siga_metadatos.csv"), forzar = FALSE) {
  dir.create(dirname(archivo), showWarnings = FALSE)

  must_download <- forzar || !file.exists(archivo)

  if (must_download) {
    message(gettextf("Descargando estaciones y guardando en %s.", archivo))
    url <- stations_url()

    json <- jsonlite::read_json(url)

    campos <- c("idInterno", "nombre", "tipo", "localidad", "provincia",
                "latitud", "longitud", "altura", "ubicacion", "minimoDiario", "maximoDiario")

    json <- lapply(json, function(x) {
      x <- x[campos]
      names(x)[c(1, 6, 7, 10, 11)] <- c("id", "lat", "lon", "desde", "hasta")
      x
    })

    metadatos <- suppressWarnings(data.table::rbindlist(json))

    data.table::fwrite(metadatos, archivo)
  } else {
    message(gettextf("Cargando estaciones de %s.", archivo))
  }

  metadatos <- data.table::fread(archivo)

  metadatos
}

stations_url <- function() {
  servers <- "http://siga.inta.gob.ar/js/urlserver.js"

  file <- tempfile()
  utils::download.file(servers, file, quiet = TRUE)

  lines <- suppressWarnings(readLines(file))
  l <- grep("^var URL_MYSQL_ESTACION =", lines)[1]

  line <- strsplit(lines[l], " = ")[[1]][2]
  line <- regmatches(line, regexpr("'.*'", line))
  line <- gsub("'", "", line)

  url <- paste0("http://siga.inta.gob.ar/", line)

  return(url)
}

.datatable.aware <- TRUE
