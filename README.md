
<!-- README.md is generated from README.Rmd. Please edit that file -->
genderizeR
==========

by Kamil Wais [homepage / contact](http://www.wais.kamil.rzeszow.pl)

[![Travis-CI Build Status](https://travis-ci.org/kalimu/genderizeR.png?branch=master)](https://travis-ci.org/kalimu/genderizeR) [![cran version](http://www.r-pkg.org/badges/version/genderizeR)](http://cran.rstudio.com/web/packages/genderizeR) [![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/genderizeR?)](https://github.com/metacran/cranlogs.app)

R package for gender predictions based on first names.

The package home page: <http://www.wais.kamil.rzeszow.pl/genderizer/>

Information about the genderize.io project and documentation of the API: <http://genderize.io>

Description
-----------

The genderizeR package uses genderize.io API to **predict gender** from first names extracted from text corpus (not only from clean vectors of given names). The accuracy of **prediction could be controlled** by two parameters: counts of first names in database and probability of gender given the first name. The package has also built-in functions that can **calculate specific errors** (also with bootstrapping), **train algorithm** on training dataset (with gender labels) and **prepare character vectors for gender checking**.

Installing the package
----------------------

### Installing stable version from CRAN

``` r
install.packages('genderizeR')
```

### Installing developer version from GitHub

Remember to install `devtools` package first!

``` r
# install.packages('devtools')
devtools::install_github("kalimu/genderizeR")
```

### Loading the installed package

``` r
library(genderizeR)
```

    #> 
    #> Welcome to genderizeR package version: 2.0.90002
    #> 
    #> Homepage: http://www.wais.kamil.rzeszow.pl/genderizeR
    #> 
    #> Changelog: news(package = 'genderizeR')
    #> Help & Contact: help(genderizeR)
    #> 
    #> If you find this package useful cite it please. Thank you!
    #> See: citation('genderizeR')
    #> 
    #> To suppress this message use:
    #> suppressPackageStartupMessages(library(genderizeR))

A working example
-----------------

``` r
# An example for a character vector of strings
x = c("Winston J. Durant, ASHP past president, dies at 84",
"JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM",
"Maria Sklodowska-Curie")
 
# Search for terms that could be first names
# If you have your API key you can authorize access to the API with apikey argument
# e.g. findGivenNames(x, progress = FALSE, apikey = 'your_api_key')
givenNames = findGivenNames(x, progress = FALSE)
```

``` r

# Use only terms that have more than x counts in the database
givenNames = givenNames[count > 100]
givenNames
#>       name gender probability count
#> 1:     jan   male        0.60  1692
#> 2:   maria female        0.99  8467
#> 3: winston   male        0.98   128

# Genderize the original character vector
genderize(x, genderDB = givenNames, progress = FALSE)
#>                                                              text
#> 1:             Winston J. Durant, ASHP past president, dies at 84
#> 2: JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM
#> 3:                                         Maria Sklodowska-Curie
#>    givenName gender genderIndicators
#> 1:   winston   male                1
#> 2:       jan   male                1
#> 3:     maria female                1
```

Tutorial
--------

For more comprehensive tutorial check the vignette in the package.

``` r
browseVignettes("genderizeR")
```

What's new in the package?
--------------------------

``` r
news(package = 'genderizeR')
```

See package help pages in R / Rstudio
-------------------------------------

``` r
help(package = 'genderizeR')
?textPrepare
?findGivenNames
?genderize
```

How to contribute to the package?
---------------------------------

### For bugs, updates and new functionalities:

Fork git repo `https://github.com/kalimu/genderizeR` and submit a pull request.

### Feedback:

If you enjoy using the package you could write a short testimonial and send it to me. I will be happy to post in on the package homepage.

For any kind of feedback you can use the contact form here: <http://www.wais.kamil.rzeszow.pl/kontakt/>

How to contact the package's author regarding research or commercial project?
-----------------------------------------------------------------------------

Please use the contact form: <http://www.wais.kamil.rzeszow.pl/kontakt/>

How to cite the package?
------------------------

``` r
citation('genderizeR')
```

Thank You for the citation!
