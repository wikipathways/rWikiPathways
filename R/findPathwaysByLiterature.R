# ------------------------------------------------------------------------------
#' @title Find Pathways By Literature
#'
#' @description Retrieve pathways containing the query citation.
#' @param query The \code{character} string to search for, e.g., a PMID, title 
#' keyword, journal abbreviation, year, or author name.
#' @return A \code{dataframe} of pathway attributes including the matching
#' citations
#' @examples {
#' findPathwaysByLiterature('15134803')
#' findPathwaysByLiterature('Schwartz GL')
#' findPathwaysByLiterature('Eur J Pharmacol')
#' findPathwaysByLiterature('antihypertensive drug responses')
#' }
#' @export
#' @importFrom purrr map_dfr
findPathwaysByLiterature <- function(query=NULL) {
    if(is.null(query))
        stop("Must provide a query, e.g., 15134803 or Schwartz GL")
    
    res <- rjson::fromJSON(file="https://www.wikipathways.org/json/findPathwaysByLiterature.json")
    res.df <- res$pathwayInfo %>%
        purrr::map_dfr(~as.data.frame(t(unlist(.x)))) 

    res.df <- res.df %>%
        rowwise() %>%
        dplyr::filter(any(grepl(tolower(query),tolower(c_across(refs:citations)))))

    if(nrow(res.df) == 0)
        message("No results")
    
    return(as.data.frame(res.df))
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
findPathwayIdsByLiterature <- function(query=NULL) {
    res <- findPathwaysByLiterature(query)
    return(res$id)
}

# ------------------------------------------------------------------------------
#' @title Find Pathway Names By Literature 
#'
#' @description Retrieve list of pathway names containing the query citation.
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
findPathwayNamesByLiterature <- function(query=NULL) {
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
findPathwayUrlsByLiterature <- function(query=NULL) {
    res <- findPathwaysByLiterature(query)
    return(res$url)
}
