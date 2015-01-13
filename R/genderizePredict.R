#' Geder prredicting function
#' 
#' \code{genderizePredict} predicts gender with the best values of
#'  'probability' and 'count' paramters. 
#' 
#' 
#' @param x A text vector that we want to genderize
#' @param y A text vector of true gender labels for x vector
#' @param givenNamesDB A dataset with gender data (could be an output of \code{findGivenNames} function)
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset
#' @param parallel If TRUE it computes errors with the use of \code{parallel} package and available cores. It is design to work on windows machines. Default is FALSE.
#' 
#' @return A data frame with all combination of parameters and computed 
#' sets of prediction indicators for each combination:
#'   \item{errorCoded}{classification error for predictet & unpredicted gender}
#'   \item{errorCodedWithoutNA}{for predicted gender only}
#'   \item{naCoded}{of manually coded gender only }
#'   \item{errorGenderBias}{net gender bias error}
#'   
#' @seealso Implementation of parallel mclapply on Windows machines by Nathan VanHoudnos \link{http://www.stat.cmu.edu/~nmv/setup/mclapply.hack.R}
#' 
#' @examples 
#' \dontrun{
#' 

#'
#' }
 
    
genderizePredict = function(trainedParams, 
                            newdata, 
                            givenNamesDB
                        ){
     
#         library(genderizeR)
#         library(data.table)
        givenNamesDB = as.data.table(givenNamesDB)
        
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


