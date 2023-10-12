# ------------------------------------------------------------------------------
#' @title Get Recent Changes
#'
#' @description Retrieve recently changed pathways at WikiPathways.
#' @param timestamp (8 digits, YYYYMMDD) Limit by time, only pathways changed 
#' after the given date, e.g., 20180201 for changes since Feb 1st, 2018.
#' @return A \code{data.frame} of recently changed pathways, including id, name,
#' url, species and revision
#' @examples {
#' getRecentChanges('20180201')
#' }
#' @export
getRecentChanges <- function(timestamp=NULL) {
    if(is.null(timestamp))
        timestamp <- 20070301
    timestamp <- substr(timestamp, start = 1, stop = 8)
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/getPathwayInfo.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) %>%
        dplyr::mutate(revision_ymd = lubridate::ymd(revision)) %>%
        dplyr::filter(revision_ymd > lubridate::ymd(timestamp)) %>%
        dplyr::select(-c(revision_ymd,authors,description,citedIn))
    
    return(res.df)
}

# ------------------------------------------------------------------------------
#' @title Get WPIDs of Recent Changes 
#'
#' @description Retrieve WPIDs of recently changed pathways at WikiPathways.
#' @param timestamp (8 digits, YYYYMMDD) Limit by time, only pathways changed 
#' after the given date, e.g., 20180201 for changes since Feb 1st, 2018.
#' @return A \code{list} of WPIDs
#' @examples {
#' getRecentChangesIds('20180201')
#' }
#' @export 
getRecentChangesIds <- function(timestamp) {
    getRecentChanges(timestamp)[['id']]
}

# ------------------------------------------------------------------------------
#' @title Get Pathway Names of Recent Changes 
#'
#' @description Retrieve names of recently changed pathways at WikiPathways.
#' @param timestamp (8 digits, YYYYMMDD) Limit by time, only pathways changed 
#' after the given date, e.g., 20180201 for changes since Feb 1st, 2018.
#' @return A \code{list} of pathway names. Note: pathway deletions will be listed as blank names.
#' @examples {
#' getRecentChangesNames('20180201')
#' }
#' @export 
getRecentChangesNames <- function(timestamp) {
    getRecentChanges(timestamp)[['name']]
}

