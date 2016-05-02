#' Getting data from genderize.io  API
#' 
#' \code{genderizeAPI} connects with genderize.io API and checks if 
#' a term (one or more) is in the given names database and returns 
#' its gender probability and count of the cases recorded in the database.
#' 
#' 
#' @param x A vector of terms to check in genderize.io database.
#' @param apikey A character string with the API key obtained via https://store.genderize.io. A default is NULL, which uses the free API plan.
#' @param ssl.verifypeer Checks the SSL Cerftificate. Default is TRUE. 
#'
#' @return A data frame with names' gener probabilities and counts. NULL if a given name is not located in the genderize.io database.
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c("Winston J. Durant, ASHP past president, dies at 84", 
#' "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg",
#' "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology", 
#' "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM", 
#' "Maria Sklodowska-Curie")
#' 
#' terms= textPrepare(x)
#' terms
#' genderizeAPI(terms)
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
    #  r = httr::GET("https://api.genderize.io", httr::timeout(100), query = query, 
    #               httr::config(ssl.verifypeer = ssl.verifypeer))       
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

