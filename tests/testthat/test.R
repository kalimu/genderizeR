context("Functions outputs")

# helper checking function if CRAN cannot connect with API
api_working <- function() {
    
    response <- 
        tryCatch({
            response = httr::status_code(
                httr::GET("https://api.genderize.io")
                )       
        }, error = function(cond) {
            return(NULL)
        }) 
    
    if (!is.null(response) && response == 200) {
        return(TRUE)
    } else {
        return(FALSE)
    }
    
}


check_api <- function() {
    
    if (!api_working()) {
        skip("API not avilable. Test skipped.")    
    }
    
}


test_that("textPrepare", {
    
    expect_equal(textPrepare("kamil"), "kamil")
    expect_equal(textPrepare("KAMIL"), "kamil")
    expect_equal(textPrepare("Kamil Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil L. Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil L.B. Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil L. B. Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("K. L. Wais"), c("wais"))
    expect_equal(textPrepare("K.L. Wais"), c("wais"))
    expect_equal(textPrepare("K. Wais"), c("wais"))
    expect_equal(textPrepare("Wais K."), c("wais"))
    expect_equal(textPrepare("Wais K.L."), c("wais"))
    expect_equal(textPrepare("Wais K. L."), c("wais"))
    expect_equal(textPrepare("Wais 1980"), c("wais"))
    expect_equal(textPrepare("Wais (1980)"), c("wais"))
    expect_equal(textPrepare("Kamil-Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil'a Wais"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil|Wais"), c("kamil", "wais"))
    expect_equal(textPrepare('Kamil "Wais"'), c("kamil", "wais"))
    expect_equal(textPrepare('Kamil "Wais"'), c("kamil", "wais"))
    expect_equal(textPrepare('Kamil@Wais.com'), c("com", "kamil", "wais"))
    expect_equal(textPrepare("Kamil Wais!!!"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil Wais???"), c("kamil", "wais"))
    expect_equal(textPrepare("Kamil /Wais"), c("kamil", "wais"))
    
})

test_that("classificationErrors", {
    
    expect_equal({
    set.seed(23)
    labels = sample(c("female", "male", "unknown", "noname"), 100, 
                    replace = TRUE)
    predictions = sample(c("female", "male", NA), 100, replace = TRUE)
    classificationErrors(labels, predictions)
    }$errorCoded, 0.6521739)
})

test_that("genderizeAPI", {
    
    check_api()
    expect_true((genderizeAPI("Kamil")$limit) <= 1000)
    expect_output(genderizeAPI("Kamil", apikey = 'test'), 'Unauthorized')

})

 
test_that("genderize and findGivenNames", {
    
    check_api()
    
    expect_equal({
       x = c("Winston J. Durant, ASHP past president, dies at 84", "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg", "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology", "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM", "Maria Sklodowska-Curie")
       givenNames = findGivenNames(x, progress = FALSE)
       givenNames = givenNames[count > 40]
       result = genderize(x, genderDB = givenNames, 
                          blacklist = NULL, progress = FALSE)
       c(result$givenName, result$gender)
   }, c("winston", "med", "yu", "jan", "maria",
        "male", "male", "female", "male", "female")
   )

})

 
