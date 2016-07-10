#' Gender data for titles sample
#'
#' A dataset with a gender data from genderize.io for the  
#' \pkg{titles} dataset in the package. This is the output 
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


"givenNamesDB_titles"


# # givenNamesDB_titles = findGivenNames(x = titles$title)
# 
# # saveRDS(givenNamesDB_titles, file = "data-raw/givenNamesDB_titles.rds")
# givenNamesDB_titles = readRDS("data-raw/givenNamesDB_titles.rds")
# dim(givenNamesDB_titles)
# 
# devtools::use_data(givenNamesDB_titles, overwrite=TRUE)
