#' Predicting gender for character strings.
#' 
#' For a each character string \code{genderize} use output of the  \code{findGivenNames} function for the strings and returns a gender prediction for the whole character string based on first names located inside strings.
#' 
#' 
#' @param x A vector of text strings.
#' @param genderDB A data.table output of  \code{findGivenNames} function for the same vector x.
#' @param blacklist Some terms could be exlude from gender checking
#'
#' @return A data table with text strings, a term that is used to predict gender found in genderDB, a predicted gender and number of genderIndicator (1 if only one term is found in genderDB). 
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
#' givenNames = findGivenNames(x)
#' givenNames = givenNames[count>40]
#' genderize(x, genderDB=givenNames, blacklist=NULL)
#'
#' }




genderize = function (x, genderDB=givenNames, blacklist=NULL) {
    
    pb <- txtProgressBar(0, length(x), style=3)  

    db = data.table::data.table(
                            text=x, 
                            givenName=as.character(NA), 
                            gender=as.character(NA), 
                            genderIndicators=as.numeric(NA)
                            )    

    genderDB = data.table::data.table(genderDB, key='name')

    for (i in 1:length(x)) {

        terms = textPrepare(x[i], textPrepMessages = FALSE)  
        

        termsGender = character(length(terms))
        termsCount = numeric(length(terms))
        
        for (t in 1:length(terms)) {

            if (!is.null(blacklist)) {

                terms[t] = ifelse(!terms[t] %in% blacklist,
                                  terms[t],
                                  "_blacklisted")
            }

            query = genderDB[terms[t],]
            gender = as.character(query$gender)
            count = as.numeric(query$count)
  
            termsGender[t] = ifelse(length(gender)!=0,gender,NA)
            termsCount[t]= ifelse(length(count)!=0,count,NA)
   
        }
        
        itemGender = ifelse(sum(!is.na(termsCount))==0,
                        NA,
                        termsGender[which(termsCount==max(termsCount, 
                                                          na.rm=TRUE))]
                        )
    
        db[i, genderIndicators := sum(!is.na(termsGender))] 
        db[i, givenName := ifelse(sum(!is.na(termsCount))==0,
                              as.character(NA),
                              terms[which(termsCount==max(termsCount, 
                                                          na.rm=TRUE))]
                              )]
        
        db[i, gender := as.character(itemGender)] 
      
        if (i %% 100 == 0 | i == length(x) | i == 1) {
                
               
               cat('\n') 
         
                cat(paste0('Items done: ', i,
                       '. ToDo: ', length(x)-i, '. \n'
                       )
                )
           
               # setTxtProgressBar(pb, i)    
    
        }
    
               setTxtProgressBar(pb, i)             
          
      }
            

      cat('\n')
      cat('\n')
    
    return(db)
}
