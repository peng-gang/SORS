# Ideogram
library(circlize)

ideogramCircle <- function(
  SORs, 
  hg = "hg18", 
  ylim = NULL, 
  chromosomeIndex = NULL,
  atY = NULL,
  colorAMP = "blue",
  colorDEL = "red"){
  
  nSample = ncol(SORs) - 3
  fryTotal <- rowSums(SORs[,4:(3+nSample)] != "NONE")/nSample
  fryAmp <- rowSums(SORs[,4:(3+nSample)] == "AMP")/nSample
  fryDel <- rowSums(SORs[,4:(3+nSample)] == "DEL")/nSample
  
  bedFry <- data.frame(
    chr = rep(SORs$Chr, 2),
    start = rep(SORs$Start, 2),
    end = rep(SORs$End, 2),
    value1 = c(fryAmp, -fryDel),
    stringsAsFactors = FALSE
  )
  
  bedFry$chr <- paste0("chr", bedFry$chr)
  bedFry <- bedFry[bedFry$value1!=0,]
  
  if(is.null(ylim)){
    ylim = c(floor(min(bedFry$value1[bedFry$value1<0])*10)/10,
             ceiling(max(bedFry$value1[bedFry$value1>0])*10)/10)
  }
  
  if(is.null(chromosomeIndex)){
    chromosomeIndex <- paste0("chr", c(1:22, "X", "Y"))
  }
  
  if(is.null(atY)){
    stp <- ceiling(max(abs(ylim))*5)/10
    if(stp < -ylim[1]){
      atY <- c(-stp, 0)
    }
    
    if(stp < ylim[2]){
      atY <- c(atY, stp)
    }
    
    lableY <- paste0(abs(atY) * 100, "%")
  }
  
  circos.par(start.degree=90,
             gap.degree = c(rep(1, 23), 10))
  circos.initializeWithIdeogram(plotType = c("labels"),
                                species=hg, chromosome.index = chromosomeIndex)
  circos.genomicTrack(bedFry, ylim = ylim, bg.border = NA,
                      panel.fun = function(region, value, ...) {
                        circos.genomicRect(region, value, ytop.column = 1, ybottom = 0, 
                                           col = ifelse(value[[1]] > 0, colorAMP, colorDEL),
                                           border = NA, ...)
                        #circos.lines(CELL_META$cell.xlim, c(0, 0), lty = 2, col = "#00000040")
                      })
  circos.yaxis(side = "left", sector.index = "chr1", track.index = 2,
               at = atY, labels = lableY)
  circos.genomicIdeogram() # put ideogram as the third track
  circos.clear()
}


ideogram <- function(SORs){
  
}
