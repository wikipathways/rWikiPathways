listPathways <- function(organism=NA) {
  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  if (missing(organism)) {
    url = paste("http://webservice.wikipathways.org/listPathways?format=json", sep="")
  } else {
    url = paste(
      "http://webservice.wikipathways.org/listPathways?",
      "organism=", url_encode(organism),
      "&format=json", sep=""
    )
  }
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  data = fromJSON(txt)$pathways
}
