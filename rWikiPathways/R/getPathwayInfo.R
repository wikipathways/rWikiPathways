getPathwayInfo <- function(pathway=NA) {
  if (missing(pathway)) stop("You must specify the pathway to retrieve.");

  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste(
    "http://webservice.wikipathways.org/getPathwayInfo?",
    "pwId=", pathway, "&",
    "format=json", sep=""
  )
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  data = fromJSON(txt)$pathwayInfo
}
