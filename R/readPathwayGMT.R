# ------------------------------------------------------------------------------
#' @title Read Pathway GMT File
#'
#' @description Reads a WikiPathways GMT file to produce a data frame of 
#' pathway-gene associations useful in enrichment analyses and other 
#' applications.
#' @param file Path to GMT file 
#' @return Data frame of pathway-gene associations
#' @details The returned data frame includes pathway name, version, identifier,
#' and organism. The gene content is provided as NCBI Entrez Gene identifiers.
#' The input file can be retrieved by using 
#' \code{downloadPathwayArchive(organism="Homo sapiens",format="gmt")}.
#' @references Adapted from the generic GMT reader provided by clusterProfiler,
#'  \url{https://github.com/YuLab-SMU/clusterProfiler/blob/master/R/GMT.R}
#' @examples \donttest{
#' readPathwayGMT(gmt.file)
#' }
#' @seealso downloadPathwayArchive
#' @export
#' @importFrom tidyr separate
readPathwayGMT <- function(file) {
  x <- readLines(file)
  res <- strsplit(x, "\t")
  names(res) <- vapply(res, function(y) y[1], character(1))
  res <- lapply(res, "[", -c(1:2))
  
  wp2gene <- stack(res)
  wp2gene <- wp2gene[, c("ind", "values")]
  colnames(wp2gene) <- c("pathway", "gene")
  wp2gene <- tidyr::separate(wp2gene, pathway, c("name","version","wpid","org"), "%")
  return(wp2gene)
}