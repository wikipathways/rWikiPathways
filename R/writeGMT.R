# ------------------------------------------------------------------------------
#' @title Write GMT File
#'
#' @description Writes a GMT (Gene Matrix Transposed) file from a data frame.
#' @param df Data frame with columns ordered as Identifiers, optional 
#' Name columns and Genes. Identifiers must be first and Genes must be last.
#' @param outfile Path to output GMT file 
#' @return None
#' @details The input data frame must include at least two columns: Identifiers
#' (first column) and Genes (last column). The Identifiers will be duplicated to
#' fill the Name column in the output GMT file. If one or more Name columns are 
#' provided in the data frame, #' then they will be concatenated with % 
#' separators.
#' @references Adapted from the GMT writer in MAGeCKFlute,
#'  \url{https://github.com/WubingZhang/MAGeCKFlute/blob/master/R/readGMT.R}
#' @examples \donttest{
#' my.df <- data.frame(id=c("WP1000","WP1000","WP1000","WP1001","WP1001"),
#'          name=c("cancer","cancer","cancer","diabetes","diabetes"),
#'          gene=c("574413","2167","4690","5781","11184"))
#' writeGMT(my.df, "myGmtFile.gmt")
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
        df$name <- df[,1]
        df <- df[,c(1,3,2)]
    } else if(df.len > 3){
        name.cols <- names(df[,seq(2,df.len-1)])
        message(paste0("Concatenating the following columns to use as Name: ",paste(name.cols, collapse = ", ")))
        df[,df.len+1] <- apply(df[,name.cols],1,paste,collapse="%")
        df <- df[,!(names(df) %in% name.cols)]
        df <- df[,c(1,3,2)]
    }
    
    # Generate file
    genelists = lapply(unique(df[,1]), function(x){
        paste(df[df[,1]==x, 3], collapse = "\t")
        })
    gmt = cbind(unique(df[,1]), df[!duplicated(df[,1]),2], unlist(genelists))
    write.table(gmt, outfile, sep = "\t", row.names = FALSE,
                col.names = FALSE, quote = FALSE)
}


