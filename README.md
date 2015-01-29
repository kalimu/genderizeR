genderizeR
==========

Kamil Wais

R package for gender predictions based on first names.

Author's home page:
[<http://www.wais.kamil.rzeszow.pl>](http://www.wais.kamil.rzeszow.pl)

Information about the genderize.io project and documentation of the API:
[<http://genderize.io>](http://genderize.io)

Description
-----------

The genderizeR package uses genderize.io API to predict gender from
first names extracted from text corpuses. The accuracy of prediction
could be control by two parameters: counts of first names in database
and probability of gender given the first name.

Installing the package
----------------------

### Stable version from CRAN

    install.packages('genderizeR')

### Developer version from GitHub

Remember to install `devtools` package first!

    # install.packages('devtools')
    devtools::install_github("kalimu/genderizeR")

    library(genderizeR)

    ## Welcome to genderizeR package version: 1.0.0
    ## 
    ## Changelog: news(package = 'genderizeR')
    ## Help & Contact: help(genderizeR)
    ## 
    ## If you find this package useful cite it please. Thank you! 
    ## See: citation('genderizeR')
    ## 
    ## To suppress this message use:
    ## suppressPackageStartupMessages(library(genderizeR))

A working example
-----------------

    # How many unique first names are there in genderize.io database?
    numberOfNames()

    ## [1] 199969

    # An example for a character vector of strings
    x = c("Winston J. Durant, ASHP past president, dies at 84",
    "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg",
    "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology",
    "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM",
    "Maria Sklodowska-Curie")

    # Search for terms that could be first names
    givenNames = findGivenNames(x, progress = FALSE)

    # Use only terms that have more than 40 counts in the database
    givenNames = givenNames[count>40]
    givenNames

    ##       name gender probability count
    ## 1:     jan   male        0.58  5479
    ## 2:   maria female        1.00 21262
    ## 3: norbert   male        1.00    59
    ## 4: winston   male        0.97    68

    # Genderize the original character vector
    genderize(x, genderDB=givenNames, blacklist=NULL, progress = FALSE)

    ##                                                                             text
    ## 1:                            Winston J. Durant, ASHP past president, dies at 84
    ## 2:   Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg
    ## 3: The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology
    ## 4:                JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM
    ## 5:                                                        Maria Sklodowska-Curie
    ##    givenName gender genderIndicators
    ## 1:   winston   male                1
    ## 2:   norbert   male                1
    ## 3:        NA     NA                0
    ## 4:       jan   male                1
    ## 5:     maria female                1

What's new?
-----------

    news(package = 'genderizeR')

See help in R/Rstudio
---------------------

    help(package = 'genderizeR')
    ?numberOfNames
    ?findGivenNames
    ?genderize

How to contribute to the package (bugs, new functionalities)?
-------------------------------------------------------------

Fork git repo `https://github.com/kalimu/genderizeR` and submit a pull
request.

How to contact the package's author?
------------------------------------

You can use the contact form here:
<http://www.wais.kamil.rzeszow.pl/kontakt/>

How to cite the package?
------------------------

    citation('genderizeR')
