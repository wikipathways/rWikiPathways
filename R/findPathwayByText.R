# ------------------------------------------------------------------------------
#' @title Find Pathways By Text
#'
#' @description Retrieve a list of pathways containing the query text.
#' @param query The string to search for, e.g., "cancer"
#' @return List of lists
#' @examples {
#' findPathwaysByText('cancer')
#' }
#' @export
findPathwaysByText <- function(query) {
    res <- wikipathwaysGET('findPathwaysByText', list(query=query))
    return(res$result)
    
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Text 
#'
#' @description Retrieve list of pathway WPIDs containing the query text.
#' @param query The string to search for, e.g., "cancer"
#' @return List of WPIDs
#' @examples {
#' findPathwayIdsByText('cancer')
#' }
#' @export 
findPathwayIdsByText <- function(query) {
    unlist(lapply(findPathwaysByText(query), function(x) {unname(x['id'])}))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Text 
#'
#' @description Retrieve list of pathway names containing the query text.
#' @details Note: there will be multiple listings of the same pathway name if 
#' copies exist for multiple species.
#' @param query The string to search for, e.g., "cancer"
#' @return List of lists
#' @examples {
#' findPathwayNamesByText('cancer')
#' }
#' @export 
findPathwayNamesByText <- function(query) {
    unlist(lapply(findPathwaysByText(query), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Text 
#'
#' @description Retrieve list of pathway URLs containing the query text.
#' @param query The string to search for, e.g., "cancer"
#' @return List of lists
#' @examples {
#' findPathwayUrlsByText('cancer')
#' }
#' @export 
findPathwayUrlsByText <- function(query) {
    unlist(lapply(findPathwaysByText(query), function(x) {unname(x['url'])}))
}
