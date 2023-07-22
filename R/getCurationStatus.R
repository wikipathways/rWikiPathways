# ------------------------------------------------------------------------------
#' @title Get Curation Status of a Pathway
#'
#' @description Retrieve information about curation status for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway, e.g. WP554
#' @return A \code{data.frame} of status details
#' @examples {
#' getCurationStatus('WP554')
#' }
#' @export
getCurationStatus <- function(pathway) {
    if(is.null(pathway))
        stop("Must provide a pathway identifier, e.g., WP554")
    
    res<-rjson::fromJSON(
        file=paste0("https://www.wikipathways.org/wikipathways-collection/reports/",pathway,".json"))
    
    return(as.data.frame(res))
}

# ------------------------------------------------------------------------------
#' @title DEPRECATED: Get Curation Tags on a Pathway
#'
#' @description This function is provided for compatibility with older 
#' web services only and will be defunct at the next release.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return A \code{list} of tag name, display name, revision, text, timestampe and user
#' @examples {
#' getCurationTags('WP554')
#' }
#' @export
getCurationTags <- function(pathway) {
    .Deprecated("getCurationStatus")
    
    res <- wikipathwaysGET('getCurationTags',list(pwId=pathway))
    return(unname(res$tags))
}

# ------------------------------------------------------------------------------
#' @title DEPRECATED: Get Curation Tag Names on a Pathway
#'
#' @description This function is provided for compatibility with older 
#' web services only and will be defunct at the next release.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return A \code{list} of tag names
#' @examples {
#' getCurationTagNames('WP554')
#' }
#' @export
getCurationTagNames <- function(pathway) {
    .Deprecated("getCurationStatus")
    
    unlist(lapply(getCurationTags(pathway), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title DEPRECATED: Get Every Instance of a Curation Tag
#'
#' @description This function is provided for compatibility with older 
#' web services only and will be defunct at the next release.
#' @param tag (\code{character}) Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return A \code{list} of tag name, display name, revision, text, timestampe and user
#' @examples {
#' getEveryCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getEveryCurationTag <- function(tag) {
    .Deprecated("listCommunities")
    
    res <- wikipathwaysGET('getCurationTagsByName',list(tagName=tag))
    return(unname(res$tags))
}

# ------------------------------------------------------------------------------
#' @title DEPRECATED: Get Pathways by Curation Tag 
#'
#' @description This function is provided for compatibility with older 
#' web services only and will be defunct at the next release.
#' @param tag (\code{character}) Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return A \code{list} of pathway information, including WPID, url, name, species and revision
#' @examples {
#' getPathwaysByCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getPathwaysByCurationTag <- function(tag) {
    .Deprecated("getPathwaysByCommunity")
    
    pathway.list <- lapply(getEveryCurationTag(tag), function(x) {unname(x['pathway'])})
    lapply(pathway.list, unlist)
}

# ------------------------------------------------------------------------------
#' @title DEPRECATED: Get Pathway WPIDs by Curation Tag 
#'
#' @description This function is provided for compatibility with older 
#' web services only and will be defunct at the next release.
#' @param tag (\code{character}) Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return A \code{list} of pathway WPIDs
#' @examples {
#' getPathwayIdsByCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getPathwayIdsByCurationTag <- function(tag) {
    .Deprecated("getPathwayIdsByCommunity")
    
    p.info.list <- lapply(getEveryCurationTag(tag), function(x) {unname(x['pathway'])})
    p.info <- lapply(p.info.list, unlist)
    unlist(lapply(p.info,function(x) {unname(x['id'])}))
}

