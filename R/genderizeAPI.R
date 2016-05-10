#' Getting data from genderize.io  API
#' 
#' \code{genderizeAPI} connects with genderize.io API and checks if 
#' a term (one or more) is in the given names database and returns 
#' its gender probability and count of the cases recorded in the database.
#' 
#' 
#' @param x A vector of terms to check in genderize.io database.
#' @param apikey A character string with the API key obtained via https://store.genderize.io. A default is NULL, which uses the free API plan.
#' @param ssl.verifypeer Checks the SSL Certificate. Default is TRUE. 
#'
#' @return A list of four elements: \code{response} is a data frame with names, genders, probabilities and counts or \code{NULL} if non of the terms are not located in the genderize.io database; \code{limitLeft} is showing how many queries to the API are still possible within the current \code{limit} which will be renewed in \code{limitReset} seconds.
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' terms = c("loremipsum")
#' genderizeAPI(terms)$response
#' # Null data.table (0 rows and 0 cols)
#' 
#' terms = c("jan", "maria", "norbert", "winston", "loremipsum")
#' genderizeAPI(terms)
#'  
#' # example of the function output 
#' $response
#'       name gender probability count
#'       1:     jan   male        0.60  1692
#'       2:   maria female        0.99  8467
#'       3: norbert   male        1.00    77
#'       4: winston   male        0.98   128

#' 
#' $limitLeft
#' [1] 967
#' 
#' $limit
#' [1] 1000
#' 
#' $limitReset
#' [1] 83234 
#' 
#' }
#' 
#' @export

 
genderizeAPI = function(x, 
                        apikey = NULL, 
                        ssl.verifypeer = TRUE
                        ) {
    
    termsQuery = x
    
    query = as.list(termsQuery)
    
    names(query)  = paste0('name[', 0:(length(termsQuery) - 1), ']')
    
    if (!is.null(apikey)) {
        
        query = c('apikey' = apikey, query)
        
    }
     
    # fix for version 1.0.0 of the httr package        
    #  r = httr::GET("https://api.genderize.io", httr::timeout(100), 
    #  query = query, httr::config(ssl.verifypeer = ssl.verifypeer)) 
    
    r = httr::GET("https://api.genderize.io", query = query, 
                  httr::config(ssl_verifypeer = ssl.verifypeer))
    
    if (httr::status_code(r) == 200) {
        
        l = httr::content(r)
        if (is.atomic(l[[1]])) {l = list(l)}
        l = l[unlist(lapply(l, function(x) {!is.null(x$gender)}))]
        
        limitLeft = as.numeric(httr::headers(r)$'x-rate-limit-remaining')
        limit = as.numeric(httr::headers(r)$'x-rate-limit-limit')
        limitReset = as.numeric(httr::headers(r)$'x-rate-reset')
        
        return(
            list(
                response = data.table::rbindlist(l),
                limitLeft = limitLeft, 
                limit = limit, 
                limitReset = limitReset
                )
            )
        
    } else {
        
        cat('\n', httr::http_status(r)$message)
        cat('\n', httr::content(r)$error)
        
        if (httr::status_code(r) == 429) {
            
            warning('You have used all available requests in this subscription plan.')
            
        }
        
        
        return
    }
    
}

