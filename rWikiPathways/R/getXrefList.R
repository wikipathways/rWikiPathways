getXrefList <- function(pathway=NA, systemCode=NA) {
  if (missing(pathway)) stop("You must specify the pathway to retrieve the Xrefs for.");
  if (missing(systemCode)) stop("You must specify the system code for the Xrefs.");

  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste(
    "https://webservice.wikipathways.org/getXrefList?",
    "pwId=", pathway, "&",
    "code=", systemCode, "&",
    "format=json", sep=""
  )
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  data = fromJSON(txt)$xrefs
}
