#' Number of names in the database.
#' 
#' \code{numberOfNames} returns a number of distinct names in the genderize.io database scrapped from genderize.io page.
#' 
#' @return returns a numeric value 
#' 
#' 
#' @examples 
#' \donttest{
#' 
#' numberOfNames()
#' 
#' }
#' 
#' 
#' 
#' 
#' @export

numberOfNames = function () {
    
    # require(RCurl)
    
    extractData <- function (pageHTML, 
                           tagsBefore, 
                           tagsAfter) {
  
        extracted <- 
          stringr::str_extract_all(pageHTML, 
                          paste0(tagsBefore,'.*?',tagsAfter)
                          )
    
        extracted <- unlist(extracted)
        
        extracted <- gsub(x=extracted, tagsBefore, '')
        extracted <- gsub(x=extracted, tagsAfter, '')
        
        extracted
    }

    pageURL <- paste0('https://genderize.io')
    r = httr::GET(pageURL, 
                  httr::config(ssl_verifypeer = FALSE))
    # pageHTML <- RCurl::getURL(pageURL, .encoding='UTF-8')
    tagsBefore = 
        "the database contains <span class=\"label\">"
    tagsAfter = "</span> distinct names"
    pageHTML = 
         (httr::content(r, "text"))
    nNames = extractData(pageHTML, tagsBefore, tagsAfter)
    nNames <- as.numeric(nNames)
    nNames

}
