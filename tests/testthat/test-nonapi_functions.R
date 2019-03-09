context("non-api funcitons")


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
      
    suppressWarnings(RNGversion("3.5.0"))
    set.seed(23)
    
    labels = sample(c("female", "male", "unknown", "noname"), 100, 
                    replace = TRUE)
    predictions = sample(c("female", "male", NA), 100, replace = TRUE)
    classificationErrors(labels, predictions)
    }$errorCoded, 
    
    0.6521739)
  
})
