# ------------------------------------------------------------------------------
#' @title Find Pathways By Literature
#'
#' @description Retrieve a list of pathways containing the query citation.
#' @param query The string to search for, e.g., a PMID, title keyword or author name.
#' @return List of lists
#' @examples \donttest{
#' findPathwaysByLiterature('19649250')
#' findPathwaysByLiterature('smith')
#' findPathwaysByLiterature('cancer')
#' }
#' @export
findPathwaysByLiterature <- function(query) {
    res <- wikipathwaysGET('findPathwaysByLiterature', list(query=query))
    return(res$result)
    
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Literature 
#'
#' @description Retrieve list of pathway WPIDs containing the query citation.
#' @param query The string to search for, e.g., a PMID, title keyword or author name.
#' @return List of WPIDs
#' @examples \donttest{
#' findPathwayIdsByLiterature('19649250')
#' findPathwayIdsByLiterature('smith')
#' findPathwayIdsByLiterature('cancer')
#' }
#' @export 
findPathwayIdsByLiterature <- function(query) {
    unname(unlist(lapply(findPathwaysByLiterature(query), function(x) {unname(x['id'])})))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Literature 
#'
#' @description Retrieve list of pathway names containing the query citation.
#' @details Note: there will be multiple listings of the same pathway name if 
#' copies exist for multiple species.
#' @param query The string to search for, e.g., a PMID, title keyword or author name.
#' @return List of lists
#' @examples \donttest{
#' findPathwayNamesByLiterature('19649250')
#' findPathwayNamesByLiterature('smith')
#' findPathwayNamesByLiterature('cancer')
#' }
#' @export 
findPathwayNamesByLiterature <- function(query) {
    unname(unlist(lapply(findPathwaysByLiterature(query), function(x) {unname(x['name'])})))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Literature 
#'
#' @description Retrieve list of pathway URLs containing the query citation.
#' @param query The string to search for, e.g., a PMID, title keyword or author name.
#' @return List of lists
#' @examples \donttest{
#' findPathwayUrlsByLiterature('19649250')
#' findPathwayUrlsByLiterature('smith')
#' findPathwayUrlsByLiterature('cancer')
#' }
#' @export 
findPathwayUrlsByLiterature <- function(query) {
    unname(unlist(lapply(findPathwaysByLiterature(query), function(x) {unname(x['url'])})))
}
