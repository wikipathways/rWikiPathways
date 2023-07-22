# ------------------------------------------------------------------------------
#' @title List Pathways
#'
#' @description Retrieve list of pathways per species, including WPID, name, 
#' species, URL and latest revision number.
#' @param organism (\code{character}, optional) A particular species. 
#' See \link{listOrganisms}. Default is all species.
#' @return A \code{dataframe} of pathway information
#' @examples {
#' listPathways('Mus musculus')
#' }
#' @export
#' @importFrom data.table rbindlist
listPathways <- function(organism="") {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/listPathways.json")
    res.df <- res$organisms %>% 
        purrr::map_dfr(~ .x$pathways) 
    if(organism != ""){
        res.df <- dplyr::filter(res.df, species == organism)
    }
    if(nrow(res.df) == 0){
        message("No results")
    }
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title List Pathway WPIDs
#'
#' @description Retrieve list of pathway WPIDs per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (\code{character}, optional) A particular species. 
#' See \link{listOrganisms}. 
#' Default is all species.
#' @return A \code{list} of WPIDs
#' @examples {
#' listPathwayIds('Mus musculus')
#' }
#' @seealso listPathways
#' @export 
listPathwayIds <- function(organism="") {
    res <- listPathways(organism)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title List Pathway Names
#'
#' @description Retrieve list of pathway names per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (\code{character}, optional) A particular species. 
#' See \link{listOrganisms}. 
#' Default is all species.
#' @return A \code{list} of names
#' @examples {
#' listPathwayNames('Mus musculus')
#' }
#' @seealso listPathways
#' @export 
listPathwayNames <- function(organism="") {
    res <- listPathways(organism)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title List Pathway URLs
#'
#' @description Retrieve list of pathway URLs per species. 
#' @details Basically returns a subset of \link{listPathways} result
#' @param organism (\code{character}, optional) A particular species. 
#' See \link{listOrganisms}. 
#' Default is all species.
#' @return A \code{list} of URLs
#' @examples {
#' listPathwayUrls('Mus musculus')
#' }
#' @seealso listPathways
#' @export 
listPathwayUrls <- function(organism="") {
    res <- listPathways(organism)
    return(res$url)
}


