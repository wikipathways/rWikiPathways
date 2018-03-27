# R Client Package for WikiPathways
[![Travis-CI Build Status](https://travis-ci.org/wikipathways/rWikiPathways.svg?branch=master)](https://travis-ci.org/wikipathways/rWikiPathways)

R Client library for the WikiPathways API (https://webservice.wikipathways.org/) (license: MIT).

WikiPathays is described in the following papers:
* 2016 NAR paper by [Kutmon et al.](https://doi.org/10.1093/nar/gkv1024)
* 2018 NAR paper by [Slenter et al.](https://doi.or/10.1093/nar/gkx1064)

If you like this package, or want to make it easier to work with Xrefs, then
you may also like these R packages:

* [BridgeDbR](https://github.com/BiGCAT-UM/bridgedb-r)
* [PathVisioRPC](http://projects.bigcat.unimaas.nl/pathvisiorpc/)
* [RCy3](https://github.com/cytoscape/RCy3)

## How to install
**_Official bioconductor releases_ (recommended)**
```
source("https://bioconductor.org/biocLite.R")
biocLite("rWikiPathways")
```
_Unstable development code from this repo_ (at your own risk)
```
install.packages("devtools")
library(devtools)
install_github('wikipathways/rWikiPathways', build_vignettes=TRUE)
library(rWikiPathways)
```

## Examples
* [Overview vignette](vignettes/Overview.Rmd)
