#' Titles sample
#'
#' A dataset containing a simple random sample of article titles 
#' from WebOfScience records 
#' of articles of "biographical-items" or "items-about-individual" types
#' from all fields of study
#' published from 1945 to 2014.
#' The sample was drawn in December 2014. 
#'
#' @format A data frame with 2641 rows and 2 variables:
#' \describe{
#'   \item{title}{title of an article}
#'   \item{genderCoded}{manually coded gender of an author. There are four codes: "female", "male", "noname, "unknown". "Noname" is the code for a case were human coders were not be able to find a proper first name of an author. "Unknown" if the code for a case were the coders found a full name of an author but were not be able to verify if she or he is a man or a female.}
#' }
#' @source \url{http://webofknowledge.com/}
#' 
#' 


"titles"
 
# titles = readRDS("data-raw/sample_merged.rds")
# library(dplyr)
# titles = titles %>% mutate(firstName = givenName, gender = genderAuto) %>% select(title, genderCoded)
# head(titles)
# devtools::use_data(titles, overwrite=TRUE)
