#' Tidying up column data
#'
#' @param case Case arguments to be passed to the relevant \pkg{janitor} \code{clean_names} function.
#'
#' @return A modified SingleCellExperiment object.
#'
#' @export
#' @importFrom janitor clean_names
#' @author Kevin Wang
#' @include methods.R
#' @examples
#' y <- matrix(rnorm(2000), ncol=20)
#' se <- SummarizedExperiment(list(counts=y))
#' se$CellTypes <- sample(LETTERS, ncol(y), replace=TRUE)
#' se$cell_Types <- sample(LETTERS, ncol(y), replace=TRUE)
#' clean_names_col(se)

clean_names_col <- function(object, case = "snake") {
  pd <- as.data.frame(colData(object))
  pd <- janitor::clean_names(pd, case)
  rownames(pd) <- rownames(colData(object))
  colData(object) <- DataFrame(pd)
  return(object)
}
