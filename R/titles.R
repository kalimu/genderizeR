#' Titles sample
#'
#' A dataset containing sample of article titles from WebOfScience records of
#' biographical-items types.
#'
#' @format A data frame with 2641 rows and 5 variables:
#' \describe{
#'   \item{title}{title of an article}
#'   \item{authors}{all authors for this article}
#'   \item{value}{a single author/authorships}
#'   \item{genderCoded}{manually coded gender of an author}
#' }
#' @source \url{http://webofknowledge.com/}
#' 
#' 
#' 
#' @export

"titles"
 
# titles = readRDS("data-raw/sample_merged.rds")
# library(dplyr)
# titles = titles %>% mutate(firstName = givenName, gender = genderAuto) %>% select(title, genderCoded)
# head(titles)
# devtools::use_data(titles, overwrite=TRUE)
