# ------------------------------------------------------------------------------
#' @title Read GMT File
#'
#' @description Reads any generic GMT file to produce a data frame of 
#' term-gene associations useful in enrichment analyses and other 
#' applications.
#' @param file Path to GMT file 
#' @return Data frame of term-gene associations
#' @details The returned data frame includes only terms and genes. If you want
#' another data frame with terms and names, then see readGMTnames. 
#' @examples \donttest{
#' readGMT("my_gmt_file.gmt")
#' }
#' @seealso readGMTnames
#' @export
#' @importFrom tidyr separate
#' @importFrom utils stack
readGMT <- function(file) {
    x <- readLines(file)
    res <- strsplit(x, "\t")
    names(res) <- vapply(res, function(y) y[1], character(1))
    res <- lapply(res, "[", -c(1:2))
    
    wp2gene <- stack(res)
    wp2gene <- wp2gene[, c("ind", "values")]
    colnames(wp2gene) <- c("term", "gene")
    wp2gene[] <- lapply(wp2gene, as.character) #replace factors for strings
    return(wp2gene)
}

# ------------------------------------------------------------------------------
#' @title Read GMT File for Names
#'
#' @description Reads any generic GMT file to produce a data frame of 
#' term-name associations useful in enrichment analyses and other 
#' applications.
#' @param file Path to GMT file 
#' @return Data frame of term-namee associations
#' @details The returned data frame includes only terms and names. If you want
#' another data frame with terms and genes, then see readGMT. 
#' @examples \donttest{
#' readGMTnames("my_gmt_file.gmt")
#' }
#' @seealso readGMT
#' @export
#' @importFrom tidyr separate
#' @importFrom utils stack
readGMTnames <- function(file) {
    x <- readLines(file)
    res <- strsplit(x, "\t")
    names(res) <- vapply(res, function(y) y[1], character(1))
    res <- lapply(res, "[", c(2))
    
    wp2name <- stack(res)
    wp2name <- wp2name[, c("ind", "values")]
    colnames(wp2name) <- c("term", "name")
    wp2name[] <- lapply(wp2name, as.character) #replace factors for strings
    return(wp2name)
}