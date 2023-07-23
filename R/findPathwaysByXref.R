# ------------------------------------------------------------------------------
#' @title Find Pathways By Xref
#'
#' @description Retrieve pathways containing the query Xref by identifier
#'  and system code.
#' @param identifier (\code{character}) The official ID specified by a data 
#' source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the 
#' data source or system, 
#' e.g., En (Ensembl), L (NCBI gene), H (HGNC), U (UniProt), Wd (Wikidata), 
#' Ce (ChEBI), Ik (InChI). See column two of 
#' https://github.com/bridgedb/datasources/blob/main/datasources.tsv.
#' @return A \code{dataframe} of pathway attributes including the matching
#' identifiers
#' @examples {
#' findPathwaysByXref('ENSG00000100031','En')
#' }
#' @export
findPathwaysByXref <- function(identifier=NULL, systemCode=NULL) {
    if(is.null(identifier))
        stop("Must provide an identifier to query, e.g., ENSG00000100031")
    if(is.null(systemCode))
        stop("Must provide a systemCode, e.g., En")
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/findPathwaysByXref.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) 
    
    code.list <- c(
        "En"="ensembl",
        "L"="ncbigene",
        "H"= "hgnc",
        "U"="uniprot",
        "Wd"= "wikidata", 
        "Ce"= "chebi", 
        "Ik"= "inchikey"
    )

    if(systemCode %in% names(code.list)){
        res.df <- res.df %>%
            dplyr::filter(grepl(tolower(identifier),tolower(res.df[[code.list[[systemCode]]]])))
    } else {
        stop("Must provide a supported systemCode, e.g., En")
    }
    
    if(nrow(res.df) == 0)
        message("No results")
    
    return(as.data.frame(res.df))
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Xref 
#'
#' @description Retrieve list of pathway WPIDs containing the query Xref by 
#' identifier and system code.
#' @details Note: there will be multiple listings of the same pathway if the 
#' Xref is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data 
#' source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the 
#' data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc. See column two of 
#' https://github.com/bridgedb/datasources/blob/main/datasources.tsv.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByXref('ENSG00000100031','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayIdsByXref <- function(identifier=NULL, systemCode=NULL) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Xref 
#'
#' @description Retrieve list of pathway names containing the query Xref by 
#' identifier and system code.
#' @details Note: there will be multiple listings of the same pathway if the 
#' Xref is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data 
#' source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the 
#' data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc. See column two of 
#' https://github.com/bridgedb/datasources/blob/main/datasources.tsv.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayNamesByXref('ENSG00000100031','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayNamesByXref <- function(identifier=NULL, systemCode=NULL) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Xref 
#'
#' @description Retrieve list of pathway URLs containing the query Xref by 
#' identifier and system code.
#' @details Note: there will be multiple listings of the same pathway if the 
#' Xref is present mutiple times.
#' @param identifier (\code{character}) The official ID specified by a data 
#' source or system
#' @param systemCode (\code{character}) The BridgeDb code associated with the 
#' data source or system, 
#' e.g., En (Ensembl), L (Entrez), Ch (HMDB), etc. See column two of 
#' https://github.com/bridgedb/datasources/blob/main/datasources.tsv.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayUrlsByXref('ENSG00000100031','En')
#' }
#' @seealso findPathwaysByXref
#' @export 
findPathwayUrlsByXref <- function(identifier=NULL, systemCode=NULL) {
    res <- findPathwaysByXref(identifier, systemCode)
    return(res$url)
}
