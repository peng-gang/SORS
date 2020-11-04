# heatmap

library(ComplexHeatmap)
library(circlize)

#' Draw heatmap based on SORs
#' 
#' @param SORs A data frame including SOR information. Please check the output of function \code{getSORs} 
#' for details. 
#' @param weight Whether to use the length of SOR as the weight for clustering. If TURE, longer SORs will
#' have higher weight during the clustering. Default: FALSE
#' @param columnKM Apply k-means clustering on columns.  If the value is larger than 1, the heatmap 
#' will be split by columns according to the k-means clustering. For each column slice, hierarchical clustering 
#' is still applied. Default: 1. 
#' @param showLegend Whether to show heatmap legend. Default: TRUE
#' @return heatmap of SORs
#' @seealso \code{getSORs}
heatmapSORs <- function(SORs, weight = FALSE, columnKM = 1, showLegend = TRUE){
  nSample = ncol(SORs) - 3
  x <- matrix(0, nrow = nrow(SORs), ncol = nSample)
  x[SORs[, 4:(nSample+3)] == "DEL"] <- -1
  x[SORs[, 4:(nSample+3)] == "AMP"] <- 1
  
  if(weight){
    wt <- SORs$End - SORs$Start
    x <- x*wt
    x <- x/max(wt)
  }
  
  rownames(x) <-  paste(SORs$Chr, SORs$Start, SORs$End, sep = "_")
  colnames(x) <- colnames(SORs)[4:(nSample+3)]
  
  if(weight){
    col_fun <- colorRamp2(c(-1, -1e-10, 0, 1e-10, 1), c("red", "red", "white", "blue", "blue"))
  } else {
    col_fun <- colorRamp2(c(-1, 0, 1), c("red", "white", "blue"))
  }
  
  chrOrder <- factor(SORs$Chr, levels = unique(SORs$Chr), ordered = TRUE)
  hm <- Heatmap(x, name = "CNV",
                cluster_rows = FALSE, show_row_names = FALSE,
                col = col_fun,
                row_split = chrOrder, row_title_rot = 0,
                row_gap = unit(0, "mm"),  border = TRUE, 
                column_km = columnKM,
                column_km_repeats = ifelse(columnKM==1, 1, 20),
                show_heatmap_legend = showLegend, 
                use_raster = FALSE)
  
  draw(hm)
}
