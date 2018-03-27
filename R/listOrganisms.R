# ------------------------------------------------------------------------------
#' @title List Organisms
#'
#' @description Retrieve the list of organisms supported by WikiPathways
#' @return list of organisms
#' @examples {
#' listOrganisms()
#' }
#' @export
listOrganisms <- function() {
    res <- wikipathwaysGET('listOrganisms')
    res$organisms
}
