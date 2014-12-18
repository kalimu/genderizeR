genderizeR
==========

R package for gender predictions based on first names.

An R package for communication with `OpenPoland.net API` - a gate to
open data in Poland

Kamil Wais

The package home page (in Polish):  
[<http://www.wais.kamil.rzeszow.pl/openpoland>](http://www.wais.kamil.rzeszow.pl/openpoland)

Here is the package tutorial (in Polish):  
[<http://www.wais.kamil.rzeszow.pl/pakiet-r-openpoland-tutorial/>](http://www.wais.kamil.rzeszow.pl/pakiet-r-openpoland-tutorial/)

Information about the openPoland.net project and documentation of the
API: [<http://openPoland.net>](http://openPoland.net)

Description
-----------

With `openPoland` package you can easily access milions records in more
thosands datasets of open data generated in institutions like Central
Statistical Office of Poland. The access to open data is available via
[openPoland.net](http://openPoland.net) API.

Installing the package
----------------------

### Stable version from CRAN

Not yet, but this is the goal. Please see below for code that let you
install the package from GitHub.

### Developer version from GitHub

Remember to install `devtools` package first!

    # install.packages('devtools')
    devtools::install_github("kalimu/openPoland")

    library(openPoland)

Registering for a token
-----------------------

You need to have a token to get an authorized acces do openPoland
database via API. To get a token you need only to register at
[<https://openpoland.net/signup/>](https://openpoland.net/signup/).

What's new?
-----------

    news(package = 'openPoland')

See help in R/Rstudio
---------------------

    help(package = 'openPoland')
    ?openPolandSearch
    ?openPolandMeta
    ?openPolandData
    ?openPolandFilter

How to contribute to the package (bugs, new functionalities)?
-------------------------------------------------------------

Fork git repo `https://github.com/kalimu/openPoland` and submit a pull
request.

How to contact the package's author?
------------------------------------

You can use the contact form here:
<http://www.wais.kamil.rzeszow.pl/kontakt/>

How to cite the package?
------------------------

    citation('openPoland')
