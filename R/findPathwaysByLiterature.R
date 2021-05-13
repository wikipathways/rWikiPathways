# ------------------------------------------------------------------------------
#' @title Find Pathways By Literature
#'
#' @description Retrieve pathways containing the query citation.
#' @param query The \code{character} string to search for, e.g., a PMID, title 
#' keyword or author name.
#' @return A \code{dataframe} of pathway attributes in addition to query result 
#' score and literature details
#' @details The score is from a lucene index search engine, ranging from 0 to 
#' 1 with higher scores for better matches. The two literature columns are
#' lists of pubmed ids and titles for the citations matching the query per
#' pathway. The graphId column lists the id for any objects in the
#' GPML pathway model that have been spcifically annotated with the matching 
#' citations.
#' @examples {
#' findPathwaysByLiterature('19649250')
#' findPathwaysByLiterature('smith')
#' findPathwaysByLiterature('cancer')
#' }
#' @export
#' @importFrom tidyr unnest
#' @importFrom data.table dcast
#' @importFrom data.table setDT
findPathwaysByLiterature <- function(query) {
    res <- wikipathwaysGET('findPathwaysByLiterature', list(query=query))
    if(length(res$result) == 0){
        message("No results")
        return(data.frame())
    }
    res.df <- suppressWarnings(data.table::rbindlist(res$result, fill = TRUE))
    res.df$revision <- vapply(res.df$revision, as.integer, integer(1))
    res.df$score <- vapply(res.df$score, function(s){
        as.numeric(unlist(s))
    }, numeric(1))
    ## reshape literature field
    res.df.tall <- unnest(res.df, cols = c("fields")) 
    res.df.odd <- as.data.frame(res.df.tall)[c(TRUE,FALSE), ]
    res.df.odd$fields <- vapply(res.df.odd$fields, unlist, character(1))
    res.df.even <- as.data.frame(res.df.tall)[c(FALSE,TRUE), ]
    res.df.even$fields <- sapply(res.df.even$fields, unlist) #can't use vapply: variable returns
    row.names(res.df.odd) <- NULL
    row.names(res.df.even) <- NULL
    res.df.fields <- merge(res.df.even, res.df.odd[,2, drop = FALSE], by=0)
    res.df.cast <- dcast(setDT(res.df.fields), score+id+name+url+species+revision~fields.y, value.var="fields.x")
    return(res.df.cast)
    
}

# ------------------------------------------------------------------------------
#' @title Find Pathway WPIDs By Literature 
#'
#' @description Retrieve list of pathway WPIDs containing the query citation.
#' @param query The \code{character} string to search for, e.g., a PMID, title 
#' keyword or author name.
#' @return A \code{list} of WPIDs
#' @examples {
#' findPathwayIdsByLiterature('19649250')
#' findPathwayIdsByLiterature('smith')
#' findPathwayIdsByLiterature('cancer')
#' }
#' @seealso findPathwaysByLiterature
#' @export 
findPathwayIdsByLiterature <- function(query) {
    res <- findPathwaysByLiterature(query)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Literature 
#'
#' @description Retrieve list of pathway names containing the query citation.
#' @details Note: there will be multiple listings of the same pathway name if 
#' copies exist for multiple species.
#' @param query The \code{character} string to search for, e.g., a PMID, title 
#' keyword or author name.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayNamesByLiterature('19649250')
#' findPathwayNamesByLiterature('smith')
#' findPathwayNamesByLiterature('cancer')
#' }
#' @seealso findPathwaysByLiterature
#' @export 
findPathwayNamesByLiterature <- function(query) {
    res <- findPathwaysByLiterature(query)
    return(res$name)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway URLs By Literature 
#'
#' @description Retrieve list of pathway URLs containing the query citation.
#' @param query The \code{character} string to search for, e.g., a PMID, title 
#' keyword or author name.
#' @return A \code{list} of lists
#' @examples {
#' findPathwayUrlsByLiterature('19649250')
#' findPathwayUrlsByLiterature('smith')
#' findPathwayUrlsByLiterature('cancer')
#' }
#' @seealso findPathwaysByLiterature
#' @export 
findPathwayUrlsByLiterature <- function(query) {
    res <- findPathwaysByLiterature(query)
    return(res$url)
}
