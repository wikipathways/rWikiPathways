\name{getXrefList}
\alias{getXrefList}
\title{
Get the Xrefs for a specific pathway for a particular system code
}
\description{
Get the Xrefs for a specific pathway for a particular system code
}
\usage{
getXrefList(pathway,systemCode)
}
\arguments{
 \item{pathway}{required string indicating the pathway to download, e.g. WP4}
 \item{systemCode}{required string indicating the system code to return the Xrefs in}
}
\value{
 \item{xrefs}{a list of Xrefs}
}
\examples{
  xrefs = getXrefList("WP2338", "S")
  xrefs = getXrefList(pathway="WP2338", systemCode="S")
}
\author{
Egon Willighagen
}
