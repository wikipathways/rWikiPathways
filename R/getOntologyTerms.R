# ------------------------------------------------------------------------------
#' @title Get Ontology Terms by Pathway
#'
#' @description Retrieve information about ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway, e.g. WP554. If
#' NULL, then ontology term information for all pathways is returned.
#' @return A \code{data.frame} pathway id and term information
#' @examples {
#' getOntologyTerms('WP554')
#' }
#' @export
getOntologyTerms <- function(pathway=NULL) {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/getOntologyTermsByPathway.json")
    res.df <- res$pathways %>%
        purrr::map_df(~as_tibble(.)) %>%
        unnest_wider(terms, names_sep = "_")
    
    if(!is.null(pathway))
        res.df <- dplyr::filter(res.df, id == pathway)
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Get Ontology Term Names by Pathway
#'
#' @description Retrieve names of ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return A \code{list} of term names
#' @examples {
#' getOntologyTermNames('WP554')
#' }
#' @export
getOntologyTermNames <- function(pathway=NULL) {
    return(unique(getOntologyTerms(pathway)$terms_name))
}

# ------------------------------------------------------------------------------
#' @title Get Ontology Term IDs by Pathway
#'
#' @description Retrieve identifiers of ontology terms for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return A \code{list} of term identifiers
#' @examples {
#' getOntologyTermIds('WP554')
#' }
#' @export
getOntologyTermIds <- function(pathway=NULL) {
    return(unique(getOntologyTerms(pathway)$terms_id))
}


# ------------------------------------------------------------------------------
#' @title Get Pathways by Ontology Term 
#'
#' @description Retrieve pathway information for every pathway with a given ontology term.
#' @param term (\code{character}) Official name of ontology term, e.g., "PW:0000045"
#' @return A \code{data.frame} of pathway information
#' @examples {
#' getPathwaysByOntologyTerm('PW:0000045')
#' }
#' @export
getPathwaysByOntologyTerm <- function(term=NULL) {    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/getPathwaysByOntologyTerm.json")
    res.df <- res$terms %>%
    purrr::map_df(~as_tibble(.)) %>%
    unnest_wider(pathways, names_sep = "_")

if(!is.null(term))
    res.df <- dplyr::filter(res.df, id == term)

return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway WPIDs by Ontology Term 
#'
#' @description Retrieve pathway WPIDs for every pathway with a given ontology term.
#' @param term (\code{character}) Official name of ontology term, e.g., "PW:0000045"
#' @return A \code{list} of pathway WPIDs
#' @examples {
#' getPathwayIdsByOntologyTerm('PW:0000045')
#' }
#' @export
getPathwayIdsByOntologyTerm <- function(term=NULL) {
    return(unique(getPathwaysByOntologyTerm(term)$pathways_id))
}

# ------------------------------------------------------------------------------
#' @title Get Pathways by Parent Ontology Term 
#'
#' @description Retrieve pathway information for every pathway with a child term of given ontology term.
#' @param term (\code{character}) Official name of ontology term, e.g., "PW:0000045"
#' @return A \code{data.frame} of pathway information
#' @examples {
#' getPathwaysByParentOntologyTerm('PW:0000045')
#' }
#' @export
getPathwaysByParentOntologyTerm <- function(term=NULL) {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/getPathwaysByOntologyTerm.json")
    res.df <- res$terms %>%
        purrr::map_df(~as_tibble(.)) %>%
        unnest_wider(pathways, names_sep = "_")
    
    if(!is.null(term))
        res.df <- dplyr::filter(res.df, parent == term)
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway WPIDs by Parent Ontology Term 
#'
#' @description Retrieve pathway WPIDs for every pathway with a child term of given ontology term
#' @param term (\code{character}) Official name of ontology term, e.g., "PW:0000045"
#' @return A \code{list} of pathway WPIDs
#' @examples {
#' getPathwayIdsByParentOntologyTerm('PW:0000045')
#' }
#' @export
getPathwayIdsByParentOntologyTerm <- function(term=NULL) {
    return(unique(getPathwaysByParentOntologyTerm(term)$pathways_id))
}

