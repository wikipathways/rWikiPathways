\name{getColoredPathway}
\alias{getColoredPathway}
\title{
Get a colored pathways with certain nodes colored
}
\description{
Get a colored pathways with certain nodes colored
}
\usage{
getColoredPathway(pathway,revision,graphId,color,fileType)
}
\arguments{
 \item{pathway}{required string indicating the pathway to download, e.g. WP4}
 \item{revision}{optional argument to indicate a specific revision to download}
 \item{graphId}{required string or vector indicating the nodes to color}
 \item{color}{optional string or vector indicating the highlighting color.
   If not given, then nodes are colored red.}
 \item{fileType}{optional argument (only 'svg' supported at this moment)}
}
\value{
 \item{pathway}{Colored pathway in SVG format}
}
\examples{
\dontrun{
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"));
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    color="00FF00"
  );
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    color=c("FF0000", "00FF00")
  );
  writeLines(svg, "pathway.svg")
}
}
\author{
Egon Willighagen
}
