#' Calculating classification errors and other prediction indicators 
#' 
#' \code{classificatonErrors} function was misspelled (sorry for that!). 
#' Now the function has the proper name \code{classificationErrors} (with "i").
#' Old function name still works, but is deprecated now and will be removed
#' in future version of the package. 
#' 
#' @param labels A vector of true labels. Should have following 
#' values: c("female", "male", "unknown", "noname"). \code{noname} stands also for 
#' initials only.
#' @param predictions A vector of predicted gender. Should have following 
#' values: c("female", "male", NA). \code{NA} when it was not possible to predict any gender.
#' 
 
#' 
#' 
#' 
#' @export

classificatonErrors = function(labels, predictions) {
    
    .Deprecated("classificationErrors")
    classificationErrors(labels, predictions)    
    
}

