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
#' 

#'
#' }
#' 
#' @export
#' 
genderizeBootstrapError = function(x, y, 
                          givenNamesDB,
                          probs, counts,
                          num_bootstraps = 50,
                          parallel = TRUE
                          ){
    
    givenNamesDB = data.table::as.data.table(givenNamesDB)
    
    writeLines(c("starting bootstraping..."), "bootstraping.log")
    
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
            
            sink("bootstraping.log", append = TRUE)
            
                cat(paste0('[',num_bootstraps,']: ', b,'\n'))
            
            sink()  # empty the sink stack
            
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
  
    


#      # source('http://www.stat.cmu.edu/~nmv/setup/mclapply.hack.R')
    #source('~/# Rscripts/WebOfScience/mclapply.hack.R')
    # http://www.stat.cmu.edu/~nmv/2014/07/14/implementing-mclapply-on-windows/
    
# # 
# #    set.seed(42)
# # 
# # counts =1
# # probs = c(0.6, 0.7)
# # 
# # devtools::load_all(pkg = "../genderizeR")
# # loo_boot = genderizeBootstrapError(x = x, y = y, givenNamesDB = givenNamesDB_titles, probs = probs, counts= counts, parallel = TRUE)
# # givenNamesDB = givenNamesDB_titles
# # l00_boot
# # 
# #     withCodes = titles[
# #             titles$genderCoded %in% c('male','female'), ]
# #     
# #     NROW(withCodes)
# # head(withCodes)
# # 
# #      x = withCodes$title[1:50]
# # 
# # 
# #     y = withCodes$genderCoded[1:50]
#     # parallel version
#     
#     writeLines(c("starting parallel bootstraping..."), "bootstraping.log")
#     seq_y <- seq_along(y)
#     rep_NA <- rep.int(NA, times = length(y))
# 
# 
#     funcPar = function(g, givenNamesDB=givenNamesDB) {
#   
#         training <- sample(seq_y, replace = TRUE)
#         
#         test <- which(!(seq_y %in% training))
#         
#         trainedParams = genderizeTrain(x=x[training], y=y[training], 
#                               givenNamesDB = givenNamesDB, 
#                               probs = probs, counts = counts, parallel=F)
#         trainedParams
#         
#         classifications = genderizePredict(trainedParams, 
#                                    newdata=x[test],
#                                    givenNamesDB = givenNamesDB)
#         
#         # mean(classifications != y[test])
#         
#         sink("bootstraping.log", append = TRUE)
#         
#             # b=23
#             cat(paste0('[',num_bootstraps,']: ', g,'\n'))
#         
#         sink()  # empty the sink stack
#         
#         replace(rep_NA, test, classifications != y[test])
#         
#     }
#     
#     # Inspired by:
#     # Nathan VanHoudnos
#     ## nathanvan AT northwestern FULL STOP edu
#     ## July 14, 2014  
# 
# 
# #   num_bootstraps=8     
#     ## Create a cluster
#     size.of.list <- length(list(seq_len(num_bootstraps))[[1]])
#     cl <- parallel::makeCluster( min(size.of.list, parallel::detectCores()) )
#     loaded.package.names = c('genderizeR', 'data.table') 
# 
# #     parallel::clusterExport(cl, c('x', 'y', 'givenNamesDB', 'probs', 'counts', 'loaded.package.names', 'funcPar','seq_y', 'rep_NA'))
# #    
#  parallel::clusterExport(cl, c('x', 'y', 'givenNamesDB', 'probs', 'counts', 'loaded.package.names', 'funcPar','seq_y', 'rep_NA', 'num_bootstraps'))
#     
#     parallel::parLapply( cl, 1:length(cl), function(xx){
#            lapply(loaded.package.names, function(yy) {
#                require(yy , character.only=TRUE)})
#        })
# 
# 
# #        this.env <- environment()
# #        while( identical( this.env, globalenv() ) == FALSE ) {
# #            parallel::clusterExport(cl,
# #                          ls(all.names=TRUE, env=this.env),
# #                          envir=this.env)
# #            this.env <- parent.env(environment())
# #        }
# #        parallel::clusterExport(cl,
# #                      ls(all.names=TRUE, env=globalenv()),
# #                      envir=globalenv())
#        
#     
#     ## Run the lapply in parallel
#    
#    loo_boot_error_rates = 
#     parallel::parLapply( cl, seq_len(num_bootstraps), funcPar) 
# #  loo_boot_error_rates
# 
# #   loo_boot_error_rates = lapply(seq_len(num_bootstraps), funcPar)
#  
# parallel::stopCluster(cl)
#     
#     
#     loo_boot_error_rates_backup = loo_boot_error_rates
#     # loo_boot_error_rates = loo_boot_error_rates_backup
#     
#     loo_boot_error_rates <- do.call(rbind, loo_boot_error_rates)
#     # loo_boot_error_rates[1,437] = TRUE
#     
#     loo_boot_error_rates <- colMeans(loo_boot_error_rates, na.rm = TRUE)
#     
#     if (any(is.nan(loo_boot_error_rates))) {
#         warning("Some observations were not included as test observations. Returning 'NaN'")
#     }
#     
#     return(loo_boot = mean(loo_boot_error_rates))
    


    
   
  
