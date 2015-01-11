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
# predictions = c("female", "male", "female", NA, NA)

classificatonErrors = function (labels, predictions) {
    
    
    confMatrix =  
    table(labels = labels, 
          predictions = predictions, 
          useNA = 'always')

    

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

