context("api function")


# helper checking function if CRAN can connect with the API
api_working <- function() {
    
    response <- 
        tryCatch({
            response = httr::status_code(
                httr::GET("https://api.genderize.io?name=kamil", 
                          httr::config(ssl_verifypeer = FALSE))
                )       
        }, error = function(cond) {
            return(NULL)
        }) 
    
    if (!is.null(response) && response == 200) {
        return(TRUE)
    } else {
        return(FALSE)
    }
    
} # end of api_working

check_api <- function() {
    
    if (!api_working()) {
        skip("API not avilable. Test skipped.")    
    }
    
} # end of check_api


test_that("testing genderizeAPI", {
  
  check_api()

  expect_identical(
    httr::content(httr::GET("https://api.genderize.io?name=kamil", 
                          httr::config(ssl_verifypeer = FALSE)))$gender,
    "male"
  )

  expect_true((genderizeAPI("Kamil", ssl.verifypeer = FALSE)$limit) <= 1000)
  
  expect_output(genderizeAPI("Kamil", ssl.verifypeer = FALSE, apikey = 'test'), 'Unauthorized')

})

 
test_that("genderize and findGivenNames", {capture.output({
    
  check_api()
  
  expect_equal({
     x = c(
       "Winston J. Durant, ASHP past president, dies at 84", 
       "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg", 
       "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM", 
       "Maria Sklodowska-Curie")
     givenNames = findGivenNames(x, progress = FALSE, ssl.verifypeer = FALSE)
     givenNames = givenNames[name %in% c("winston", "norbert", "jan", "maria")]
     result = genderize(x, genderDB = givenNames, 
                        blacklist = NULL, progress = FALSE)
     c(result$gender)
     }, 
     
     c("male", "male", "male", "female")
  )

})})


test_that("country_id works", {
  
  check_api()
  
  us_result <- findGivenNames("Andrea", country = "us", progress = FALSE, ssl.verifypeer = FALSE)
  expect_equal(us_result$gender, "female")
  
  it_result  <- findGivenNames("Andrea", country = "it", progress = FALSE, ssl.verifypeer = FALSE)
  expect_equal(it_result$gender, "male")
  
})

test_that("language_id works", {
  
  check_api()
  
  us_result <- findGivenNames("Andrea", language = "en", progress = FALSE, ssl.verifypeer = FALSE)
  expect_equal(us_result$gender, "female")
  
  it_result  <- findGivenNames("Andrea", language = "it", progress = FALSE, ssl.verifypeer = FALSE)
  expect_equal(it_result$gender, "male")
  
})

