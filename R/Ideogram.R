# Ideogram
library(circlize)
library(karyoploteR)
library(stringr)

#' Circle ideogram of CNV frequency for SORs
#' 
#' @param SORs A data frame including SOR information. Please check the output of function \code{getSORs} 
#' for details. 
#' @param genome A UCSC style genome name. It supports the following genome: hg18, hg19, hg38, 
#' mm10, and mm38. Default: "hg19".
#' @param  ylim The y limits (y1, y2) of the plot
#' @param chromosomeIndex Subset of chromosomes, also used to reorder chromosomes.
#' @param atY The points at which tick-marks of Y axis are to be drawn
#' @param colorAmp Color to show amplification
#' @param colorDel Color to show deletion

ideogramCircle <- function(
  SORs, 
  genome = "hg19", 
  ylim = NULL, 
  chromosomeIndex = usable_chromosomes(genome),
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
  
  if(toupper(substr(bedFry$chr[1], start=1, stop = 3)) == "CHR"){
    str_sub(bedFry$chr, 1, 3) <- "chr"
  } else {
    bedFry$chr <- paste0("chr", bedFry$chr)
  }
  bedFry <- bedFry[bedFry$value1!=0,]
  
  if(is.null(ylim)){
    ylim = c(floor(min(bedFry$value1[bedFry$value1<0])*10)/10,
             ceiling(max(bedFry$value1[bedFry$value1>0])*10)/10)
  }
  
  if(is.null(chromosomeIndex)){
    chromosomeIndex <- paste0("chr", c(1:22, "X", "Y"))
  }
  
  lableY <- NULL
  if(max(abs(atY) > 1)){
    atY <- NULL
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
  } else {
    lableY <- paste0(abs(atY) * 100, "%")
  }
  
  circos.par(start.degree=90,
             gap.degree = c(rep(1, 23), 10))
  circos.initializeWithIdeogram(plotType = c("labels"),
                                species=genome, chromosome.index = chromosomeIndex)
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
  genome = "hg18", 
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
  
  if(toupper(substr(bedFry$chr[1], start=1, stop = 3)) == "CHR"){
    str_sub(bedFry$chr, 1, 3) <- "chr"
  } else {
    bedFry$chr <- paste0("chr", bedFry$chr)
  }
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
  
  kp <- plotKaryotype(genome = genome, plot.type = 2, plot.params = pp, #labels.plotter = NULL,
                      chromosomes = paste0("chr", c("Y", "X", 22:1)))
  
  #kpText(kp, chr = paste0("chr", c(1:22, "X", "Y")), y=y.pos, x=chrom.length, r0=0, r1=2, 
  #       labels=c(1:22, "X", "Y"), cex=1, pos=4, srt=90)
  
  
  kpBars(kp, chr=bedAmp$chr, x0=bedAmp$start, x1=bedAmp$end, y1=bedAmp$fry, r0 = 0, r1=2,
         col = colorAmp, border = NA, data.panel = 1)
  kpBars(kp, chr=bedDel$chr, x0=bedDel$start, x1=bedDel$end, y1=bedDel$fry, r0 = 0, r1=2, data.panel = 2,
         col = colorDel, border = NA)
  
  if(includeAB){
    ranges <- getGenomeAndMask(genome)$genome@ranges
    seqName <- as.character(getGenomeAndMask(genome)$genome@seqnames)
    chrSel <- paste0("chr", c(1:22, "X", "Y"))
    idx <- match(chrSel, seqName)
    lablePos <- ranges@width[idx] - 3000000
    
    kpAbline(kp, r0=0, r1=2, h=abAmp, col = "grey", lty = 3)
    kpText(kp, chr = chrSel, y= abAmp, x=lablePos, r0=0, r1=2, 
           col="#444444", labels=labelAmp, cex=0.6, pos=4, srt=0)
    
    
    kpAbline(kp, r0=0, r1=2, h=abDel, data.panel = 2, col = "grey", lty = 3)
    kpText(kp, chr = chrSel, y= abDel, x=lablePos, data.panel = 2, r0=0, r1=2, 
           col="#444444", labels=labelDel, cex=0.6, pos=4, srt=0)
  }
  
}
