#' Calculating classification errors and other prediction indicators 
#' 
#' \code{classificationErrors} builds confusion matrix from manually coded
#'  and predicted gender vectors and returns 
#'  classification errors calculated on that matrix.
#' 
#' 
#' @param labels A vector of true labels. Should have following 
#' values: c("female", "male", "unknown", "noname"). \code{noname} stands also for 
#' initials only.
#' @param predictions A vector of predicted gender. Should have following 
#' values: c("female", "male", NA). \code{NA} when it was not possible 
#' to predict a gender.
#' 
#' @return A list of gender prediction efficiency indicators:
#' \describe{
#'   \item{confMatrix}{Full confusion matrix.}
#'   \item{errorTotal}{Total classification error calculated on the matrix.}
#'   \item{errorFullFirstNames}{Classification error calculated without "noname" category.}
#'   \item{errorCoded}{Classification error calculated without both "noname" and "unknown" category.}
#'   \item{errorCodedWithoutNA}{Classification error calculated only on "female" and "male" categories from both predictions and labels.}
#'   \item{naTotal}{Total proportion of items with unpredicted gender.}
#'   \item{naFullFirstNames}{Proportion of items with unpredicted gender calculated without "noname" category.}
#'   \item{naCoded}{Proportion of items with unpredicted gender calculated without both "noname" and "unknown" category.}
#'   \item{errorGenderBias}{Calculated as follows: "male" classified as "female" minus "female" classified as "male" and divided by the sum of items in "female" and "male" categories from both predictions and labels.}
#'   
#'   
#' }
#' 
#' 
#' 
#' @examples 
#' suppressWarnings(RNGversion("3.5.0"))
#' set.seed(23)
#' labels = sample(c("female", "male", "unknown", "noname"), 100, replace = TRUE)
#' predictions = sample(c("female", "male", NA), 100, replace = TRUE)
#' classificationErrors(labels, predictions)
#' 
#' # $confMatrix
#' #          predictions
#' # labels    female male <NA>
#' #   female       6    6    8
#' #   male         6   10   10
#' #   noname      12    6   17
#' #   unknown      5    7    7
#' #   <NA>         0    0    0
#' # 
#' # $errorTotal
#' # [1] 0.67
#' # 
#' # $errorFullFirstNames
#' # [1] 0.6461538
#' # 
#' # $errorCoded
#' # [1] 0.6521739
#' # 
#' # $errorCodedWithoutNA
#' # [1] 0.4285714
#' # 
#' # $naTotal
#' # [1] 0.42
#' # 
#' # $naFullFirstNames
#' # [1] 0.3846154
#' # 
#' # $naCoded
#' # [1] 0.3913043
#' # 
#' # $errorGenderBias
#' # [1] 0 

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

