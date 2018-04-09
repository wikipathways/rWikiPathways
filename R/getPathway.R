# ------------------------------------------------------------------------------
#' @title Get Pathway
#'
#' @description Retrieve a specific pathway in the GPML format
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @param revision (\code{integer}, optional) Number to indicate a specific revision to download
#' @return GPML
#' @examples {
#' getPathway('WP554')
#' }
#' @export
getPathway <- function(pathway, revision=0) {
    res <- wikipathwaysGET('getPathway',list(pwId=pathway,
                                      revision=revision))
    return(unname(res$pathway['gpml']))
}
