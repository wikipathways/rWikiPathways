# ------------------------------------------------------------------------------
#' @title Find Pathways By ORCID
#'
#' @description Retrieve pathways containing the query ORCID
#' @param query The \code{character} ORCID to search for.
#' @return A \code{dataframe} of pathway attributes including the matching
#' ORCIDs
#' @examples {
#' findPathwaysByOrcid(' 0000-0001-9773-4008')
#' }
#' @export
#' @importFrom purrr map_dfr
#' @import dplyr
findPathwaysByOrcid <- function(query=NULL) {
    if(is.null(query))
        stop("Must provide an ORCID, e.g.,  0000-0001-9773-4008")
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/findPathwaysByOrcid.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) 

    res.df <- res.df %>%
        rowwise() %>%
        dplyr::filter(grepl(tolower(query),tolower(orcids)))

    if(nrow(res.df) == 0)
        message("No results")
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By ORCID 
#'
#' @description Retrieve list of pathway WPIDs containing the query ORCID
#' @param query The \code{character} ORCID to search for.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIDsByOrcid(' 0000-0001-9773-4008')
#' }
#' @seealso findPathwaysByOrcid
#' @export 
findPathwayIDsByOrcid <- function(query=NULL) {
    res <- findPathwaysByOrcid(query)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By ORCID 
#'
#' @description Retrieve list of pathway names containing the query ORCID
#' @param query The \code{character} ORCID to search for.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayNamesByOrcid(' 0000-0001-9773-4008')
#' }
#' @seealso findPathwaysByOrcid
#' @export 
findPathwayNamesByOrcid <- function(query=NULL) {
    res <- findPathwaysByOrcid(query)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By ORCID 
#'
#' @description Retrieve list of pathway URLs containing the query ORCID
#' @param query The \code{character} ORCID to search for.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayUrlsByOrcid(' 0000-0001-9773-4008')
#' }
#' @seealso findPathwaysByOrcid
#' @export 
findPathwayUrlsByOrcid <- function(query=NULL) {
    res <- findPathwaysByOrcid(query)
    return(res$url)
}
