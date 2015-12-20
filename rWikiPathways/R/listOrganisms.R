listOrganisms <- function() {
  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/rwikipathways")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste("http://webservice.wikipathways.org/listOrganisms?format=json", sep="")
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  data = fromJSON(txt)$organisms
}
