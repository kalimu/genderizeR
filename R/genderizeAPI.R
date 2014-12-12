#' Getting data from genderize.io  API
#' 
#' \code{genderizeAPI} connects with genderize.io API and checks if a term (one or more) is in the given names database and returns its gender probability and count.
#' 
#' 
#' @param A vector of terms to check in genderize.io database.
#'
#' @return A data frame with names' gener probabilities and counts. NULL if a given name is not located in the genderize.io database.
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c("Winston J. Durant, ASHP past president, dies at 84", "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg", "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology", "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM")
#' 
#' terms= textPrepare(x)
#' terms
#' genderizeAPI(terms)
#' 
#' }

 
genderizeAPI = function (x) {

    #require(jsonlite)
  

    # length(x) < 400
    

    termsQuery = x
    
    # checking for 'like' error that crashing API
    termsQuery[stringr::str_detect(x, "^like$")]='likeERROR'
    
    query = 
        paste0('http://api.genderize.io?name[0]=',
               termsQuery[1],
                   paste0(rep(
                       paste0('&name[',
                              1:(length(termsQuery)-1),
                              ']='),1),
                       termsQuery[-1],
                       collapse = "")) 
 
    ## loop checking connection with server
    JSON = ""
    check = 1:10
      
    for (i in check) {
  
        JSON = RCurl::getURL(query, .encoding='UTF-8')
      
        if (JSON != "") {break} else {
            print('Connection error. 
                  Waiting for server response...')
            Sys.sleep(5)
        }
    }

  namesTable <- jsonlite::fromJSON(JSON)
  namesTable
    
}
