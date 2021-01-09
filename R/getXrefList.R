# ------------------------------------------------------------------------------
#' @title Get Xref List
#'
#' @description Retrieve the Xref identifiers for a specific pathway in a particular system code
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/src/main/resources/org/bridgedb/bio/datasources.tsv.
#' @return A \code{list} of Xrefs identifiers
#' @examples {
#' xrefs = getXrefList("WP2338", "L")
#' }
#' @export
getXrefList <- function(pathway, systemCode) {
    res <- wikipathwaysGET('getXrefList',list(pwId=pathway,
                                              code=systemCode))
    return(unname(res$xrefs))
}
