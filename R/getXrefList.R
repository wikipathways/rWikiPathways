# ------------------------------------------------------------------------------
#' @title Get Xref List
#'
#' @description Retrieve the Xref identifiers for a specific pathway in a 
#' particular system code
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, 
#' e.g. WP4
#' @param systemCode (\code{character}) The BridgeDb code associated with the 
#' data source or system, 
#' e.g., En (Ensembl), L (NCBI gene), H (HGNC), U (UniProt), Wd (Wikidata), 
#' Ce (ChEBI), Ik (InChI). See column two of 
#' https://github.com/bridgedb/datasources/blob/main/datasources.tsv.
#' @param compact (\code{Boolean}) Whether to return compact identifiers, like
#' ncbigene:1215. If FALSE (default), then just the identifier is returned, like
#'  1215
#' @return A \code{list} of Xrefs identifiers
#' @examples {
#' xrefs = getXrefList("WP2338", "L")
#' }
#' @export
getXrefList <- function(pathway=NULL, systemCode=NULL, compact=FALSE) {
    if(is.null(pathway))
        stop("Must provide a pathway identifier, e.g., WP554")
    if(is.null(systemCode))
        stop("Must provide a systemCode, e.g., L")
    
    code.list <- c(
        "En"="Ensembl",
        "L"="NCBI gene",
        "H"= "HGNC",
        "U"="UniProt",
        "Wd"= "Wikidata", 
        "Ce"= "ChEBI", 
        "Ik"= "InChI"
    )
    
    if(!systemCode %in% names(code.list))
        stop("Must provide a supported systemCode, e.g., L (see docs)")
    
    res <- readr::read_tsv(paste0("https://www.wikipathways.org/wikipathways-assets/pathways/",
                           pathway,"/",
                           pathway,"-datanodes.tsv"),
                    show_col_types = FALSE)
    
    res.list <- res %>%
        dplyr::select(code.list[[systemCode]]) %>%
        tidyr::drop_na() %>%
        tidyr::separate_rows(code.list[[systemCode]], sep=";") %>%
        as.list() %>%
        unname() %>%
        unlist() %>%
        unique()
    
    if(!compact)
        res.list <- stringr::str_replace(res.list, ".*:", "")
    
    return(res.list)
}
