findPathwaysByXref <- function(identifier=NA, systemCode=NA) {
  if (missing(identifier)) stop("You must specify the Xref identifier.");
  if (missing(systemCode)) stop("You must specify the system code for the Xref.");

  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste(
    "http://webservice.wikipathways.org/findPathwaysByXref?",
    "ids=", identifier, "&",
    "codes=", systemCode, "&",
    "format=json", sep=""
  )
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  fields = c("id","url","name","species","revision")
  data = fromJSON(txt)$result[,fields]
}
