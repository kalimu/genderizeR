#' Gender data for titles sample
#'
#' A dataset with a gender data from genderize.io for the sample 
#' of \pkg{titles} in this package. This is the output 
#' of \code{findGivenNames} 
#' function output is dated on January 12, 2015. 
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


"givenNamesDB_titles"


# # givenNamesDB_titles = findGivenNames(x = titles$title)
# 
# # saveRDS(givenNamesDB_titles, file = "data-raw/givenNamesDB_titles.rds")
# givenNamesDB_titles = readRDS("data-raw/givenNamesDB_titles.rds")
# dim(givenNamesDB_titles)
# 
# devtools::use_data(givenNamesDB_titles, overwrite=TRUE)
