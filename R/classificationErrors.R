#' Calculating classification errors and other prediction indicators 
#' 
#' \code{classificationErrors} builds confusion matrix from manually coded
#'  and predicted gender vectors and returns different 
#'  specific classification errors calculated on that matrix.
#' 
#' 
#' @param labels A vector of true labels. Shoud have following 
#' values: c("female", "male", "unknown", "noname"). \code{noname} stands also for 
#' initials only.
#' @param predictions A vector of predicted gender. Shoud have following 
#' values: c("female", "male", NA). \code{NA} when it was not possible to predict any gender.
#' 
#' @return A list of gender prediction efficency indicators:
#' \describe{
#'   \item{confMatrix}{full confusion matrix}
#'   \item{errorTotal}{total classification error}
#'   \item{errorFullFirstNames}{classification error without "noname" category}
#'   \item{errorCoded}{classification error without both "noname" and "unknown" category}
#'   \item{errorCodedWithoutNA}{classification error only on "female" and "male" categories in both predictions and labels}
#'   \item{naTotal}{total proportion of items with unpredicted gender}
#'   \item{naFullFirstNames}{proportion of items with unpredicted gender without "noname" category}
#'   \item{naCoded}{proportion of items with unpredicted gender without both "noname" and "unknown" category}
#'   \item{errorGenderBias}{"male" classified as "female" minus "female" classifed as "male" and divided by the sum of items in "female" and "male" categories in both predictions and labels}
#'   
#'   
#' }
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' set.seed(23)
#' labels = sample(c("female", "male", "unknown", "noname"), 100, replace = TRUE)
#' predictions = sample(c("female", "male", NA), 100, replace = TRUE)
#' classificationErrors(labels, predictions)
#' }
#' 
#' @export


classificationErrors = function(labels, predictions) {
    
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
    
    if (sum(rownames(confMatrix) %in% "female") == 0) {
        
        confMatrix = rbind('female' = 0, confMatrix)
        
    }
    
    if (sum(rownames(confMatrix) %in% "male") == 0) {
        
        confMatrix = rbind(confMatrix, 'male' = 0)
        
    }
    
    tab = confMatrix[rownames(confMatrix) %in% 
                         c("female", "male", "unknown", "noname"),]
    
        errorTotal = (1 - (sum(diag(tab))/sum(tab)))
        
        naTotal = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male", "unknown"),]
    
        errorFullFirstNames = 1 - (sum(diag(tab))/sum(tab))
        
        naFullFirstNames = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male"),]
    
        errorCoded = (1 - (sum(diag(tab))/sum(tab)))
        
        naCoded = (sum(tab[,is.na(colnames(confMatrix))])/sum(tab))
    
    tab = confMatrix[rownames(confMatrix) %in% c("female", "male"),
                     colnames(confMatrix) %in% c("female", "male")]
    
        if (sum(tab) == 0) { 
            errorCodedWithoutNA = 0
            errorGenderBias = 0
            
            } else {
                
                errorCodedWithoutNA = (1 - (sum(diag(tab))/sum(tab)))
                
                errorGenderBias = 
                    (tab[rownames(tab) == 'male',
                         colnames(tab) == 'female'] -
                         tab[rownames(tab) == 'female',
                             colnames(tab) == 'male']) / sum(tab)       
            }
    
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

