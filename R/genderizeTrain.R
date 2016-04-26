#' Training genderize function
#' 
#' \code{genderizeTrain} predicts gender and checks different combination
#' of 'probability' and 'count' paramters. 
#' 
#' 
#' @param x A text vector that we want to genderize
#' @param y A text vector of true gender labels for x vector
#' @param givenNamesDB A dataset with gender data (could be an output 
#' of \code{findGivenNames} function)
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset
#' @param parallel If TRUE it computes errors with the use 
#' of \code{parallel} package and available cores. It is designed to work 
#' on Windows machines. Default is FALSE.
#' 
#' @return A data frame with all combination of parameters and computed 
#' sets of prediction indicators for each combination:
#'   \item{errorCoded}{classification error for predicted & unpredicted gender}
#'   \item{errorCodedWithoutNA}{for predicted gender only}
#'   \item{naCoded}{proportion of items with manually codded gender 
#'   and with unpredicted gender }
#'   \item{errorGenderBias}{net gender bias error}
#'   
#' @seealso Implementation of parallel mclapply on Windows machines by Nathan VanHoudnos \url{http://edustatistics.org/nathanvan/setup/mclapply.hack.R}
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c('Alex', 'Darrell', 'Kale', 'Lee', 'Robin', 'Terry', 'John', 'Tom')
#' y = c(rep('male',length(x)))
#' 
#' givenNamesDB = findGivenNames(x)
#' probs = seq(from =  0.5, to = 0.9, by = 0.05)
#' counts = c(1, 10)
#' 
#' genderizeTrain(x = x, y = y, 
#' givenNamesDB = givenNamesDB, 
#' probs = probs, counts = counts, 
#' parallel = TRUE) 
#'
#' }
#' 
#' @export

genderizeTrain = function(x, 
                          y, 
                          givenNamesDB,
                          probs,
                          counts,
                          parallel = FALSE
                          ){
    
    probability <- count <- NULL
    
    givenNamesDB = data.table::as.data.table(givenNamesDB)
    
    grid = expand.grid(prob = probs, count = counts)
    
    if (parallel == FALSE) {
        
        grid$errorCoded = NA
        grid$errorCodedWithoutNA = NA
        grid$naCoded = NA
        grid$errorGenderBias = NA
        # print(grid)
    
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
        
        return(grid)
    
    }

    # parallel version
    
    # writeLines(c("starting parallel computations..."), "training.log")
    
    funcPar = function(g, x, y) {
  
        givenNamesTrimed = 
            givenNamesDB[probability >= (grid[g,]$prob) & 
                         count >= (grid[g,]$count),]
        
        xGenders = genderize(x = x, genderDB = givenNamesTrimed)
        
        errors = classificatonErrors(labels = y, predictions = xGenders$gender)
        
        #  sink("training.log", append = TRUE)
        #         
        #       cat(paste0('[',NROW(grid),']: ', g,'\n'))
        #         
        #  sink()
        
        list(prob = grid[g,]$prob, 
             count = grid[g,]$count, 
             errorCoded = errors$errorCoded,
             errorCodedWithoutNA = errors$errorCodedWithoutNA,
             naCoded = errors$naCoded,
             errorGenderBias = errors$errorGenderBias
        )
    
    }
    
    # Parallel computations nspired by:
    # Nathan VanHoudnos
    ## nathanvan AT northwestern FULL STOP edu
    ## July 14, 2014    
    
    ## Create a cluster
    size.of.list <- length(list(1:NROW(grid))[[1]])
    cl <- parallel::makeCluster( min(size.of.list, parallel::detectCores()) )
    
    parallel::clusterExport(cl, c("x", "y"), envir = .GlobalEnv) 
  
    loaded.package.names = c('genderizeR', 'data.table') 
    
    parallel::parLapply( cl, 1:length(cl), function(xx){
           lapply(loaded.package.names, function(yy) {
               require(yy , character.only = TRUE)})
       })
    
    ## Run the lapply in parallel    
    
    outcome = parallel::parLapply( cl, 1:NROW(grid), function(i) funcPar(i, x,y)) 
    
    parallel::stopCluster(cl)
    
    data.table::rbindlist(outcome)
    
}

    
