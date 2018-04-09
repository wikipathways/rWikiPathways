# ==============================================================================
# Utility functions used by more than one rWikiPathways function. Typically, these 
# should not be exported, nor visible to package users. Add variable and functions 
# here if you suspect they will be useful for other developers. 
# 
# Dev Note: internal variables and functions should be prefixed with a '.'
# ------------------------------------------------------------------------------
# The base url for all WikiPathways API calls

.baseUrl <- 'https://webservice.wikipathways.org'


# ------------------------------------------------------------------------------
#' @title Open Swagger docs for WikiPathways API
#'
#' @description Opens swagger docs in default browser for available API calls.
#' @param base.url (optional) Ignore unless you need to specify a custom domain.
#' @return New tab in default browser
#' @examples {
#' wikipathwaysAPI()
#' }
#' @importFrom utils browseURL
#' @export
wikipathwaysAPI <- function(base.url=.baseUrl){
    browseURL(paste(base.url,'/ui',sep=""))
}

# ------------------------------------------------------------------------------
#' @title WikiPathways GET
#'
#' @description Constructs the query, makes GET call and processes the result
#' @param operation A \code{character} string to be converted to the query namespace
#' @param parameters A named \code{list} of values to be converted to query parameters 
#' @param format (\code{character}) The format of the return, e.g., json (default), xml, html, jpg, pdf, dump
#' @param base.url (optional) Ignore unless you need to specify a custom domain.
#' @return query result content
#' @examples {
#' wikipathwaysGET('listOrganisms')
#' }
#' @importFrom RJSONIO fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @export
wikipathwaysGET <- function(operation, parameters=NULL, format=c('json','xml','html','jpg','pdf','dump'), base.url=.baseUrl){
    q.url <- paste(base.url, operation, sep="/")
    
    format <- match.arg(format)
    
    if(!is.null(parameters)){
        q.params <- .prepGetQueryArgs(parameters)
        q.url <- paste(q.url, q.params, sep="?")
        q.url <- paste0(q.url, '&format=', format)
    } else {
        q.url <- paste0(q.url, '?format=', format)
    }
    
    res <- GET(url=URLencode(q.url))
    if(res$status_code > 299){
        write(sprintf("rwikipathways::wikipathwaysGET, HTTP Error Code: %d\n url=%s", 
                      res$status_code, URLencode(q.url)), stderr())
        stop()
    } else {
        if(length(res$content)>0){
            return(fromJSON(rawToChar(res$content)))
        } else{
            invisible(res)
        }
    }    
}

# ------------------------------------------------------------------------------
# Takes a named list and makes a string for GET query urls
#' @importFrom utils URLencode
.prepGetQueryArgs <- function(named.args){
    args1 <- names(named.args)
    args2 <- unlist(unname(named.args))
    q.args = paste(args1[1],URLencode(as.character(args2[1])),sep="=")
    for (i in seq(args1)[-1]){
        arg = paste(args1[i],URLencode(as.character(args2[i])),sep="=")
        q.args = paste(q.args,arg,sep="&")
    }
    return(q.args)
}
