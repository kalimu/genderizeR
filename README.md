genderizeR
==========

Kamil Wais

R package for gender predictions based on first names.

The package home page (in Polish):  
[<http://www.wais.kamil.rzeszow.pl/genderizer>](http://www.wais.kamil.rzeszow.pl/genderizer)

Information about the openPoland.net project and documentation of the
API: [<http://genderize.io>](http://genderize.io)

Description
-----------

The R package `genderizeR` communicates with `genderize.io API` - a gate
to huge database of first names and theirs gender. Functions from the
package takes as input a character string (or strings) and prepare text
for gender prediction that is based on first names that appear somewhere
in each element of the character vector.

Installing the package
----------------------

### Stable version from CRAN

Not yet, but this is the goal. Please see below for code that let you
install the package from GitHub.

### Developer version from GitHub

Remember to install `devtools` package first!

    # install.packages('devtools')
    devtools::install_github("kalimu/genderizeR")

    library(genderizeR)

    ## Downloading github repo kalimu/genderizeR@master
    ## Installing genderizeR
    ## "C:/PROGRA~1/R/R-31~1.2/bin/x64/R" --vanilla CMD INSTALL "C:\Users\Kamil  \
    ##   Wais\AppData\Local\Temp\RtmpGihsvI\devtools242c304d6ff\kalimu-genderizeR-9337efb5cf9dfc16261bf475c200deaf0f1af9b0"  \
    ##   --library="C:/Program Files/R/R-3.1.2/library" --install-tests 
    ## 
    ## Welcome to genderizeR package version: 0.0.1
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

    ## [1] 190560

    # An example for a character vector of strings
    x = c("Winston J. Durant, ASHP past president, dies at 84",
    "Gold Badge of Honour of the DGAI Prof. Dr. med. Norbert R. Roewer Wuerzburg",
    "The contribution of professor Yu.S. Martynov (1921-2008) to Russian neurology",
    "JAN BASZKIEWICZ (3 JANUARY 1930 - 27 JANUARY 2011) IN MEMORIAM",
    "Maria Sklodowska-Curie")

    # Search for terms that could be first names
    givenNames = findGivenNames(x)

    ## Packages done: 1. Packages left: 0. Names: 12.
    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |=================================================================| 100%

    # Use only terms that have more than 40 counts in the database
    givenNames = givenNames[count>40]
    givenNames

    ##       name gender probability count
    ## 1:     jan   male        0.59  1032
    ## 2:   maria female        0.99  5604
    ## 3: norbert   male        1.00    56
    ## 4: winston   male        0.97    61

    # Genderize the original character vector
    genderize(x, genderDB=givenNames, blacklist=NULL)

    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |=================================================================| 100%

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
