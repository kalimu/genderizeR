#' Gender data for authorship sample
#'
#' A dataset with first names and gender data from genderize.io for the sample 
#' of \pkg{authorships} in this package. This is the output 
#' of \code{findGivenNames} 
#' function that was performed on December 26, 2014. 
#'
#' @format A data.table object with 872 rows and 4 variables:
#' \describe{
#'   \item{name}{first name}
#'   \item{gender}{predicted gender}
#'   \item{probability}{how many persons in with this first name 
#'   has the predicted gender}
#'   \item{count}{how many persons in the genderize.io database 
#'   had that first name}
#' }
#' @source \url{http://genderize.io/}
#' 
#' 


"givenNamesDB_authorships"

# givenNamesDB_authorships = readRDS("data-raw/givenNamesDB_authorships.rds")
# devtools::use_data(givenNamesDB_authorships)
