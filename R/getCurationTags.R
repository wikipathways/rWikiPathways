# ------------------------------------------------------------------------------
#' @title Get Curation Tags on a Pathway
#'
#' @description Retrieve information about curation tags for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of tag name, display name, revision, text, timestampe and user
#' @examples {
#' getCurationTags('WP554')
#' }
#' @export
getCurationTags <- function(pathway) {
    res <- wikipathwaysGET('getCurationTags',list(pwId=pathway))
    return(unname(res$tags))
}

# ------------------------------------------------------------------------------
#' @title Get Curation Tag Names on a Pathway
#'
#' @description Retrieve names of curation tags for a specific pathway.
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @return List of tag names
#' @examples {
#' getCurationTagNames('WP554')
#' }
#' @export
getCurationTagNames <- function(pathway) {
    unlist(lapply(getCurationTags(pathway), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title Get Every Instance of a Curation Tag
#'
#' @description Retrieve information about every instance of a given curation tag.
#' @param tag Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return List of tag name, display name, revision, text, timestampe and user
#' @examples {
#' getEveryCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getEveryCurationTag <- function(tag) {
    res <- wikipathwaysGET('getCurationTagsByName',list(tagName=tag))
    return(unname(res$tags))
}

# ------------------------------------------------------------------------------
#' @title Get Pathways by Curation Tag 
#'
#' @description Retrieve pathway information for every pathway with a given curation tag.
#' @param tag Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return List of pathway information, including WPID, url, name, species and revision
#' @examples {
#' getPathwaysByCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getPathwaysByCurationTag <- function(tag) {
    pathway.list <- lapply(getEveryCurationTag(tag), function(x) {unname(x['pathway'])})
    lapply(pathway.list, unlist)
}

# ------------------------------------------------------------------------------
#' @title Get Pathway WPIDs by Curation Tag 
#'
#' @description Retrieve pathway WPIDs for every pathway with a given curation tag.
#' @param tag Official name of curation tag, e.g., "Curation:FeaturedPathway"
#' @return List of pathway WPIDs
#' @examples {
#' getPathwayIdsByCurationTag('Curation:FeaturedPathway')
#' }
#' @export
getPathwayIdsByCurationTag <- function(tag) {
    p.info.list <- lapply(getEveryCurationTag(tag), function(x) {unname(x['pathway'])})
    p.info <- lapply(p.info.list, unlist)
    unlist(lapply(p.info,function(x) {unname(x['id'])}))
}

