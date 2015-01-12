#' Training genderize function
#' 
#' \code{genderizeTrain} predicts gender and checks different combination
#' of 'probability' and 'count' paramters. 
#' 
#' 
#' @param x A text vector that we want to genderize
#' @param y A text vector of true gender labels for x vector
#' @param givenNamesDB A dataset with gender data (could be an output of \code{findGivenNames} function)
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset
#' 
#' @return A data frame with all combination of parameters and computed 
#' sets of prediction indicators for each combination:
#'   \item{errorCoded}{classification error for predictet & unpredicted gender}
#'   \item{errorCodedWithoutNA}{for predicted gender only}
#'   \item{naCoded}{of manually coded gender only }
#'   \item{errorGenderBias}{net gender bias error}
#' 
#' @examples 
#' \dontrun{
#' 

#'
#' }


    
genderizeTrain = function(x, 
                          y, 
                          givenNamesDB,
                          probs,
                          counts
                          ){

    givenNamesDB = data.table::as.data.table(givenNamesDB)
    
    grid = expand.grid(prob = probs, count = counts)
    grid$errorCoded = NA
    grid$errorCodedWithoutNA = NA
    grid$naCoded = NA
    grid$errorGenderBias = NA

    for (g in 1:NROW(grid))     {
        
        givenNamesTrimed = givenNamesDB[probability >= grid[g,]$prob & 
                                        count >= grid[g,]$count,]

        xGenders = genderize(x = x, genderDB = givenNamesTrimed)
        
        errors = classificatonErrors(labels = y, predictions = xGenders$gender)
        

            
        grid[g,]$errorCoded = errors$errorCoded
        grid[g,]$errorCodedWithoutNA = errors$errorCodedWithoutNA
        grid[g,]$naCoded = errors$naCoded
        grid[g,]$errorGenderBias = errors$errorGenderBias
        
        print(grid[g,])
        cat('Total combinations of paramaters: ',NROW(grid),'\n')
    }

  
    grid
    
}
    
