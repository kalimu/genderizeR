
.onAttach <- function(libname, pkgname) {
    
    packageStartupMessage(paste0('genderizeR Package version: ',
                                 utils::packageVersion("genderizeR"))
                          )
    packageStartupMessage("\nSee what's new: news(package = 'genderizeR')")
    packageStartupMessage("\nSee help: help(genderizeR)")
    
    packageStartupMessage("\nIf you find this package useful cite it please. Thank you! ")
    packageStartupMessage("See: citation('genderizeR')")

}

#' An R package for predicting gender from first names
#'
#' The \code{genderizeR} package uses genderize.io API to predict gender from first names extracted from text corpuses. The accuracy of prediction could be control by two parameters: counts of first names in database and probability of gender given the first name.  
#'
#'
#' @docType package
#' 
#' @name genderizeR
#' 
#' @seealso 
#' \itemize{
#'   \item \url{https://github.com/kalimu/genderizeR} [R package source code]
#'   \item \url{http://www.wais.kamil.rzeszow.pl/genderizeR} [R package homepage]
#' }
#' 
#' 
#@keywords internal
 
NULL
 
# detach("package:genderizeR", unload=TRUE)
# devtools::show_news()
