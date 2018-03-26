% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getOntologyTerms.R
\name{getPathwaysByParentOntologyTerm}
\alias{getPathwaysByParentOntologyTerm}
\title{Get Pathways by Parent Ontology Term}
\usage{
getPathwaysByParentOntologyTerm(term)
}
\arguments{
\item{term}{Official name of ontology term, e.g., "PW:0000045"}
}
\value{
List of pathway information, including WPID, url, name, species and revision
}
\description{
Retrieve pathway information for every pathway with a child term of given ontology term.
}
\examples{
\donttest{
getPathwaysByParentOntologyTerm('PW:0000045')
}
}