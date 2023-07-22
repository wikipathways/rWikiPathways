# ------------------------------------------------------------------------------
#' @title List Organisms
#'
#' @description Retrieve the list of organisms supported by WikiPathways
#' @return A \code{list} of organisms
#' @examples {
#' listOrganisms()
#' }
#' 
#' @export
listOrganisms <- function() {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/listOrganisms.json")
    res$organisms
}
