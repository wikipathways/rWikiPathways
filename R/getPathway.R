# ------------------------------------------------------------------------------
#' @title Get Pathway
#'
#' @description Retrieve a specific pathway in the GPML format
#' @param pathway WikiPathways identifier (WPID) for the pathway to retrieve, 
#' e.g. WP554
#' @param revision <ignored> Only the latest version is available.
#' @return GPML as string
#' @examples {
#' getPathway('WP554')
#' }
#' @export
getPathway <- function(pathway, revision=0) {
    if(is.null(pathway))
        stop("Must provide a pathway identifier, e.g., WP554")
    
    res <- httr::GET(paste0("https://www.wikipathways.org/wikipathways-assets/pathways/",
                            pathway,"/",
                            pathway,".gpml"))
    xml_text <- httr::content(res, as="text", encoding = "UTF-8")
    xml_obj <- XML::xmlParse(xml_text)
    xml_string <- XML::saveXML(xml_obj)
    xml_string <- sub("\n*$", "", xml_string)
    return(xml_string)
}
