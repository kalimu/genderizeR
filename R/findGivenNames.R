#' Getting gender prediction data for a given text vector.
#' 
#' \code{findGivenNames} extract from text unique terms and gets the gender predicion for all these terms.
#' 
#' 
#' @param x A text vector.
#' @param queryLength How much terms can be check in a one single query
#' @param distributedCorpus If TRUE use as.DistributedCorpus from the tm.plugin.dc package.
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

 

findGivenNames = function (x, queryLength = 400, distributedCorpus = FALSE) {
 
  
    terms = textPrepare(x, textPrepMessages = TRUE, 
                        distributedCorpus = distributedCorpus)   
    
    startPackage = 1
    nPackages = ceiling(length(terms)/queryLength)
    
 
    dfNames = data.frame(name=character(), 
                         gender=character(), 
                         probability=character(), 
                         count=numeric(), 
                         stringsAsFactors = FALSE)   
    
    for (p in startPackage:nPackages) {
   
        
        # p=1
        packageFromIndex = 
            queryLength*p-queryLength+1
      
        # startPackage
     
        packageEndIndex = ifelse(length(terms)<queryLength*p,
                               length(terms), 
                               queryLength*p)
          
        # endPackage
      
        # termsQuery=c('peter',terms[1:3])
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
  
        cat(paste0('Packages done: ', p,
                   '. Packages left: ', nPackages-p,
                   '. Names: ',nrow(dfNames),'.\n'))
  
        
        pb   <- txtProgressBar(0, nPackages, style=3)
        setTxtProgressBar(pb, p)
        cat('\r')
    }
  
    dfNames
    
}
