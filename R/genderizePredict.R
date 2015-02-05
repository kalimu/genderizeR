#' Geder prredicting function
#' 
#' \code{genderizePredict} predicts gender with the best values of
#'  'probability' and 'count' parameters. 
#' 
#' 
#' @param trainedParams An output of a \code{genderizeTrain} function with prediction efficiency indicators for different combinations of probability and count values
#' @param newdata A character vector for gender prediction
#' @param givenNamesDB A dataset with gender data (could be an output of \code{findGivenNames} function)
#' 
#' @return A character vector of values: "male", "female" or "unknown"
#' 

#' @export 
    
genderizePredict = function(trainedParams, 
                            newdata, 
                            givenNamesDB
                        ){
    
        probability <- count <- NULL
     
        givenNamesDB = data.table::as.data.table(givenNamesDB)
        
        grid = trainedParams
        minError = grid[grid$errorCoded==min(grid$errorCoded),]
        minError = minError[1,]  
        
#         print(grid)
        print(minError)
        
        givenNamesTrimed = givenNamesDB[probability>=minError$prob & 
                                        count>=minError$count,]
        
        xGenders = genderize(x = newdata, genderDB = givenNamesTrimed)
            
        xGenders[is.na(xGenders$gender),]$gender = "unknown"
    
        xGenders$gender 
        
        
    }


