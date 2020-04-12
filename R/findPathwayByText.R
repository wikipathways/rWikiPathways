# ------------------------------------------------------------------------------
#' @title Find Pathways By Text
#'
#' @description Retrieve pathways containing the query text.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @return A \code{dataframe} of pathway attributes in addition to query result score
#' @details The score is from a lucene index search engine, ranging from 0 to 
#' 1 with higher scores for better matches. 
#' @examples {
#' findPathwaysByText('cancer')
#' }
#' @export
findPathwaysByText <- function(query) {
    res <- wikipathwaysGET('findPathwaysByText', list(query=query))
    if(length(res$result) == 0){
        message("No results")
        return(data.frame())
    }
    res.df <- suppressWarnings(data.table::rbindlist(res$result, fill = TRUE))
    res.df$fields <- NULL
    res.df$revision <- sapply(res.df$revision, as.integer)
    res.df$score <- sapply(res.df$score, function(s){
        as.numeric(unlist(s))
    })
    return(res.df)
    
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Text 
#'
#' @description Retrieve list of pathway WPIDs containing the query text.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayIdsByText <- function(query) {
    res <- findPathwaysByText(query)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Text 
#'
#' @description Retrieve list of pathway names containing the query text.
#' @details Note: there will be multiple listings of the same pathway name if 
#' copies exist for multiple species.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @return A \code{list} of pathway names
#' @examples {
#' findPathwayNamesByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayNamesByText <- function(query) {
    res <- findPathwaysByText(query)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Text 
#'
#' @description Retrieve list of pathway URLs containing the query text.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @return A \code{list} of urls
#' @examples {
#' findPathwayUrlsByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayUrlsByText <- function(query) {
    res <- findPathwaysByText(query)
    return(res$url)
}
