#' Expand summary table of patterns and frequencies
#'
#' The \code{expand.table} function expands a summary table of unique response
#' patterns to a full sized data-set. The response frequencies must be on the
#' rightmost column of the input data.
#'
#'
#' @param tabdata An object of class \code{data.frame}, \code{matrix}, or
#'   \code{table} with the unique response patterns and the number of frequencies
#'   in the rightmost column.
#' @return Returns a numeric matrix with all the response patterns.
#' @author Phil Chalmers \email{rphilip.chalmers@@gmail.com}
#' @keywords data
#' @export expand.table
#' @examples
#'
#' \dontrun{
#' data(LSAT7)
#' head(LSAT7)
#' LSAT7full <- expand.table(LSAT7)
#' head(LSAT7full)
#'    }
#'
expand.table <- function(tabdata) {
    if(missing(tabdata)) missingMsg('tabdata')
    if (sum(tabdata[,ncol(tabdata)]) <= nrow(tabdata))
        stop("Frequencies must be on the right of the data matrix.", call.=FALSE)
    itemnames <- colnames(tabdata[,1L:(ncol(tabdata) - 1L)])
    tabdata <- as.matrix(tabdata)
    fulldata <- c()
    for (i in 1L:nrow(tabdata)) {
        tmp <- matrix(tabdata[i,1L:(ncol(tabdata) - 1L)],
                      tabdata[i,ncol(tabdata)],
                      length(tabdata[i,1L:(ncol(tabdata) - 1L)]), byrow = TRUE)
        fulldata <- rbind(fulldata, tmp)
    }
    colnames(fulldata) <- itemnames
    fulldata
}

