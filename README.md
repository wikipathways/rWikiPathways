[![Build Status](https://travis-ci.org/egonw/rwikipathways.svg?branch=master)](https://travis-ci.org/egonw/rwikipathways)

# R Client Package for WikiPathways

R Client library for the WikiPathways API (http://webservice.wikipathways.org/) (license: MIT).

WikiPathays is described in the NAR paper by [Kutmon et al.](http://dx.doi.org/10.1093/nar/gkv1024)

If you like this package, or want to make it easier to work with Xrefs, then
you may also like these R packages:

* [BridgeDbR](https://github.com/BiGCAT-UM/bridgedb-r)
* [PathVisioRPC](http://projects.bigcat.unimaas.nl/pathvisiorpc/)

# How to install

    > install.packages(c("curl", "plyr", "jsonlite")) # dependencies
    > install.packages("testthat") # if you want to test the package
    > install.packages("devtools") # to install from GitHub
    > library(devtools)
    > install_github("egonw/rwikipathways", subdir="rWikiPathways")

# Examples

    > organisms = listOrganisms()
    > pathways = listPathways()
    > humanPathways = listPathways(organism="Homo sapiens")
    > gpml = getPathway(pathway="WP4")
    > gpml = getPathway(pathway="WP4", revision=83654)
    > info = getPathwayInfo(pathway="WP4")
    > xrefs = getXrefList(pathway="WP2338", systemCode="S")
    > pathways = findPathwaysByXref("HMDB00001", "Ch")
    > pathways = findPathwaysByXref(identifier="HMDB00001", systemCode="Ch")
    > pathways = findPathwaysByXref(
    >   identifier=c("HMDB00001", "HMDB00002"),
    >   systemCode=c("Ch", "Ch")
    > )
    > svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"));
    > svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    >   color="00FF00");
    > svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    >   color=c("FF0000", "00FF00"));
    > writeLines(svg, "pathway.svg")
