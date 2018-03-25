# R Client Package for WikiPathways
[![Travis-CI Build Status](https://travis-ci.org/wikipathways/rwikipathways.svg?branch=master)](https://travis-ci.org/wikipathways/rwikipathways)

R Client library for the WikiPathways API (https://webservice.wikipathways.org/) (license: MIT).

WikiPathays is described in the NAR paper by [Kutmon et al.](http://dx.doi.org/10.1093/nar/gkv1024)

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
* [Overview vigenette](vignettes/Overview.Rmd)
