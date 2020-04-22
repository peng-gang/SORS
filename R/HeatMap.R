# heatmap

library(ComplexHeatmap)
library(circlize)

heatmapSORs <- function(SORs, weight = FALSE, showLegend = TRUE){
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
  
  
  # ha = HeatmapAnnotation(
  #   Grade = G,
  #   Recurrence = R,
  #   BCLC = BCLC,
  #   col = list(Grade = c("G2" = "brown1", "G3" = "brown3"),
  #              Recurrence = c("R" = "darkorange3", "NR" = "darkorange1"),
  #              BCLC = c("A" = "gray75", "B" = "gray50", "C" = "gray25")))
  
  chrOrder <- factor(SORs$Chr, levels = unique(SORs$Chr), ordered = TRUE)
  hm <- Heatmap(x, name = "CNV",
                cluster_rows = FALSE, show_row_names = FALSE,
                col = col_fun,
                row_split = chrOrder, row_title_rot = 0,
                row_gap = unit(0, "mm"),  border = TRUE, 
                how_heatmap_legend = showLegend, 
                use_raster = FALSE)
                #top_annotation = ha)
  draw(hm)
}

