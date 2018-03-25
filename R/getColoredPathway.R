# ------------------------------------------------------------------------------
#' @title Get Colored Pathway
#'
#' @description Retrieve a pathway image file with specified nodes colored by specified colors
#' @param pathway WikiPathways identifier (WPID) for the pathway to download, e.g. WP4
#' @param revision (optional) Number to indicate a specific revision to download
#' @param graphId String or vector indicating the nodes to color (only single values are supported at this time)
#' @param color (optional) String or vector indicating the highlighting color, e.g., #FF8855.
#' Default is red. You can provide a single color for mutiple nodes; otherwise
#' color list and graphId must be the same length.
#' @param fileType (optional) Image file format
#' @return Image file
#' @examples \donttest{
#'   svg = getColoredPathway(pathway="WP554", graphId="ef1f3");
#'   svg = getColoredPathway(pathway="WP554", graphId=c("ef1f3","e68e0"));
#'   svg = getColoredPathway(pathway="WP554", graphId=c("ef1f3","e68e0"),
#'                           color="00FF00");
#'   svg = getColoredPathway(pathway="WP554", graphId=c("ef1f3","e68e0"),
#'                           color=c("FF0000", "0000FF"));
#'   writeLines(svg, "pathway.svg")
#' }
#' @importFrom caTools base64decode
#' @export
getColoredPathway <- function(pathway, revision=0,
                              graphId=NULL, color=NULL,
                              fileType="svg") {
    if (is.null(color)&&!is.null(graphId)) {
        color = rep("FF0000", length(graphId))
    } else if (length(color) == 1) {
        color = rep(color, length(graphId))
    }
    
    if(length(graphId) != length(color))
        stop("Error: Must provide same number of graphIds and colors.")
    
    # if these are still null, then swap for strings to avoid complications
    if(is.null(graphId))
            graphId="NULL"
    if(is.null(color))
            color="NULL"

    res <- wikipathwaysGET('getColoredPathway',
                           list(pwId=pathway,
                                revision=revision,
                                graphId=graphId,
                                color=color,
                                fileType=fileType)) 

    img = caTools::base64decode(res['data'],what='character')

  return(img)
}
