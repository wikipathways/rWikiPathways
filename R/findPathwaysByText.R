# ------------------------------------------------------------------------------
#' @title Find Pathways By Text
#'
#' @description Retrieve pathways matching the query text.
#' @param query A \code{character} string to search for, e.g., "cancer". Case 
#' insensitive.
#' @param field Optional \code{character} string to restrict search to a single
#' field, e.g., id, name, description, species, revision, authors,
#' datanodes, annotations, or citedIn.
#' @return A \code{dataframe} of pathway attributes including the matching
#' attributes
#' @details Searches id, name, description, species, revision date, authors,
#' datanode labels, ontology annotations, and citedIn (e.g., PMCIDs).
#' @examples {
#' findPathwaysByText('cancer')
#' findPathwaysByText('cancer','name')
#' }
#' @export
findPathwaysByText <- function(query=NULL, field=NULL) {
    if(is.null(query))
        stop("Must provide a query, e.g., ACE2")
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/findPathwaysByText.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) 
    
    if(!is.null(field) && !field %in% names(res.df))
        stop("Must provide a supported field, e.g., name")
    
    if(is.null(field)){
        res.df <- res.df %>%
            rowwise() %>%
            filter(any(grepl(tolower(query),tolower(c_across(id:citedIn)))))
    } else {
        res.df <- res.df %>%
            dplyr::filter(grepl(tolower(query),tolower(res.df[[field]])))
    }
    
    if(nrow(res.df) == 0)
        message("No results")
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Text 
#'
#' @description Retrieve list of pathway WPIDs containing the query text.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @param field Optional \code{character} string to restrict search to a single
#' field, e.g., title, description, wpid, species, revision, authors,
#' datanodes, annotations, or citedIn.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayIdsByText <- function(query=NULL, field=NULL) {
    res <- findPathwaysByText(query, field)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Text 
#'
#' @description Retrieve list of pathway names containing the query text.
#' @details Note: there will be multiple listings of the same pathway name if 
#' copies exist for multiple species.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @param field Optional \code{character} string to restrict search to a single
#' field, e.g., title, description, wpid, species, revision, authors,
#' datanodes, annotations, or citedIn.
#' @return A \code{list} of pathway names
#' @examples {
#' findPathwayNamesByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayNamesByText <- function(query=NULL, field=NULL) {
    res <- findPathwaysByText(query,field)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Text 
#'
#' @description Retrieve list of pathway URLs containing the query text.
#' @param query A \code{character} string to search for, e.g., "cancer"
#' @param field Optional \code{character} string to restrict search to a single
#' field, e.g., title, description, wpid, species, revision, authors,
#' datanodes, annotations, or citedIn.
#' @return A \code{list} of urls
#' @examples {
#' findPathwayUrlsByText('cancer')
#' }
#' @seealso findPathwaysByText
#' @export 
findPathwayUrlsByText <- function(query=NULL, field=NULL) {
    res <- findPathwaysByText(query,field)
    return(res$url)
}
