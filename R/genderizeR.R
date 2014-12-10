
.onAttach <- function(libname, pkgname) {
    
    packageStartupMessage(paste0('genderizeR Package version: ',
                                 utils::packageVersion("genderizeR"))
                          )
    packageStartupMessage("\nSee what's new: news(package = 'genderizeR')")
    packageStartupMessage("\nSee help: help(genderizeR)")
    
    packageStartupMessage("\nIf you find this package useful cite it please. Thank you! ")
    packageStartupMessage("See: citation('genderizeR')")

}
# detach("package:genderizeR", unload=TRUE)
