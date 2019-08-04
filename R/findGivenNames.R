#' Getting gender prediction data for a given text vector.
#' 
#' \code{findGivenNames} extracts from text unique terms and predicts  
#' gender for them.
#' 
#' 
#' @param x A text vector or a character vector of unique terms 
#' pre-processed earlier manually or by the \code{textPrepare} function.
#' @param textPrepare If TRUE (default) the \code{textPrepare} function 
#' will be used on the \code{x} vector. Set it to FALSE if you already 
#' have prepared a character vector of cleaned up and deduplicated terms 
#' that you want to send to the API for gender checking.
#' @param country A character string with a country code for localized search
#' of names. Country codes follow the ISO_3166-1 alpha-2 standard
#' \url{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}.
#' @param language A character string with a language code for localized search
#' of names. Language codes follow the ISO_639-1 standard: 
#' \url{https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes}
#' @param apikey A character string with the API key obtained via 
#' \url{https://store.genderize.io}. A default is NULL, which uses the free API 
#'  plan. If you reached the limit of the API you can start from the last 
#'  checked term next time.
#' @param queryLength How much terms can be checked in a one single query.
#' @param progress If TRUE (default) progress bar is displayed in the console.
#' @param ssl.verifypeer Checks the SSL Certificate. Default is TRUE. 
#' You may set it to FALSE if you encounter some errors that break 
#' the connection with the API (though it is not recommended).
#'
#'
#' 
#' @return A data table with given names found in database, 
#' gender predictions,
#' probabilities of gender predictions, 
#' and counts how many people with a given name is recorded in the database. 
#' 
#' 
#' 
#' @examples 
#' \donttest{
#' 
#' x = "Tom did play hookey, and he had a very good time. He got back home 
#'      barely in season to help Jim, the small colored boy, saw next-day's wood 
#'      and split the kindlings before supper-at least he was there in time 
#'      to tell his adventures to Jim while Jim did three-fourths of the work. 
#'      Tom's younger brother (or rather half-brother) Sid was already through 
#'      with his part of the work (picking up chips), for he was a quiet boy, 
#'      and had no adventurous, trouble-some ways. While Tom was eating his
#'      supper, and stealing sugar as opportunity offered, Aunt Polly asked 
#'      him questions that were full of guile, and very deep-for she wanted 
#'      to trap him into damaging revealments. Like many other simple-hearted
#'      souls, it was her pet vanity to believe she was endowed with a talent 
#'      for dark and mysterious diplomacy, and she loved to contemplate her 
#'      most transparent devices as marvels of low cunning. 
#'      (from 'Tom Sawyer' by Mark Twain)"
#' 
#' xProcessed = textPrepare(x)
#' 
#' foundNames = findGivenNames(xProcessed, textPrepare = FALSE)
#' foundNames[count > 100]
#' 
#' # (the results can differ due to new, updated data pulled from the API)
#' #    name gender probability count
#' # 1:   jim   male        1.00  2291
#' # 2:  mark   male        1.00  6178
#' # 3: polly female        0.99   191
#' # 4:   tom   male        1.00  3736
#' 
#' 
#' # localization
#' findGivenNames("andrea", country = "us")
#' #      name gender probability count
#' # 1: andrea female        0.97  2308
#' 
#' findGivenNames("andrea", country = "it")
#' #      name gender probability count
#' # 1: andrea  male         0.99  1070
#' }
#' 
#' @export
 

findGivenNames = function(x, 
                          textPrepare = TRUE,
                          country = NULL,
                          language = NULL,
                          apikey = NULL,
                          queryLength = 10, 
                          progress = TRUE,
                          ssl.verifypeer = TRUE) {
    
    # an option to turn the textPrepare function off
    if (textPrepare) {
        terms = textPrepare(x, textPrepMessages = progress)       
    } else {
        terms = x
    }
    
    startPackage = 1
    nPackages = ceiling(length(terms) / queryLength)
    
    if (progress) pb <- txtProgressBar(0, nPackages, style = 3, width = 50)
    
    cat('\r')
    # cat('\n')
 
    dfNames = data.frame(name = character(), 
                         gender = character(), 
                         probability = character(), 
                         count = numeric(), 
                         country_id = character(),
                         stringsAsFactors = FALSE) 
    
    dfNames = data.table::as.data.table(dfNames)
          
    # eliminating  multi handle error
    # http://recology.info/2014/12/multi-handle/
    httr::handle_find("https://api.genderize.io")    
    httr::handle_reset("https://api.genderize.io")
    
    # function reporting used limit of the API    
    verbose = function(responseAPI) {
        if (exists( 'responseAPI')) {
            cat('\nYou have used ', (responseAPI$limit - responseAPI$limitLeft), 
                ' out of ', formatC(signif(responseAPI$limit,digits = 3),                                     digits = 3,format = "fg", flag = ""), 
                ' (', formatC(signif(
                    (responseAPI$limit - responseAPI$limitLeft) / 
                        responseAPI$limit*100,digits = 3), 
                    digits = 3,format = "fg", flag = ""),
                '%) term queries.\n', sep = "")
            
            cat('You have ', round(responseAPI$limitReset/60/60,1), 
                ' hours until a new subscription period starts.\n', sep = "")          
        }
    }     
             
       
    for (p in startPackage:nPackages) {

        packageFromIndex = 
            queryLength*p - queryLength + 1
        
        packageEndIndex = ifelse(length(terms) < queryLength*p,
                                 length(terms), 
                                 queryLength*p
                                 )
        
        termsQuery = terms[packageFromIndex:packageEndIndex]
        
        responseAPI = genderizeAPI(termsQuery, 
                                   country = country,
                                   language = language,
                                   apikey = apikey,
                                   ssl.verifypeer = ssl.verifypeer
                                   )
        
        if (is.primitive(responseAPI) ) {
        # set below only for testing purposes            
        # if (is.primitive(responseAPI) | (p==8)) {
            
            #warning('An error have occured.')
            warning('The API queries stopped. \n')  
            dfResponse = NULL
            break
            
        } else {
            
           dfResponse = responseAPI$response   
           
        }
        
        if (NCOL(dfResponse) == 4) {
      
            dfResponse$country_id <- "all"
            dfNames = data.table::rbindlist(list(dfNames, dfResponse))

        }
        
        if (NCOL(dfResponse) == 5) {
      
          
            dfNames = data.table::rbindlist(list(dfNames, dfResponse))

        }
      
        cat('\r')
        
        if (progress) {
            
            cat(paste0('Terms checked: ', p * queryLength,
                   '/', length(terms),
                   '. First names found: ', nrow(dfNames), '. \n'
                   )
                )               
            
        }
        
        if (progress) setTxtProgressBar(pb, p)
        
        if (progress & (p %% 10 == 0 | p == nPackages)) {
            
            if (p == nPackages) { cat('\n\nSummary:')}
            verbose(responseAPI)            
            
        }   
        
        if (progress) {
          cat('\n')
          cat('\n')  
        }
    }
    
    if (is.null(dfResponse)) {
        
      startNext = ifelse(
          (NROW(dfNames) == 0), 1, 
          which(terms == tail(dfNames, 1)$name)
          )
      
      cat('The API queries stopped at', startNext, 'term. \n')  
      cat('If you have reached the end of your API limit, you can start the function again from that term and continue finding given names next time with efficient use of the API.\n Remember to add the results to already found names and not to overwrite them. \n\n')  
        
    } 
    
    dfNames

}
