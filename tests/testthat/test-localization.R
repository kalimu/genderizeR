context("test-localization")

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("country_id works", {
  us_result = findGivenNames("Andrea", country = "us", progress = F)
  expect_equal(us_result$gender, "female")
  
  it_result = findGivenNames("Andrea", country = "it", progress = F)
  expect_equal(it_result$gender, "male")
})

test_that("language_id works", {
  us_result = findGivenNames("Andrea", language = "en", progress = F)
  expect_equal(us_result$gender, "female")
  
  it_result = findGivenNames("Andrea", language = "it", progress = F)
  expect_equal(it_result$gender, "male")
})
