# ------------------------------------------------------------------------------
#' @title Get Ontology Terms by Pathway
#'
#' @description Retrieve information about ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of tag name, display name, revision, text, timestampe and user
#' @examples \donttest{
#' getOntologyTerms('WP554')
#' }
#' @export
getOntologyTerms <- function(pathway) {
    res <- wikipathwaysGET('getOntologyTermsByPathway',list(pwId=pathway))
    return(unname(res$terms))
}

# ------------------------------------------------------------------------------
#' @title Get Ontology Term Names by Pathway
#'
#' @description Retrieve names of ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of term names
#' @examples \donttest{
#' getOntologyTermNames('WP554')
#' }
#' @export
getOntologyTermNames <- function(pathway) {
    unlist(lapply(getOntologyTerms(pathway), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title Get Ontology Term IDs by Pathway
#'
#' @description Retrieve identifiers of ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of term identifiers
#' @examples \donttest{
#' getOntologyTermIds('WP554')
#' }
#' @export
getOntologyTermIds <- function(pathway) {
    unlist(lapply(getOntologyTerms(pathway), function(x) {unname(x['id'])}))
}


# ------------------------------------------------------------------------------
#' @title Get Pathways by Ontology Term 
#'
#' @description Retrieve pathway information for every pathway with a given ontology term.
#' @param term Official name of ontology term, e.g., "PW:0000045"
#' @return List of pathway information, including WPID, url, name, species and revision
#' @examples \donttest{
#' getPathwaysByOntologyTerm('PW:0000045')
#' }
#' @export
getPathwaysByOntologyTerm <- function(term) {
    res <- wikipathwaysGET('getPathwaysByOntologyTerm',list(term=term))
    return(unname(res$pathways))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway WPIDs by Ontology Term 
#'
#' @description Retrieve pathway WPIDs for every pathway with a given ontology term.
#' @param term Official name of ontology term, e.g., "PW:0000045"
#' @return List of pathway WPIDs
#' @examples \donttest{
#' getPathwayIdsByOntologyTerm('PW:0000045')
#' }
#' @export
getPathwayIdsByOntologyTerm <- function(term) {
    unlist(lapply(getPathwaysByOntologyTerm(term), function(x) {unname(x['id'])}))
}

# ------------------------------------------------------------------------------
#' @title Get Pathways by Parent Ontology Term 
#'
#' @description Retrieve pathway information for every pathway with a child term of given ontology term.
#' @param term Official name of ontology term, e.g., "PW:0000045"
#' @return List of pathway information, including WPID, url, name, species and revision
#' @examples \donttest{
#' getPathwaysByParentOntologyTerm('PW:0000045')
#' }
#' @export
getPathwaysByParentOntologyTerm <- function(term) {
    res <- wikipathwaysGET('getPathwaysByParentOntologyTerm',list(term=term))
    return(unname(res$pathways))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway WPIDs by Parent Ontology Term 
#'
#' @description Retrieve pathway WPIDs for every pathway with a child term of given ontology term
#' @param term Official name of ontology term, e.g., "PW:0000045"
#' @return List of pathway WPIDs
#' @examples \donttest{
#' getPathwayIdsByParentOntologyTerm('PW:0000045')
#' }
#' @export
getPathwayIdsByParentOntologyTerm <- function(term) {
    unlist(lapply(getPathwaysByParentOntologyTerm(term), function(x) {unname(x['id'])}))
}

