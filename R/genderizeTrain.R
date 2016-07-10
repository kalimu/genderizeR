#' Training genderize function
#' 
#' THe \code{genderizeTrain} function predicts gender and checks 
#' different combinations of \code{probability} and \code{count} parameters. 
#' 
#' 
#' @param x A text vector that we want to genderize.
#' @param y A text vector of true gender labels for the x vector.
#' @param givenNamesDB A dataset with gender data (could be an output 
#' of \code{findGivenNames} function).
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset.
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset.
#' @param parallel If TRUE it computes errors with the use 
#' of \code{parallel} package and available cores. Default is FALSE.
#' @param cores A integer value for number of cores designated to parallel
#' processing or NULL (default). If \code{parallel} argument is TRUE and
#' \code{cores} is NULL, than the available number of cores will 
#' be detected automatically.
#' 
#' @return A data frame with prediction indicators for each combination 
#' of parameters:
#'   \item{errorCoded}{The classification error for predicted and 
#'   unpredicted gender.}
#'   \item{errorCodedWithoutNA}{The classification error for items with 
#'   predicted gender only.}
#'   \item{naCoded}{The proportion of items with manually coded gender 
#'   and with unpredicted gender.}
#'   \item{errorGenderBias}{The net gender bias error.}
#'   
#' @seealso Implementation of parallel mclapply on Windows machines by Nathan VanHoudnos \url{http://edustatistics.org/nathanvan/setup/mclapply.hack.R}.
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c('Alex', 'Darrell', 'Kale', 'Lee', 'Robin', 'Terry', 'John', 'Tom')
#' y = c(rep('male', length(x)))
#' 
#' givenNamesDB = findGivenNames(x)
#' probs = seq(from =  0.5, to = 0.9, by = 0.1)
#' counts = c(1, 10)
#' 
#' genderizeTrain(x = x, y = y, 
#'                givenNamesDB = givenNamesDB, 
#'                probs = probs, counts = counts, 
#'                parallel = TRUE) 
#' 
#' #     prob count errorCoded errorCodedWithoutNA naCoded errorGenderBias
#' #  1:  0.5     1      0.125               0.125   0.000           0.125
#' #  2:  0.6     1      0.125               0.000   0.125           0.000
#' #  3:  0.7     1      0.125               0.000   0.125           0.000
#' #  4:  0.8     1      0.375               0.000   0.375           0.000
#' #  5:  0.9     1      0.500               0.000   0.500           0.000
#' #  6:  0.5    10      0.125               0.125   0.000           0.125
#' #  7:  0.6    10      0.125               0.000   0.125           0.000
#' #  8:  0.7    10      0.125               0.000   0.125           0.000
#' #  9:  0.8    10      0.375               0.000   0.375           0.000
#' # 10:  0.9    10      0.500               0.000   0.500           0.000
#'
#' }
#' 
#' @export

genderizeTrain = function(x, 
                          y, 
                          givenNamesDB,
                          probs,
                          counts,
                          parallel = FALSE,
                          cores = NULL
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
            
            errors = classificationErrors(labels = y, 
                                         predictions = xGenders$gender)
            
            grid[g,]$errorCoded = errors$errorCoded
            grid[g,]$errorCodedWithoutNA = errors$errorCodedWithoutNA
            grid[g,]$naCoded = errors$naCoded
            grid[g,]$errorGenderBias = errors$errorGenderBias
            
            print(grid[g,])
            cat('Total combinations of parameters: ',NROW(grid),'\n')
        }
        
        return(grid)
    
    }

    # parallel version
    # with update for Linux
    
    # writeLines(c("starting parallel computations..."), "training.log")
    
    funcPar = function(g, x, y) {
  
        givenNamesTrimed = 
            givenNamesDB[probability >= (grid[g,]$prob) & 
                         count >= (grid[g,]$count),]
        
        xGenders = genderize(x = x, genderDB = givenNamesTrimed)
        
        errors = classificationErrors(labels = y, predictions = xGenders$gender)
        
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
    
    # Parallel computations inspired by:
    # Nathan VanHoudnos
    ## nathanvan AT northwestern FULL STOP edu
    ## July 14, 2014    
    
    if (is.null(cores)) {cores = parallel::detectCores()} 
    
    
    # Check what system is being used
    
    if (Sys.info()[['sysname']] == 'Windows') {
        
        message(paste(
          "\n", 
          "   *** Microsoft Windows detected  ***\n",
          "   *** using parLapply function... ***\n",
          "   ***", cores, 
          "cores detected.           ***",
          "   \n\n"))
        
        ## Create a cluster
        size.of.list <- length(list(1:NROW(grid))[[1]])
        cl <- parallel::makeCluster( min(size.of.list, cores) )
    
        parallel::clusterExport(cl, c("x", "y"), envir = .GlobalEnv) 
  
        loaded.package.names = c('genderizeR', 'data.table') 
    
        parallel::parLapply( cl, 1:length(cl), function(xx){
           lapply(loaded.package.names, function(yy) {
               require(yy , character.only = TRUE)})
           })
    
        ## Run the lapply in parallel    
        outcome = parallel::parLapply(cl, 
                                      1:NROW(grid), 
                                      function(i) funcPar(i, x,y)
                                      ) 
    
        parallel::stopCluster(cl)       
        
    } else if (Sys.info()[['sysname']] == 'Linux') {
        
        message(paste(
          "\n", 
          "   *** Linux detected             ***\n",
          "   *** using mclapply function... ***\n",
          "   ***", cores, 
          "cores detected.          ***",
          "   \n\n"))
        
        outcome = parallel::mclapply(1:NROW(grid), 
                           function(i) funcPar(i, x,y), 
                           mc.cores = cores
                           )

    } else {
        
        message(paste(
          "\n", 
          "   *** Other system detected than Windows or Linux ***\n",
          "   *** attempt to use mclapply function...         ***\n",
          "   ***", cores, 
          "cores detected.          ",
          "   \n\n"))
        
        outcome = parallel::mclapply(1:NROW(grid), 
                           function(i) funcPar(i, x,y), 
                           mc.cores = cores
                           )
        
    }
    
    data.table::rbindlist(outcome)
    
}

    
