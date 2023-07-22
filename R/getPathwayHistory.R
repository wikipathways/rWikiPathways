# ------------------------------------------------------------------------------
#' @title Get Pathway History
#'
#' @description View the revision history of a pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway, e.g. WP554
#' @param timestamp <ignored>
#' @return Opens the GitHub history for a pathway
#' @examples {
#' getPathwayHistory('WP554')
#' }
#' @export
getPathwayHistory <- function(pathway=NULL,timestamp=NULL) {
    if(is.null(pathway))
        stop("Must provide a pathway identifier, e.g., WP554")
    
    browseURL(paste0("https://github.com/wikipathways/wikipathways-database/commits/main/pathways/",pathway))
}
