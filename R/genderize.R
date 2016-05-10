#' Predicting gender for character strings.
#' 
#' For each character string in \code{x} vector \code{genderize} 
#' use output of the 
#' \code{findGivenNames} function and returns 
#' a gender prediction for the whole character string based 
#' on possible first name terms located inside those strings.
#' 
#' 
#' @param x A vector of text strings.
#' @param genderDB A data.table output of  \code{findGivenNames} function 
#' for the vector x.
#' @param blacklist Some terms could be excluded from gender checking
#' @param progress If TRUE (default) progress bar is displayed in the console
#'
#' @return A data table with text string, a term found in \code{genderDB},
#'  that is finally used as a given name to predict gender, 
#'  a predicted gender, number of potential gender indicators 
#' ("1" if only one term from the text string is found in \code{genderDB}). 
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
#' #                                                                             text
#' # 1:                            Winston J. Durant, ASHP past president, dies at 84
#' # 2:   Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg
#' # 3: The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology
#' # 4:                JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM
#' # 5:                                                        Maria Sklodowska-Curie
#' 
#' #    givenName gender genderIndicators
#' # 1:   winston   male                1
#' # 2:       med   male                2
#' # 3:        NA     NA                0
#' # 4:       jan   male                1
#' # 5:     maria female                1
#'
#' }
#' 
#' @export

genderize = function(x, 
                     genderDB,  
                     blacklist = NULL, 
                     progress = TRUE
                     ) {
    
    genderIndicators <- givenName <- NULL
    
    if (progress) pb <- txtProgressBar(0, length(x), style = 3)  

    db = data.table::data.table(text = x,
                                givenName = as.character(NA), 
                                gender = as.character(NA), 
                                genderIndicators = as.numeric(NA)
                                )    

    genderDB = data.table::data.table(genderDB, key = 'name')

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
  
            termsGender[t] = ifelse(length(gender) != 0,gender,NA)
            termsCount[t] = ifelse(length(count) != 0,count,NA)
   
        }
        
        itemGender = ifelse(sum(!is.na(termsCount)) == 0, NA,
                        termsGender[which(termsCount == max(termsCount, 
                                                          na.rm = TRUE))]
                        )
    
        db[i, genderIndicators := sum(!is.na(termsGender))] 
        db[i, givenName := ifelse(sum(!is.na(termsCount)) == 0,
                              as.character(NA),
                              terms[which(termsCount == max(termsCount, 
                                                          na.rm = TRUE))]
                              )]
        
        db[i, gender := as.character(itemGender)] 
        #print(db[i,])
        
        if (progress) setTxtProgressBar(pb, i)             
          
    }
            
 
    cat('\n')
    cat('\n')
      
    # return(NROW(db))
    #return(data.table::data.table(db))
    return(db[])
      
}
