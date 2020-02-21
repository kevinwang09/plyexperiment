#' Tidying up column data
#'
#' @export
#' @param sce A SingleCellExperiment object
#' @param f A character/factor vector of the same length as ncol(sce)
#' @author Kevin Wang
#' @return A list of SingleCellExperiment correspond to "f".
#' @examples
#' y <- matrix(rnorm(2000), ncol=20)
#' se <- SummarizedExperiment(list(counts=y))
#' se$CellTypes <- sample(LETTERS, ncol(y), replace=TRUE)
#' se$cell_Types <- sample(LETTERS, ncol(y), replace=TRUE)
#' sce_split(se, f = se$CellTypes)

sce_split <- function(sce, f){
  stopifnot(ncol(sce) == length(f))
  unique_f = unique(f)
  result = vector("list", length(unique_f))
  for(i in seq_along(unique_f)){
    result[[i]] = sce[,f == unique_f[i]]
  }
  names(result) = unique_f
  return(result)
}
