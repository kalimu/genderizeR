#' Getting gender prediction data for a given text vector.
#' 
#' \code{findGivenNames} extract from text unique terms and gets the gender predicion for all these terms.
#' 
#' 
#' @param x A text vector.
#' @param queryLength How much terms can be check in a one single query
#' @param progress If TRUE (default) progress bar is displayed in the console
#' 
#' @return A data table with names gener probabilities and counts for terms in given text vector. 
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' grid = (expand.grid(a=letters,b=letters))
#' findGivenNames(paste0(grid$a,grid$b))
#' 
#' }
#' 
#' @export
 

findGivenNames = function (x, queryLength = 400, progress = TRUE) {
 

  
    terms = textPrepare(x, textPrepMessages = progress)   
    
    startPackage = 1
    nPackages = ceiling(length(terms)/queryLength)
    
    if (progress) pb   <- txtProgressBar(0, nPackages, style=3, width=40)    
 
    dfNames = data.frame(name=character(), 
                         gender=character(), 
                         probability=character(), 
                         count=numeric(), 
                         stringsAsFactors = FALSE)   
    
    for (p in startPackage:nPackages) {

        packageFromIndex = 
            queryLength*p-queryLength+1
      

     
        packageEndIndex = ifelse(length(terms)<queryLength*p,
                               length(terms), 
                               queryLength*p)
          

        termsQuery = terms[packageFromIndex:packageEndIndex]
        
        
        dfResponse = genderizeAPI(termsQuery)
        
        if (ncol(dfResponse)!=2) {
      
            dfNames = data.table::rbindlist(list(dfNames, dfResponse))
            dfNames = dfNames[!is.na(dfNames$gender),]
      
        }
      
        # old loop
        #     for (i in 1:length(response)) {
        #       firstName = unlist(response[[i]])
        #       if (length(firstName)==4)  {
        #         df = rbind(df, t(data.frame(firstName)))
        #     
        #       }
        #     }
  

       cat('\r')
 
        if (progress) cat(paste0('Packages done: ', p,
               '. ToDo: ', nPackages-p,
               '. First names: ',nrow(dfNames), '. \n'
               )
        )
 

        if (progress) setTxtProgressBar(pb, p)
 

       
        
        
    }
    
    cat('\n')
    cat('\n')  
    
    dfNames
    
}
