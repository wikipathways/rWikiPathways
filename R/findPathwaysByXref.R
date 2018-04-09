# ------------------------------------------------------------------------------
#' @title Find Pathways By Xref
#'
#' @description Retrieve a list of pathways containing the query Xref by identifier
#'  and system code.
#' @details Note: there will be multiple listings of the same pathway if the Xref
#' is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.txt.
#' @return A \code{list} of lists
#' @examples {
#' findPathwaysByXref('ENSG00000232810','En')
#' }
#' @export
findPathwaysByXref <- function(identifier, systemCode) {
    res <- wikipathwaysGET('findPathwaysByXref', list(ids=identifier,codes=systemCode))
    return(res$result)

}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Xref 
#'
#' @description Retrieve list of pathway WPIDs containing the query Xref by identifier
#'  and system code.
#' @details Note: there will be multiple listings of the same pathway if the Xref
#' is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.txt.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByXref('ENSG00000232810','En')
#' }
#' @export 
findPathwayIdsByXref <- function(identifier, systemCode) {
    unlist(lapply(findPathwaysByXref(identifier, systemCode), function(x) {unname(x['id'])}))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Xref 
#'
#' @description Retrieve list of pathway names containing the query Xref by identifier
#'  and system code.
#' @details Note: there will be multiple listings of the same pathway if the Xref
#' is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.txt.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayNamesByXref('ENSG00000232810','En')
#' }
#' @export 
findPathwayNamesByXref <- function(identifier, systemCode) {
    unlist(lapply(findPathwaysByXref(identifier, systemCode), function(x) {unname(x['name'])}))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Xref 
#'
#' @description Retrieve list of pathway URLs containing the query Xref by identifier
#'  and system code.
#' @details Note: there will be multiple listings of the same pathway if the Xref
#' is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.txt.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayUrlsByXref('ENSG00000232810','En')
#' }
#' @export 
findPathwayUrlsByXref <- function(identifier, systemCode) {
    unlist(lapply(findPathwaysByXref(identifier, systemCode), function(x) {unname(x['url'])}))
}
