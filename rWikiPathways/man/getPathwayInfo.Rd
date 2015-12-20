\name{getPathwayInfo}
\alias{getPathwayInfo}
\title{
Get info for a specific pathway
}
\description{
Get info for a specific pathway
}
\usage{
getPathwayInfo(pathway)
}
\arguments{
 \item{pathway}{required string indicating the pathway to download, e.g. WP4}
}
\value{
 \item{info}{information about the pathway}
}
\examples{
info = getPathwayInfo("WP4")
info = getPathwayInfo(pathway="WP4")
}
\author{
Egon Willighagen
}
