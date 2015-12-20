\name{findPathwaysByXref}
\alias{findPathwaysByXref}
\title{
Get pathways for the given Xref
}
\description{
Get pathways for the given Xref
}
\usage{
findPathwaysByXref(identifier,systemCode)
}
\arguments{
 \item{identifier}{required string indicating the identifier for which to download pathways}
 \item{systemCode}{required string indicating the system code to return the Xrefs in}
}
\value{
 \item{pathways}{pathways that contains entities with the given identifier}
}
\examples{
  pathways = findPathwaysByXref("HMDB00001", "Ch")
  pathways = findPathwaysByXref(identifier="HMDB00001", systemCode="Ch")
}
\author{
Egon Willighagen
}
