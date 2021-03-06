% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/siga-desgarcar.R
\name{siga_descargar}
\alias{siga_descargar}
\title{Descarga archivos del SIGA}
\usage{
siga_descargar(ids, dir = tempdir(), forzar = FALSE)
}
\arguments{
\item{ids}{Vector de ids con estaciones o un data.frame con una
columna llamada "id" con las ids de las estaciones (por ejemplo, el
devuelto por \code{\link[=siga_metadatos]{siga_metadatos()}}).}

\item{dir}{Directorio donde descargar los datos.}

\item{forzar}{Forzar la descarga de archivos ya descargados.}
}
\description{
Descarga archivos del SIGA
}
