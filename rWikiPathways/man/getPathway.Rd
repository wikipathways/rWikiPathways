\name{getPathway}
\alias{getPathway}
\title{
Get a specific pathway in the GPML format
}
\description{
Get a specific pathway in the GPML format
}
\usage{
getPathway(pathway, revision)
}
\arguments{
 \item{pathway}{required string indicating the pathway to download, e.g. WP4}
 \item{revision}{optional argument to indicate a specific revision to download}
}
\value{
 \item{organism}{a string with GPML content}
}
\examples{
gpml = getPathway("WP4")
gpml = getPathway(pathway="WP4")
gpml = getPathway(pathway="WP4", revision=83654)
}
\author{
Egon Willighagen
}
