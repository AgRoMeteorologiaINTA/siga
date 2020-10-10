#' Lee archivos de SIGA
#'
#' @param archivos Vector de archivos a leer.
#'
#' @export
siga_leer <- function(archivos) {
  col_types <- c("character", "IDate", rep("numeric", 21),
                 "character", "numeric", "character", rep("numeric", 5))

  data <- lapply(archivos, function(archivo) {
    if (is.na(archivo)) {
      return(NULL)
    }
    data.table::fread(archivo, colClasses = col_types)
  })

  data <- data.table::rbindlist(data)
  return(data)
}
