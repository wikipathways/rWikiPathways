findPathwaysByXref <- function(identifier=NA, systemCode=NA) {
  if (missing(identifier)) stop("You must specify the Xref identifier.");
  if (missing(systemCode)) stop("You must specify the system code for the Xref.");

  handle = new_handle()
  handle_setheaders(handle, "User-Agent" = "r/renm")
  handle_setheaders(handle, "Accept" = "application/json")

  url = paste(
    "http://webservice.wikipathways.org/findPathwaysByXref?",
    paste("ids=",identifier,"&",collapse="",sep=""),
    paste("codes=",systemCode,"&",collapse="",sep=""),
    "format=json", sep=""
  )
  conn <- curl::curl(url, handle, open="r")
  txt <- readLines(conn, warn=FALSE)
  close(conn)
  result = fromJSON(txt)$result
  fields = fromJSON(txt)$result$fields
  fields = cbind(fields$graphId$value, fields$id.database$values)
  data = cbind(
    fields,
    result[,c("id","name","species","revision")]
  )
  colNames = colnames(data)
  colNames[1] = "graphid"
  colNames[2] = "xref"
  colnames(data) = colNames
  return(data)
}
