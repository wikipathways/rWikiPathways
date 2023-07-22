# ------------------------------------------------------------------------------
#' @title Get Counts for WikiPathways Stats
#'
#' @description Retrieve information about various total counts at WikiPathways.
#' @return A \code{data.frame} of counts
#' @examples {
#' getCounts()
#' }
#' @export
getCounts <- function() {
    
    res<-rjson::fromJSON(
        file="https://www.wikipathways.org/json/getCounts.json")
    
    return(as.data.frame(res))
}