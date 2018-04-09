# ------------------------------------------------------------------------------
#' @title Download Pathway Archive
#'
#' @description Access the monthly archives of pathway content from WikiPathways.
#' @details If you specify an archive date, organism and format, then the archive file
#' will be downloaded. Otherwise, the archive will be opened in a tab in your
#' default browser.
#' @param date (optional) The timestamp for a monthly release (e.g., 20171010) 
#' or "current" (default) for latest release.
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' @param format (optional) Either gpml (default), gmt or svg.
#' @return Downloaded file or tab in default browser
#' @examples \donttest{
#' downloadPathwayArchive()
#' downloadPathwayArchive(format="gmt")
#' downloadPathwayArchive(date="20171010", format="svg")
#' downloadPathwayArchive(date="20171010", organism="Mus musculus", format="svg")
#' }
#' @export
#' @importFrom utils browseURL download.file
downloadPathwayArchive <- function(date='current',organism = NULL, format=c('gpml', 'gmt', 'svg')){
    #get validated format
    format <- match.arg(format)
    
    #validate date
    if (date != 'current')
        if (!grepl("^\\d{8}$",date))
            stop('The date must be 8 digits (YYYYMMDD) or "current"')
    
    #validate organism
    orgs <- listOrganisms()
    if(!is.null(organism))
        if(!organism %in% orgs)
            stop('The organism must match the list of supported organisms, see listOrganisms()')
    
    #download specific file, or...
    if (!is.null(organism) && date != 'current'){
        ext <- ".zip"
        if (format == 'gmt')
            ext <- ".gmt"
        filename <- paste0(paste('wikipathways',date,format,sub("\\s","_",organism),sep="-"), ext)
        url <- paste('http://data.wikipathways.org',date, format, filename, sep="/")
        download.file(url, filename, 'wget')
        
    } else { #...just open browser
        browseURL(paste('http://data.wikipathways.org',date, format ,sep="/"))
    }    
}