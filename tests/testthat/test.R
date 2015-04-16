
context("genderize.io API")
 
test_that("given name found", {
    
    expect_identical((genderizeAPI("Kamil")$response)$name, "Kamil")
    
    
    
})

test_that("subscription limits", {
    
    expect_true((genderizeAPI("Kamil")$limit) <= 1000)
    
})

test_that("authorization", {
    
   # expect_is(genderizeAPI("Kamil", apikey = 'test'), 'function')
   expect_output(genderizeAPI("Kamil", apikey = 'test'), 'Unauthorized')

})

 
