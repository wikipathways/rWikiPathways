# ------------------------------------------------------------------------------
#' @title List Communities
#'
#' @description Retrieve the list of communities hosted by WikiPathways
#' @return A \code{data.frame} of community information
#' @examples {
#' listCommunities()
#' }
#' 
#' @export
listCommunities <- function() {
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/listCommunities.json")
    res.df <- res$communities %>%
        purrr::map_df(~as_tibble(.)) %>%
        tidyr::unnest_wider(pathways, names_sep = "_") %>%
        dplyr::select(c(1:5)) %>%
        unique()
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Get Pathways By Community
#'
#' @description Retrieve pathways per community
#' @param community_tag Abbreviated name of community
#' @return A \code{data.frame} of pathway information
#' @examples {
#' getPathwaysByCommunity("AOP")
#' }
#' 
#' @export
getPathwaysByCommunity <- function(community_tag=NULL) {
    if(is.null(community_tag))
        stop("Must provide a community_tag, e.g., AOP")
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/listCommunities.json")
    res.df <- res$communities %>%
        purrr::map_df(~as_tibble(.)) %>%
        tidyr::unnest_wider(pathways, names_sep = "_") 
    
    if(!community_tag %in% res.df$`community-tag`)
        stop("Must provide a valid community_tag, e.g., AOP")
    
    res.df <- res.df %>%
        dplyr::filter(`community-tag` == community_tag) %>%
        dplyr::select(c(6:10)) %>%
        unique()
    
    names(res.df) <- sub("^pathways_", "", names(res.df))
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Get Pathway IDs By Community
#'
#' @description Retrieve the list of pathway IDs per community
#' @param community_tag Abbreviated name of community
#' @return A \code{list} of pathway IDs
#' @examples {
#' getPathwayIdsByCommunity("AOP")
#' }
#' 
#' @export
getPathwayIdsByCommunity <- function(community_tag=NULL) {
    res <- getPathwaysByCommunity(community_tag)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Get Pathway Names By Community
#'
#' @description Retrieve the list of pathway names per community
#' @param community_tag Abbreviated name of community
#' @return A \code{list} of pathway names
#' @examples {
#' getPathwayNamesByCommunity("AOP")
#' }
#' 
#' @export
getPathwayNamesByCommunity <- function(community_tag=NULL) {
    res <- getPathwaysByCommunity(community_tag)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Get Pathway URLs By Community
#'
#' @description Retrieve the list of pathway URLs per community
#' @param community_tag Abbreviated name of community
#' @return A \code{list} of pathway URLs
#' @examples {
#' getPathwayUrlsByCommunity("AOP")
#' }
#' 
#' @export
getPathwayUrlsByCommunity <- function(community_tag=NULL) {
    res <- getPathwaysByCommunity(community_tag)
    return(res$url)
}