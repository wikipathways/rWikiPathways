getColoredPathway <- function(pathway=NA, revision=0,
  graphId=NA, color=NA,
  fileType="svg")
{
  if (missing(pathway)) stop("You must specify the pathway to retrieve.");
  if (missing(graphId)) stop("You must specify the graphId(s).");

  if (missing(color)) {
    color = rep("FF0000", length(graphId))
  } else if (length(color) == 1) {
    color = rep(color, length(graphId))
  }

  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste(
    "https://webservice.wikipathways.org/getColoredPathway?",
    paste("pwId=",pathway,"&",sep=""),
    paste("revision=",revision,"&",sep=""),
    paste("graphId=",graphId,"&",collapse="",sep=""),
    paste("color=",color,"&",collapse="",sep=""),
    paste("fileType=",fileType,"&",sep=""),
    "format=json", sep=""
  )
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  result = fromJSON(txt)$data
  data = RCurl::base64Decode(result)
  return(data)
}
