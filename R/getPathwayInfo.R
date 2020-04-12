# ------------------------------------------------------------------------------
#' @title Get Pathway Info
#'
#' @description Retrieve information for a specific pathway
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return A \code{dataframe} of pathway WPID, URL, name, species and latest revision
#' @examples {
#' getPathwayInfo('WP554')
#' }
#' @export
getPathwayInfo <- function(pathway) {
    res <- wikipathwaysGET('getPathwayInfo',list(pwId=pathway))
    if(res$pathwayInfo['name'] == ""){
        message("No results")
        return(data.frame())
    }
    res.pathwayInfo <- vapply(res$pathwayInfo, as.list, list(1))
    res.df <- as.data.frame(res.pathwayInfo, stringsAsFactors = FALSE)
    return(res.df)
}
