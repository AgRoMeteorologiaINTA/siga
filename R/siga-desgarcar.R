#' Descarga archivos del SIGA
#'
#' @param ids Vector de ids con estaciones o un data.frame con una
#' columna llamada "id" con las ids de las estaciones (por ejemplo, el
#' devuelto por [siga_metadatos()]).
#' @param dir Directorio donde descargar los datos.
#' @param forzar Forzar la descarga de archivos ya descargados.
#'
#' @export
siga_descargar <- function(ids, dir = tempdir(), forzar = FALSE) {

  if (inherits(ids, "data.frame")) {
    ids <- ids$id
  }

  base <- "http://siga.inta.gov.ar/document/series/"
  filenames <- paste0(ids, ".xls")
  locations <- file.path(tempdir(), filenames)
  final_files <- file.path(dir, paste0(ids, ".csv"))

  urls <- paste0(base, filenames)
  status <- rep(0, length(urls))
  col_types <- c("text", rep("numeric", 21), "text", "numeric", "text", rep("numeric", 5))

  for (i in seq_along(urls)) {
    must_download <- forzar || !file.exists(final_files[i])

    if (must_download) {
      download <- try(utils::download.file(url = urls[i], destfile = locations[i]), silent = TRUE)
      data <- readxl::read_xls(locations[i], col_types = col_types)
      colnames(data) <- tolower(colnames(data))
      data$fecha <- as.Date(strptime(data$fecha, "%Y-%m-%d %H:%M:%S"))
      data$id <- ids[i]
      data.table::setcolorder(data, "id")
      data.table::fwrite(data, final_files[i])

      if (inherits(download, "try-error")) {
        status[i] <- 1
      } else {
        status[i] <- download
      }
    }
  }

  if (any(status != 0)) {
    fails <- paste0(ids[status != 0], collapse = "\n  * ")
    warning("Algunas estaciones no se pudieron descargar:\n  * ", fails)
  }

  final_files[status != 0] <- NA
  return(final_files)
}

#' Estaciones disponibles en SIGA
#'
#' @export
siga_metadatos <- function() {
  estaciones_tabla
}


.datatable.aware <- TRUE
