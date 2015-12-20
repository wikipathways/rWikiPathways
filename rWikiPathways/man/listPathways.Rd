\name{listPathways}
\alias{listPathways}
\title{
Lists the pathways available from the WikiPathways API server
}
\description{
Lists the pathways available from the WikiPathways API server
}
\usage{
listPathways(organism)
}
\arguments{
 \item{organism}{the organism to list the pathways for}
}
\value{
 \item{organism}{the available pathways}
}
\examples{
pathways <- listPathways()
pathways <- listPathways(organism="Homo sapiens")
}
\author{
Egon Willighagen
}
