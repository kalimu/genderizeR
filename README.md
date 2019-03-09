
<!-- README.md is generated from README.Rmd. Please edit that file -->
genderizeR
==========

by Kamil Wais [homepage / contact](https://kalimu.github.io)

[![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://www.r-project.org/Licenses/MIT) [![Lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/) [![Travis build status](https://travis-ci.org/kalimu/genderizeR.png?branch=master)](https://travis-ci.org/kalimu/genderizeR) [![CRAN Status](http://www.r-pkg.org/badges/version/genderizeR)](https://cran.r-project.org/package=genderizeR) [![CRAN Checks](https://cranchecks.info/badges/summary/genderizeR)](https://cran.r-project.org/web/checks/check_results_genderizeR.html) [![Monthly downloads badge](http://cranlogs.r-pkg.org/badges/last-month/genderizeR)](https://cran.r-project.org/package=genderizeR) [![Daily downloads badge](https://cranlogs.r-pkg.org/badges/last-day/genderizeR?color=blue)](https://CRAN.R-project.org/package=genderizeR) [![Weekly downloads badge](https://cranlogs.r-pkg.org/badges/last-week/genderizeR?color=blue)](https://CRAN.R-project.org/package=genderizeR) [![HitCount](http://hits.dwyl.io/kalimu/genderizer.svg)](http://hits.dwyl.io/kalimu/genderizer)

R package for gender predictions based on first names.

The package home page: <https://kalimu.github.io/project/genderizer/>

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
    #> Welcome to genderizeR package version: 2.0.0.9003
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
#> 1: winston   male        0.98   128
#> 2:     jan   male         0.6  1663
#> 3:   maria female        0.99  8402

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

For any kind of feedback you can use the contact form here: <https://kalimu.github.io/#contact>

How to contact the package's author regarding research or commercial project?
-----------------------------------------------------------------------------

Please use the contact form: <https://kalimu.github.io/#contact>

How to cite the package?
------------------------

``` r
citation('genderizeR')
#> 
#> Wais K (2006). "Gender Prediction Methods Based on First Names
#> with genderizeR." _The R Journal_, *8*(1), 17-37. doi:
#> 10.32614/RJ-2016-002 (URL: http://doi.org/10.32614/RJ-2016-002),
#> <URL: https://doi.org/10.32614/RJ-2016-002>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {{Gender Prediction Methods Based on First Names with
#>           genderizeR}},
#>     author = {Kamil Wais},
#>     year = {2006},
#>     journal = {{The R Journal}},
#>     doi = {10.32614/RJ-2016-002},
#>     pages = {17--37},
#>     volume = {8},
#>     number = {1},
#>     url = {https://doi.org/10.32614/RJ-2016-002},
#>   }
```

Thank You for the citation!
