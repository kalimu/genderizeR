
.onAttach <- function(libname, pkgname) {
    
    packageStartupMessage(paste0('\nWelcome to genderizeR package version: ',
                                 utils::packageVersion("genderizeR"))
                          )
    packageStartupMessage("\nChangelog: news(package = 'genderizeR')")
    packageStartupMessage("Help & Contact: help(genderizeR)")
    
    packageStartupMessage("\nIf you find this package useful cite it please. Thank you! ")
    packageStartupMessage("See: citation('genderizeR')")

    
    packageStartupMessage("\nTo suppress this message use:\nsuppressPackageStartupMessages(library(genderizeR))")        	
			
}


 

#' Gender Prediction Based on First Names
#'
#' The \code{genderizeR} package uses genderize.io API to predict 
#' gender from first names extracted from text corpuses. The accuracy 
#' of prediction could be controlled by two parameters: 
#' counts of first names in database and probability of gender 
#' given the first name.  
#'
#'
#' @docType package
#' 
#' @name genderizeR
#' 
#'
#' @importFrom magrittr "%>%"
#' @importFrom data.table ":="
#' @import utils
#' 
#' 
#' @seealso 
#' \itemize{
#'   \item \url{http://genderize.io/} [Homepage of genderize.io API]
#'   \item \url{https://github.com/kalimu/genderizeR} [R package source code]
#'   \item \url{http://www.wais.kamil.rzeszow.pl/genderizeR} [R package homepage]
#' }
#' 
# @export
#' 
#@keywords internal
 
NULL
 
# detach("package:genderizeR", unload=TRUE)
# devtools::show_news()
