# ------------------------------------------------------------------------------
#' @title Download Pathway Archive
#'
#' @description Access the monthly archives of pathway content from WikiPathways.
#' @param date The timestamp for a monthly release or "current" (default) for 
#' latest release.
#' @param format Either gpml (default), gmt, index, rdf or svg.
#' @return Open tab in default browser
#' @examples \donttest{
#' downloadPathwayArchive()
#' downloadPathwayArchive(format="gmt")
#' downloadPathwayArchive("20171010","svg")
#' }
#' @export
#' @importFrom utils browseURL
downloadPathwayArchive <- function(date='current',format='gpml'){
    browseURL(paste('http://data.wikipathways.org',date, format ,sep="/"))
}