# ------------------------------------------------------------------------------
#' @title Get Pathway Info
#'
#' @description Retrieve information for a specific pathway
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of pathway WPID, URL, name, species and latest revision
#' @examples {
#' getPathwayInfo('WP554')
#' }
#' @export
getPathwayInfo <- function(pathway) {
    res <- wikipathwaysGET('getPathwayInfo',list(pwId=pathway))
    return(unname(res$pathwayInfo))
}
