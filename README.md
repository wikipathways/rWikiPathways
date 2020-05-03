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

## Getting Started
* [Documentation site](https://wikipathways.github.io/rWikiPathways/index.html)
* [Overview vignette](articles/Overview.html)

## How to install
**_Official bioconductor releases_ (recommended)**
```
if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
BiocManager::install("rWikiPathways")
```
*Note: Be sure to use the [latest Bioconductor](https://www.bioconductor.org/install/) and recommended R version* 

**_Unstable development code from this repo_ (at your own risk)**
```
install.packages("devtools")
library(devtools)
install_github('wikipathways/rWikiPathways', build_vignettes=TRUE)
library(rWikiPathways)
```
#### Troubleshooting
1. If you see this error on a Mac: ```make: gfortran-4.8: No such file or directory```, then try reinstalling R via [homebrew](https://brew.sh/): ```brew update && brew reinstall r```
   * warning: this make take ~30 minutes

## How to contribute
This is a public, open source project. Come on in! You can contribute at multiple levels:

* Report an issue or feature request
* Fork and make pull requests
* Contact current WikiPathways developers and inquire about joining the team

### Development
```
install.packages("devtools")
install.packages("roxygen2") 
library(devtools,roxygen2)
devtools::install_github("AlexanderPico/docthis")
library(docthis)
setwd("/git/wikipathways/rWikiPathways") #customize to your setup
devtools::document()
devtools::check()
BiocCheck::BiocCheck('./')
```

### Testing
Unit tests are a crucial tool in software development. Be sure to [add tests](tests/testthat) for any new methods implemented. These will be run as part of the `devtools::check()`. 

### Updating site
We use [pkgdown](https://pkgdown.r-lib.org/) to generate the [main site for rWikiPathways](https://wikipathways.github.io/rWikiPathways/index.html) based on this README, metadata, man pages and vignettes. If you make changes to any of these, please take a moment to regenerate the site:
```
library(pkgdown)
pkgdown::build_site()
```

### Bioconductor
While this is the primary development repository for the rWikiPathways project, we also make regular pushes to official bioconductor repository ([devel](http://bioconductor.org/packages/devel/bioc/html/rWikiPathways.html) & [release](http://bioconductor.org/packages/release/bioc/html/rWikiPathways.html)) from which the official releases are generated. This is the correct repo for all coding and bug reporting interests. The tagged releases here correspond to the bioconductor releases via a manual syncing process. The `master` branch here corresponds to the latest code in development and not yet released. 

```
git commit -m "informative commit message"
git push origin master
git push upstream master
```
http://bioconductor.org/developers/how-to/git/push-to-github-bioc/

Following each bioconductor release, a `RELEASE_#_#` branch is created. The new branch is fetched and master is updated:

```
git fetch upstream
git checkout -b RELEASE_3_11 upstream/RELEASE_3_11
git push origin RELEASE_3_11
git checkout master
git pull upstream master
```

Only bug fixes and documentation updates can be pushed to the official bioconductor release branch. After committing fixes to `master`, then:

```
git checkout RELEASE_3_11
git cherry-pick master #for latest commit
# or git cherry-pick <commit number> #for specific commit
# bump version in DESCRIPTION
git add DESCRIPTION
git commit -m 'version bump'
git push origin RELEASE_3_11
# double check changes, and then...
git push upstream RELEASE_3_11
git checkout master
```

And then finally, bump version and commit DESCRIPTION to `master` and push to origin and upstream.

https://bioconductor.org/developers/how-to/git/bug-fix-in-release-and-devel/

### Vignettes
When adding or updating vignettes, consider the following tips for consistency:
* Copy/paste the header from an existing rWikiPathways vignette, including the global knitr options
* Number the *VignetteIndexEntry* names w.r.t. other vignettes (this determines their presentation order)
* Avoid spaces in Rmd filenames; causes CHECK errors
* When ready, run **Knit to html_vignette_** and review the generated html
* Note: you don't need to save the html version; it will be generated anew at Bioconductor.
* In the end, you should just have an Rmd version of each vignette in the repo.

