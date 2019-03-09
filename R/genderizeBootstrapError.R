#' Gender prediction errors on bootstrap samples
#' 
#' \code{genderizeBootstrapError} calculates the Apparent Error Rate, 
#' the Leave-One-Out bootstrap error rate, 
#' and the .632+ error rate from Efron and Tibishirani (1997). 
#' The code is modified version of several functions from \code{sortinghat} 
#' package by John A. Ramey.
#' 
#' 
#' @param x A text vector that we want to genderize
#' @param y A text vector of true gender labels ('female' or 'male') 
#' for x vector 
#' @param givenNamesDB A dataset with gender data (could be an output of \code{findGivenNames} function)
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset
#' @param num_bootstraps Number of bootstrap samples. Default is 50.
#' @param parallel It is passed to \code{genderizeTrain} function. If TRUE it computes errors with the use of \code{parallel} package and available cores. Default is FALSE.
#' 
#' @return A list of bootstrap errors:
#'   \item{apparent}{Apparent Error Rate}
#'   \item{loo_boot}{LOO-Boot Error Rate}
#'   \item{errorRate632plus}{.632+ Error Rate}
#'   
#'   
#' @seealso In the \code{sortinghat} package. 
#' 
#' @examples 
#' \dontrun{
#' 
#' x <- c('Alex', 'Darrell', 'Kale', 'Lee', 'Robin', 'Terry', rep('Robin', 20))
#' 
#' y <- c(rep('female', 6), rep('male', 20))
#' 
#' givenNamesDB = findGivenNames(x)
#' pred = genderize(x, givenNamesDB)
#' classificationErrors(labels = y, predictions = pred$gender)
#' 
#' probs = seq(from =  0.5, to = 0.9, by = 0.05)
#' counts = c(1)
#' 
#' set.seed(23)
#' genderizeBootstrapError(x = x, y = y, 
#'                          givenNamesDB = givenNamesDB, 
#'                          probs = probs, counts = counts, 
#'                          num_bootstraps = 20, 
#'                          parallel = TRUE)
#' 
#' 
#' # $apparent
#' # [1] 0.9615385
#' 
#' # $loo_boot
#' # [1] 0.965812
#' 
#' # $errorRate632plus
#' # [1] 0.964225
#' 
#'
#' }
#' 
#' @export
#' 

genderizeBootstrapError = function(x, 
                                   y, 
                                   givenNamesDB,
                                   probs, counts,
                                   num_bootstraps = 50,
                                   parallel = FALSE
                                   ) {
    
    givenNamesDB = data.table::as.data.table(givenNamesDB)
    
    seq_y <- seq_along(y)
    rep_NA <- rep.int(NA, times = length(y))
    
    loo_boot_error_rates <- 
        lapply(seq_len(num_bootstraps), function(b) {
            
            training <- sample(seq_y, replace = TRUE)
            test <- which(!(seq_y %in% training))
            
            trainedParams = genderizeTrain(x = x[training], 
                                           y = y[training],
                                           givenNamesDB = givenNamesDB,
                                           probs = probs, 
                                           counts = counts, 
                                           parallel = parallel
                                           )

            classifications = genderizePredict(trainedParams,
                                               newdata = x[test],
                                               givenNamesDB = givenNamesDB)
            
            # optional code for monitoring parallel processes
            #             
            # sink("bootstraping.log", append = TRUE)
            # cat(paste0('[',num_bootstraps,']: ', b,'\n'))
            # sink() # empty the sink stack
            
            print(b)
            
            replace(rep_NA, test, classifications != y[test])
            
        })
    
    loo_boot_error_rates <- do.call(rbind, loo_boot_error_rates)
    loo_boot_error_rates <- colMeans(loo_boot_error_rates, na.rm = TRUE)
    
    if (any(is.nan(loo_boot_error_rates))) {
        
        warning("Some observations were not included as test observations. Returning 'NaN'")
        
    }
    
    loo_boot = mean(loo_boot_error_rates)
    
    trainedParams = genderizeTrain(x = x, 
                                   y = y, 
                                   givenNamesDB = givenNamesDB, 
                                   probs = probs, 
                                   counts = counts,  
                                   parallel = parallel
                                   )
    
    classify_out = genderizePredict(trainedParams = trainedParams, 
                                    newdata = x, 
                                    givenNamesDB = givenNamesDB
                                    )  
    
    apparent = mean(y != classify_out)
    
    n <- length(y)
    tab = table(y)

    p_k <- as.vector(tab)/n
    q_k <- as.vector(table(classify_out))/n
    
    if (any(classify_out == "unknown")) {
        
        p_k = c(p_k, 0)
        
    }
    
    gamma_hat <- drop(p_k %*% (1 - q_k))
    
    R_hat <- (loo_boot - apparent)/(gamma_hat - apparent)
    w_hat <- 0.632/(1 - 0.368 * R_hat)
    
    errorRate632plus = ((1 - w_hat) * apparent + w_hat * loo_boot)
    
    list(   
        apparent = apparent,
        loo_boot = loo_boot,
        errorRate632plus = errorRate632plus
        )
  
}
  

   
  
