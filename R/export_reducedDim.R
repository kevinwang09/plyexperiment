#' @title Exporting the reducedDim object as a tibble
#'
#' @param sce A SingleCellExperiment object
#' @param type A character in reducedDimNames(sce)
#' @param feature A character vector, must be a subset of the rownames of sce
#' @param assayname Name of the assay, default to "logcounts"
#' @param cell_name The name of the rownames of colData(sce) when assay data and colData are joined.
#' @author Kevin Wang
#' @import SingleCellExperiment
#' @importFrom dplyr left_join transmute
#' @importFrom magrittr set_colnames %>%
#' @importFrom tibble rownames_to_column as_tibble
#' @importFrom reshape2 melt
#' @importFrom S4Vectors DataFrame
#' @return A tibble
#' @export
#' @examples
#' ncells <- 100
#' ngenes <- 200
#' u <- matrix(rpois(ngenes*ncells, 5), ncol=ncells)
#' colnames(u) = paste0("cell", 1:ncells)
#' rownames(u) = paste0("gene", 1:ngenes)
#' v <- log2(u + 1)
#'
#' colData = S4Vectors::DataFrame(
#' colrandom = sample(letters, ncells, replace = TRUE),
#' row.names = colnames(u))
#'
#' rowData = S4Vectors::DataFrame(
#' rowrandom = sample(letters, ngenes, replace = TRUE),
#' row.names = rownames(u))
#'
#' pca <- matrix(runif(ncells*2), ncells)
#' tsne <- matrix(rnorm(ncells*2), ncells)
#'
#' sce <- SingleCellExperiment(assays = list(counts = u, logcounts = v),
#' colData = colData, rowData = rowData,
#' reducedDims = SimpleList(PCA = pca, TSNE = tsne))
#' sce

export_reducedDim = function(sce, type, cell_name = "cell_name", feature = NULL, assayname = "logcounts"){
  stopifnot(class(sce) == "SingleCellExperiment")
  stopifnot(type %in% SingleCellExperiment::reducedDimNames(sce))

  result = SingleCellExperiment::reducedDim(sce, type = type)[,1:2] %>%
    magrittr::set_colnames(value = paste0("V", 1:2)) %>%
    cbind(., colData(sce)) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(cell_name) %>%
    tibble::as_tibble()


  if(!is.null(feature_set)){
    feature_tbl = SummarizedExperiment::assay(sce[feature_set,], assayname) %>%
      as.matrix %>%
      reshape2::melt() %>%
      dplyr::transmute(
        gene_name = Var1,
        cell_name = Var2,
        value)

    result = result %>%
      left_join(feature_tbl, by = cell_name)
  }
  return(result)
}
