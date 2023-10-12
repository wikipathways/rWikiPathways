# ------------------------------------------------------------------------------
#' @title Download Pathway Archive
#'
#' @description Access the monthly archives of pathway content from WikiPathways.
#' @details If you do not specify an organism, then an archive file
#' will not be downloaded. Rather, the archive will be opened in a tab in your
#' default browser.
#' @param date (optional) The timestamp for a monthly release (e.g., 20171010) 
#' or "current" (default) for latest release.
#' @param organism (optional) A particular species. See \link{listOrganisms}. 
#' @param format (optional) Either gpml (default), gmt or svg.
#' @param destpath (optional) Destination path for file to be downloaded to.
#' Default is current workding directory.
#' @return Filename of downloaded file or an opened tab in default browser
#' @examples \donttest{
#' #downloadPathwayArchive()  ## open in browser
#' #downloadPathwayArchive(format="gmt")  ## open in browser
#' #downloadPathwayArchive(date="20230710", format="svg")  ## open in browser
#' #downloadPathwayArchive(date="20230710", organism="Mus musculus", format="svg")  ## download file
#' #downloadPathwayArchive(organism="Mus musculus")  ## download file
#' }
#' @seealso readPathwayGMT
#' @export
#' @importFrom utils browseURL download.file
#' @importFrom XML readHTMLTable
#' @importFrom RCurl getURL
downloadPathwayArchive <- function(date='current',organism=NULL, format=c('gpml', 'gmt', 'svg'), destpath='./'){
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
    if (!is.null(organism)){
        if (date == 'current'){ #determine filename
            data.url <- getURL(paste0('https://data.wikipathways.org/current/',format), 
                               followlocation=TRUE, .opts=list(useragent="Mozila 5.0"))
            curr.files <- readHTMLTable(data.url)[[1]]$Filename
            filename <- grep(sub("\\s","_",organism), curr.files, value=TRUE)
            if (length(filename) == 0)
                stop ('Could not find a file matching your specifications. Try browsing https://data.wikipathways.org.')
        } else { #construct filename
            ext <- ".zip"
            if (format == 'gmt')
                ext <- ".gmt"
            filename <- paste0(paste('wikipathways',date,format,sub("\\s","_",organism),sep="-"), ext)
        }
        url <- paste('https://data.wikipathways.org',date, format, filename, sep="/")
        download.file(url, paste(destpath,filename,sep='/'), 'auto')
        return(filename)
    } else { #...just open browser
        url <- paste('https://data.wikipathways.org', date, format, sep="/")
        if (interactive())
            browseURL(url)
    }
}
