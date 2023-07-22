# ------------------------------------------------------------------------------
#' @title Get Pathway Info
#'
#' @description Retrieve information for a specific pathway
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, 
#' e.g. WP554. If NULL, then all pathways are returned.
#' @return A \code{dataframe} of pathway WPID, URL, name, species, revision,
#' authors, description, and citedIn
#' @examples {
#' getPathwayInfo('WP554')
#' }
#' @export
getPathwayInfo <- function(pathway=NULL) {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/getPathwayInfo.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) 
    
    if(!is.null(pathway))
       res.df <- dplyr::filter(res.df, id == pathway)
    
    return(res.df)
}
