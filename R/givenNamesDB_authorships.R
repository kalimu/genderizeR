#' Gender data for authorship sample
#'
#' A dataset with first names and gender data from genderize.io for  
#' \pkg{authorships} dataset in the package. This is the output 
#' of \code{findGivenNames} 
#' function that was performed on December 26, 2014. 
#'
#' @format A data.table object with 872 rows and 4 variables:
#' \describe{
#'   \item{name}{A term used as first name.}
#'   \item{gender}{The predicted gender for the term.}
#'   \item{probability}{The probability of the predicted gender.}
#'   \item{count}{How many social profiles with the term as a given name 
#'   is recorded in the genderize.io database.}
#' }
#' @source \url{http://genderize.io/}
#' 
#' 


"givenNamesDB_authorships"

# givenNamesDB_authorships = readRDS("data-raw/givenNamesDB_authorships.rds")
# devtools::use_data(givenNamesDB_authorships)
