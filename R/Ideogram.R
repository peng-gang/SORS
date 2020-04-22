# Ideogram
library(circlize)
library(karyoploteR)

ideogramCircle <- function(
  SORs, 
  hg = "hg18", 
  ylim = NULL, 
  chromosomeIndex = NULL,
  atY = NULL,
  colorAmp = "blue",
  colorDel = "red"){
  
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
                                           col = ifelse(value[[1]] > 0, colorAmp, colorDel),
                                           border = NA, ...)
                        #circos.lines(CELL_META$cell.xlim, c(0, 0), lty = 2, col = "#00000040")
                      })
  circos.yaxis(side = "left", sector.index = "chr1", track.index = 2,
               at = atY, labels = lableY)
  circos.genomicIdeogram() # put ideogram as the third track
  circos.clear()
}


ideogram <- function(
  SORs,
  hg = "hg18", 
  colorAmp = "blue",
  colorDel = "red",
  includeAB = TRUE,
  abAmp = NULL,
  abDel = NULL
  ){
  nSample = ncol(SORs) - 3
  fryTotal <- rowSums(SORs[,4:(3+nSample)] != "NONE")/nSample
  fryAmp <- rowSums(SORs[,4:(3+nSample)] == "AMP")/nSample
  fryDel <- rowSums(SORs[,4:(3+nSample)] == "DEL")/nSample
  
  bedFry <- data.frame(
    chr = rep(SORs$Chr, 2),
    start = rep(SORs$Start, 2),
    end = rep(SORs$End, 2),
    fry = c(fryAmp, -fryDel),
    stringsAsFactors = FALSE
  )
  
  bedFry$chr <- paste0("chr", bedFry$chr)
  bedFry <- bedFry[bedFry$fry!=0,]
  
  bedAmp <- bedFry[bedFry$fry>0,]
  bedDel <- bedFry[bedFry$fry<0,]
  bedDel$fry <- -bedDel$fry
  
  if(is.null(abAmp)){
    if(is.null(abDel)){
      abAmp <- abDel <- ceiling(max(c(max(bedAmp$fry), max(bedDel$fry))) * 10)/10
      labelAmp <- labelDel <- paste0(abAmp * 100, "%")
    } else {
      abAmp <- abDel
      labelAmp <- labelDel <- paste0(abAmp * 100, "%")
    }
  } else {
    if(is.null(abDel)){
      abDel <- abAmp
      labelAmp <- labelDel <- paste0(abAmp * 100, "%")
    } else {
      labelAmp <- paste0(abAmp * 100, "%")
      labelDel <- paste0(abDel * 100, "%")
    }
  }
  
  pp <- getDefaultPlotParams(plot.type=2)
  
  #Change the ideogramheight param to create thicker ideograms 
  pp$data1outmargin <- 150
  pp$data2outmargin <- 150
  
  kp <- plotKaryotype(genome = hg, plot.type = 2, plot.params = pp, #labels.plotter = NULL,
                      chromosomes = paste0("chr", c("Y", "X", 22:1)))
  
  #kpText(kp, chr = paste0("chr", c(1:22, "X", "Y")), y=y.pos, x=chrom.length, r0=0, r1=2, 
  #       labels=c(1:22, "X", "Y"), cex=1, pos=4, srt=90)
  
  
  kpBars(kp, chr=bedAmp$chr, x0=bedAmp$start, x1=bedAmp$end, y1=bedAmp$fry, r0 = 0, r1=2,
         col = colorAmp, border = NA, data.panel = 1)
  kpBars(kp, chr=bedDel$chr, x0=bedDel$start, x1=bedDel$end, y1=bedDel$fry, r0 = 0, r1=2, data.panel = 2,
         col = colorDel, border = NA)
  
  if(includeAB){
    kpAbline(kp, r0=0, r1=2, h=abAmp, col = "grey", lty = 3)
    kpText(kp, chr = paste0("chr", c(1:22, "X", "Y")), y=0.3, x=chrom.length, r0=0, r1=2, 
           col="#444444", labels=labelAmp, cex=0.6, pos=4, srt=0)
    
    
    kpAbline(kp, r0=0, r1=2, h=abDel, data.panel = 2, col = "grey", lty = 3)
    kpText(kp, chr = paste0("chr", c(1:22, "X", "Y")), y=0.7, x=chrom.length, data.panel = 2, r0=0, r1=2, 
           col="#444444", labels=labelDel, cex=0.6, pos=4, srt=0)
  }
  
}
