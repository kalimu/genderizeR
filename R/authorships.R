#' Authorships sample
#'
#' A dataset containing a simple random sample of authorships (unique combination of authors 
#' and titles) from Web Of Science records of articles from biographical-items 
#' and items-about-individual categories.
#'
#' @format A data frame with 2641 rows and 5 variables:
#' \describe{
#'   \item{title}{title of an article}
#'   \item{authors}{all authors for this article}
#'   \item{value}{a single author of the article - with the title forms an authorship}
#'   \item{genderCoded}{manually coded gender of an author. There are four codes: "female", "male", "noname, "unknown". "Noname" is the code for a case were human coders were not be able to find a proper first name of an author. "Unknown" if the code for a case were the coders found a full name of an author but were not be able to verify if she or he is a man or a female.}
#'   \item{WOSaccessionNumber}{original ID of an article}
#' }
#' @source \url{http://webofknowledge.com/}
#' 
#' 

"authorships"

# codedAuthorships = readRDS("data-raw/codedAuthorships.rds")
# head(codedAuthorships)
# library(dplyr) 
# authorships = codedAuthorships %>% select(WOSaccessionNumber, title, authors, value, genderCoded)
# devtools::use_data(authorships, overwrite = TRUE)
