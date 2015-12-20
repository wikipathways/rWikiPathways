# R Client Package for WikiPathways

R Client library for the WikiPathways API (http://webservice.wikipathways.org/) (license: MIT).

WikiPathays is described in the NAR paper by [Kutmon et al.](http://dx.doi.org/10.1093/nar/gkv1024).

# install

    > install.packages(c("curl", "plyr", "jsonlite")) # dependencies
    > install.packages("testthat") # if you want to test the package
    > install.packages("devtools") # to install from GitHub
    > library(devtools)
    > install_github("egonw/rwikipathways", subdir="rWikiPathways")

# examples

    > organisms = listOrganisms()
    > pathways = listPathways()
    > humanPathways = listPathways(organism="Homo sapiens")
