# ------------------------------------------------------------------------------
#' @title Get Pathway History
#'
#' @description Retrieve the revision history of a pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @param timestamp Limit by time, only history items after the given time, 
#' e.g., 20180201 for revisions since Feb 1st, 2018. Any length of timestamp is 
#' accepted, upto 14 digits, e.g., 2018, 201802, 20180201063011, etc.
#' @return List of revisions, including user and comment
#' @examples {
#' getPathwayHistory('WP554')
#' }
#' @export
getPathwayHistory <- function(pathway,timestamp) {
    res <- wikipathwaysGET('getPathwayHistory',list(pwId=pathway,timestamp=timestamp))
    return(unname(res$history[[1]]))
}
