#' Preparing text vector for gender prediction
#' 
#' \code{textPrepare} Takes a text vector and converts it into a vector 
#' of single and unique terms. This function is used by the \code{findGivenNames}
#'  function before sending a query to the API.
#' 
#' 
#' @param x A vector of character strings.
#' @param textPrepMessages If TRUE verbose output of the prepairing process 
#' is shown on the console.
 
#'
#' @return A vector of unique terms
#' 
#' 
#' 
#' @examples 
#' \dontrun{
#' 
#' x = c("Winston J. Durant, ASHP past president, dies at 84", 
#' "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg",
#' "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology", 
#' "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM", 
#' "Maria Sklodowska-Curie")
#' 
#' textPrepare(x)
#' 
#' }
#' 
#' @export

textPrepare = function(x, textPrepMessages = FALSE ) {


    if (textPrepMessages == TRUE) cat('removing special characters...\n')    
    
    x = stringr::str_replace_all(x, '-', " ")
    x = stringr::str_replace_all(x, '\\(|\\)|\'|,|\\|', " ")
    x = stringr::str_replace_all(x, '/|"', " ")
    x = stringr::str_replace_all(x, '@', " ")
    
    # x = stringr::str_replace_all(x, '[ ]*?.*?\\.', " ")
    # this line was giving problems with terms with initials at the end
    # probably it is artefact of previous solutions and it is completelly 
    # unnecessary...

    if (textPrepMessages == TRUE) cat('building text-mining corpus...\n')    
    
    x = tm::Corpus(tm::VectorSource(x))
    
    if (textPrepMessages == TRUE) cat('building term matrix...\n')   
    if (textPrepMessages == TRUE) cat('removing abbreviations...\n')  
    if (textPrepMessages == TRUE) cat('all characters to lower...\n')   
    if (textPrepMessages == TRUE) cat('removing numbers...\n')    
    if (textPrepMessages == TRUE) cat('removing punctuation...\n')        
    if (textPrepMessages == TRUE) cat('striping whitespaces...\n')    

    termMatrix = #suppressWarnings(
        tm::TermDocumentMatrix(x, 
                control = list(wordLengths = c(2,Inf),
                               tolower = TRUE,
                               removeNumbers = TRUE,
                               removePunctuation = TRUE, 
                               stripWhitespace = TRUE
                               )
                )
    
        # )
        
        # inspect(termMatrix)
    
    if (textPrepMessages == TRUE) cat('finding frequent terms...\n')    
    
        terms = tm::findFreqTerms(termMatrix, lowfreq = 1)
        terms

}

