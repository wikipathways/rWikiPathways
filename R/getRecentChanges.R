# ------------------------------------------------------------------------------
#' @title Get Recent Changes
#'
#' @description Retrieve recent changes to pathways at WikiPathways.
#' @param timestamp (14 digits, YYYYMMDDhhmmss) Limit by time, only history items 
#' after the given time, e.g., 20180201000000 for changes since Feb 1st, 2018.
#' @return List of changes, including pathway WPID, name, url, species and revision
#' @examples {
#' getRecentChanges('20180201000000')
#' }
#' @export
getRecentChanges <- function(timestamp) {
    res <- wikipathwaysGET('getRecentChanges',list(timestamp=timestamp))
    return(unname(res$pathways))
}

# ------------------------------------------------------------------------------
#' @title Get WPIDs of Recent Changes 
#'
#' @description Retrieve WPIDs of recently changed pathways at WikiPathways.
#' @param timestamp (14 digits, YYYYMMDDhhmmss) Limit by time, only history items 
#' after the given time, e.g., 20180201000000 for changes since Feb 1st, 2018.
#' @return List of WPIDs
#' @examples {
#' getRecentChangesIds('20180201000000')
#' }
#' @export 
getRecentChangesIds <- function(timestamp) {
    unlist(lapply(getRecentChanges(timestamp), function(x) {unname(x['id'])}))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway Names of Recent Changes 
#'
#' @description Retrieve names of recently changed pathways at WikiPathways.
#' @param timestamp (14 digits, YYYYMMDDhhmmss) Limit by time, only history items 
#' after the given time, e.g., 20180201000000 for changes since Feb 1st, 2018.
#' @return List of pathway names. Note: pathway deletions will be listed as blank names.
#' @examples {
#' getRecentChangesNames('20180201000000')
#' }
#' @export 
getRecentChangesNames <- function(timestamp) {
    unlist(lapply(getRecentChanges(timestamp), function(x) {unname(x['name'])}))
}

