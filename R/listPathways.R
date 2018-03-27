# ------------------------------------------------------------------------------
#' @title List Pathways
#'
#' @description Retrieve list of pathways per species, including WPID, name, species,
#' URL and latest revision number.
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' Default is all species.
#' @return list of lists
#' @examples {
#' listPathways('Mus musculus')
#' }
#' @export
listPathways <- function(organism="") {
    res <- wikipathwaysGET('listPathways', list(organism=organism))
    res$pathways
}

# ------------------------------------------------------------------------------
#' @title List Pathway WPIDs
#'
#' @description Retrieve list of pathway WPIDs per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' Default is all species.
#' @return list of WPIDs
#' @examples {
#' listPathwayIds('Mus musculus')
#' }
#' @export 
listPathwayIds <- function(organism="") {
    unlist(lapply(listPathways(organism), function(x) {unname(x['id'])}))
}

# ------------------------------------------------------------------------------
#' @title List Pathway Names
#'
#' @description Retrieve list of pathway names per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' Default is all species.
#' @return list of names
#' @examples {
#' listPathwayNames('Mus musculus')
#' }
#' @export 
listPathwayNames <- function(organism="") {
    unlist(lapply(listPathways(organism), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title List Pathway URLs
#'
#' @description Retrieve list of pathway URLs per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' Default is all species.
#' @return list of URLs
#' @examples {
#' listPathwayUrls('Mus musculus')
#' }
#' @export 
listPathwayUrls <- function(organism="") {
    unlist(lapply(listPathways(organism), function(x) {unname(x['url'])}))
}


