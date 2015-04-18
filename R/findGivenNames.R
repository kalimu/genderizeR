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
 

findGivenNames = function (x, apikey = NULL,
                           queryLength = 10, 
                           progress = TRUE) {
 

  
    terms = textPrepare(x, textPrepMessages = progress)   
    
    startPackage = 1
    nPackages = ceiling(length(terms)/queryLength)
    
    if (progress) pb   <- txtProgressBar(0, nPackages, style=3, width=46)
    
    cat('\r')
    # cat('\n')
 
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
        
        
         
        responseAPI = genderizeAPI(termsQuery, apikey = apikey)
        
        if (is.primitive(responseAPI)) {
            
            stop('Error occured.')
            
        } else {
            
           dfResponse = responseAPI$response   
            
        }
        
        
          
            
        
        
        if (NCOL(dfResponse) > 2) {
      
            dfNames = data.table::rbindlist(list(dfNames, dfResponse))
             #dfNames = dfNames[!is.na(dfNames$gender),]
      
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


    
         
#         if (progress) cat(paste0('Packages done: ', p,
#                '. ToDo: ', nPackages-p,
#                '. First names: ',nrow(dfNames), '. \n'
#                )
#         )
 
        if (progress) {
            
            cat(paste0('Terms checked: ', p*queryLength,
                   '/', length(terms),
                   '. First names found: ',nrow(dfNames), '. \n'
                   ))               
            
            }
        
     
        

        if (progress) setTxtProgressBar(pb, p)
 
                
     if (progress & (p%%10==0 | p == nPackages) # &  NROW(dfResponse) != 0
         ){
         

        
        cat('\nYou have used ', (responseAPI$limit-responseAPI$limitLeft), ' out of ', formatC(signif(responseAPI$limit,digits=3), digits=3,format="fg", flag=""), ' (', formatC(signif((responseAPI$limit-responseAPI$limitLeft)/responseAPI$limit*100,digits=3), digits=3,format="fg", flag=""),'%) term queries.\n', sep = "")
        cat('You have ', round(responseAPI$limitReset/60/60,1), ' hours until a new subscription period starts.\n', sep="")             
         
         
     }   
       
        
        
    }
    
    cat('\n')
    cat('\n')  
    
    dfNames
    
}
