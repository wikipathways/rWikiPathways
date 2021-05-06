# ------------------------------------------------------------------------------
#' @title Write GMT File
#'
#' @description Writes a GMT (Gene Matrix Transposed) file from a data frame.
#' @param df Data frame with columns ordered as Identifiers, optional 
#' Description column and Genes. Identifiers must be first and Genes must be last.
#' @param outfile Path to output GMT file 
#' @return None
#' @details The input data frame must include at least two columns: Identifiers
#' (first column) and Genes (last column). The Identifiers will be duplicated to
#' fill the Description column in the output GMT file if none is provided. If 
#' more than three columns are provided, then the first n columns will be 
#' concatenated with % separators to form the ID, where n+2 equals the total
#' number of columns.
#' @references Adapted from the GMT writer in MAGeCKFlute,
#'  \url{https://github.com/WubingZhang/MAGeCKFlute/blob/master/R/readGMT.R}
#' @examples \donttest{
#' my.df <- data.frame(id=c("WP1000","WP1000","WP1000","WP1001","WP1001"),
#'          description=c("cancer","cancer","cancer","diabetes","diabetes"),
#'          gene=c("574413","2167","4690","5781","11184"))
#' writeGMT(my.df, "my_gmt_file.gmt")
#' }
#' @seealso readPathwayGMT
#' @importFrom utils write.table
#' @export
writeGMT <- function(df, outfile){
    
    # Assess and prep data frame
    df.len <- length(df)
    if(df.len < 2){
        stop("The input data frame must include at least two columns.")
    } else if(df.len == 2){
        df$desc <- df[,1]
        df <- df[,c(1,3,2)]
    } else if(df.len > 3){
        id.cols <- names(df[,seq(1,df.len-2)])
        message(paste0("Concatenating the following columns to use as Identifiers: ",paste(id.cols, collapse = ", ")))
        df[,df.len+1] <- apply(df[,id.cols],1,paste,collapse="%")
        df <- df[,!(names(df) %in% id.cols)]
        df <- df[,c(3,1,2)]
    }
    
    # Generate file
    genelists = lapply(unique(df[,1]), function(x){
        paste(df[df[,1]==x, 3], collapse = "\t")
        })
    gmt = cbind(unique(df[,1]), df[!duplicated(df[,1]),2], unlist(genelists))
    write.table(gmt, outfile, sep = "\t", row.names = FALSE,
                col.names = FALSE, quote = FALSE)
}
