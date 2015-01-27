#' Calculating classification errors on confusion matrix
#' 
#' \code{classificatonErrors} builds confusion matrix from manually coded
#'  and predicted gender vectors and returns different 
#'  specific classification errors.
#' 
#' 
#' @param labels A vector of true labels. Shoud have following 
#' values: c("female", "male", "unknown", "noname"). "noname" stands also for 
#' initials only.
#' @param predictions A vector of true labels. Shoud have following 
#' values: c("female", "male", NA).
#' 
#' @return A list 
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' 
#' 
#' }

# labels = c("female", "male", "male", "unknown", "noname")
# predictions = c(rep("male", 5))
# predictions = c("female", "male", "female", "female", NA)
#  titlesCoded = titles[titles$genderCoded %in% c("female", "male"),]
# cbind('N' = table(titlesCoded$genderCoded),
#       '%' = round(prop.table(table(titlesCoded$genderCoded))*100,0))
# 
#                      
# classificatonErrors(labels = titlesCoded$genderCoded, predictions = rep("male", NROW(titlesCoded$genderCoded)))   
#     

classificatonErrors = function (labels, predictions) {
    
    

    confMatrix =  
    table(labels = labels, 
          predictions = predictions, 
          useNA = 'always')

    if (sum(colnames(confMatrix) %in% "female") == 0) {
        
      confMatrix = cbind('female' = 0, confMatrix)
    }
    
    if (sum(colnames(confMatrix) %in% "male") == 0) {
        
      confMatrix = cbind(confMatrix, 'male' = 0)
    }
   
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male", "unknown", "noname"),]
    errorTotal = (1-(sum(diag(tab))/sum(tab)))
    naTotal = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male", "unknown"),]
    errorFullFirstNames = 1-(sum(diag(tab))/sum(tab))
    naFullFirstNames = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male"),]
    errorCoded = (1-(sum(diag(tab))/sum(tab)))
    naCoded = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male"),
                     colnames(confMatrix) %in% c("female", "male")]
    errorCodedWithoutNA = (1-(sum(diag(tab))/sum(tab)))
    errorGenderBias = 
        (tab[rownames(tab)=='male',colnames(tab)=='female']-
             tab[rownames(tab)=='female',colnames(tab)=='male'])/sum(tab)

    list(confMatrix = confMatrix, 
         errorTotal = errorTotal,
         errorFullFirstNames = errorFullFirstNames,
         errorCoded = errorCoded,
         errorCodedWithoutNA = errorCodedWithoutNA,
         naTotal = naTotal,
         naFullFirstNames = naFullFirstNames,
         naCoded = naCoded,
         errorGenderBias =  errorGenderBias
         )
    
}

