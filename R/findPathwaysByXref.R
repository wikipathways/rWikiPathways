# ------------------------------------------------------------------------------
#' @title Find Pathways By Xref
#'
#' @description Retrieve pathways containing the query Xref by identifier
#'  and system code.
#' @details Note: there will be multiple listings of the same pathway if the Xref
#' is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc.
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.tsv.
#' @return A \code{dataframe} of pathway attributes in addition to query result score
#' @details The score is from a lucene index search engine, ranging from 0 to 
#' 1 with higher scores for better matches. 
#' @examples {
#' findPathwaysByXref('ENSG00000232810','En')
#' }
#' @export
findPathwaysByXref <- function(identifier, systemCode) {
    res <- wikipathwaysGET('findPathwaysByXref', list(ids=identifier,codes=systemCode))
    if(length(res$result) == 0){
        message("No results")
        return(data.frame())
    }
    res.df <- suppressWarnings(data.table::rbindlist(res$result, fill = TRUE))
    res.df$fields <- NULL
    res.df$revision <- vapply(res.df$revision, as.integer, integer(1))    
    res.df$score <- vapply(res.df$score, function(s){
        as.numeric(unlist(s))
    }, numeric(1))
    return(unique(res.df))

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
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.tsv.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByXref('ENSG00000232810','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayIdsByXref <- function(identifier, systemCode) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$id)
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
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.tsv.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayNamesByXref('ENSG00000232810','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayNamesByXref <- function(identifier, systemCode) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$name)
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
#' See column two of https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/datasources.tsv.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayUrlsByXref('ENSG00000232810','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayUrlsByXref <- function(identifier, systemCode) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$url)
}
