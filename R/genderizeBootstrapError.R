#' Gender prediction errors on bootstrap samples
#' 
#' \code{genderizeBootstrapError} calculates the Apparent Error Rate, the Leave-One-Out bootstrap error rate  and the .632+ error rate from Efron and Tibishirani (1997). The code is modified version of several functions from \code{sortinghat} package by John A.Ramey.
#' 
#' 
#' @param x A text vector that we want to genderize
#' @param y A text vector of true gender labels for x vector
#' @param givenNamesDB A dataset with gender data (could be an output of \code{findGivenNames} function)
#' @param probs A numeric vector of different probability values. 
#' Used to subseting a givenNamesDB dataset
#' @param counts A numeric vector of different count values. 
#' Used to subseting a givenNamesDB dataset
#' @param parallel It is passed to \code{genderizeTrain} function. If TRUE it computes errors with the use of \code{parallel} package and available cores. It is design to work on windows machines. Default is FALSE.
#' 
#' @return A list of bootstrap errors:
#'   \item{apparent}{Apparent Error Rate}
#'   \item{loo_boot}{LOO-Boot Error Rate}
#'   \item{errorRate632plus}{.632+ Error Rate}
#'   
#' @seealso In the \code{sortinghat} package: \code{\link[sortinghat]{errorest_apparent}} \code{\link[sortinghat]{errorest_loo_boot}} \code{\link[sortinghat]{errorest_632plus}} 
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c('Alex', 'Darrell', 'Kale', 'Lee', 'Robin', 'Terry', rep('Robin', 20))
#' y = c('female', 'female', 'female', 'female', 'female', 'female', rep('male', 20))
#' givenNamesDB = findGivenNames(x)
#' classificatonErrors(labels = y,predictions = y)
#' probs = seq(from =  0.5, to = 0.9, by = 0.05)
#' counts = c(1)
#' set.seed(23); genderizeBootstrapError(x = x, y = y, givenNamesDB = givenNamesDB, probs = probs, counts = counts, num_bootstraps = 20, parallel = TRUE)
#'$apparent
#'[1] 0.9230769
#'$loo_boot
#'[1] 0.9401709
#'$errorRate632plus
#'[1] 0.9336006
#'
#' }
#' 
#' @export
#' 
genderizeBootstrapError = function(x, y, 
                          givenNamesDB,
                          probs, counts,
                          num_bootstraps = 50,
                          parallel = FALSE
                          ){
    
    givenNamesDB = data.table::as.data.table(givenNamesDB)
    
    seq_y <- seq_along(y)
    rep_NA <- rep.int(NA, times = length(y))
    
#     writeLines(c("starting bootstraping..."), "bootstraping.log")
    
    loo_boot_error_rates <- 
        
        lapply(seq_len(num_bootstraps), function(b) {
            
            training <- sample(seq_y, replace = TRUE)
            test <- which(!(seq_y %in% training))
            
            trainedParams = genderizeTrain(x=x[training], y=y[training],
                                           givenNamesDB = givenNamesDB,
                                           probs = probs, counts = counts, 
                                           parallel=parallel)
            
            classifications = genderizePredict(trainedParams,
                                               newdata=x[test],
                                               givenNamesDB = givenNamesDB)
#             
#             sink("bootstraping.log", append = TRUE)
#             
#                 cat(paste0('[',num_bootstraps,']: ', b,'\n'))
#             
#             sink()  # empty the sink stack
            
            print(b)
            
            replace(rep_NA, test, classifications != y[test])
            
        })
    
    loo_boot_error_rates <- do.call(rbind, loo_boot_error_rates)
    loo_boot_error_rates <- colMeans(loo_boot_error_rates, na.rm = TRUE)
    
    if (any(is.nan(loo_boot_error_rates))) {
        
        warning("Some observations were not included as test observations. Returning 'NaN'")
        
    }
    
    loo_boot = mean(loo_boot_error_rates)
    
    trainedParams = genderizeTrain(x=x, y=y, 
                                   givenNamesDB = givenNamesDB, 
                                   probs = probs, counts = counts,  
                                   parallel=parallel)
    
    classify_out = genderizePredict(trainedParams = trainedParams, 
                                       newdata = x, 
                                       givenNamesDB  = givenNamesDB)  
    
    apparent= mean(y != classify_out)
    
    n <- length(y)
    tab = table(y)
    tab = c(tab,'unknown' = 0)
    tab = as.table(tab)
    
    p_k <- as.vector(tab)/n
    q_k <- as.vector(table(classify_out))/n

if (!any(classify_out == "unknown")) {
    q_k = c(q_k, 0)
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
  
    

    
   
  
