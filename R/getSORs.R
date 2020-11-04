#' Get smallest overlap regions of copy numbers between samples
#' 
#' @param CNVInfo A data frame of copy number variation (CNV) information. Each row of the data frame 
#' is a record for a copy number variation. The data frame includs at leat 5 columns, Sample, Chr, Start, End, and CNV.
#' Sample: id of samples; Chr: chrosome of CNV; Start: start position of CNV; End: end position of CNV;
#' CNV: copy number type (DEL or AMP). 
#' @return Smallest overlap regions of copy number variation between samples. The first 3 columns are
#' chromosome, start and end position of SORs. The columns from 4 to the last show whether the sample 
#' has CNV or not at the specific SOR. NONE: the sample does not have CNV in the SOR; AMP: the sample has 
#' amplification CNV in the SOR; DEL: the sample has deletion CNV in the SOR.
#' @example 
#' data(SORsExample)
#' SORs <- getSORs(CNVInfo)
#' 
getSORs <- function(CNVInfo){
  idxDEL <- CNVInfo$CNV == "DEL"
  idxAMP <- CNVInfo$CNV == "AMP"
  CNVInfo$CNV[idxDEL] <- 0.5
  CNVInfo$CNV[idxAMP] <- 1.5
  CNVInfo$CNV[(!idxDEL) & (!idxAMP)] <- 1
  
  info <- NULL
  for(i in 1:nrow(CNVInfo)){
    infoTmp <- paste(
      CNVInfo$Chr[i],
      CNVInfo$Start[i],
      CNVInfo$End[i],
      CNVInfo$CNV[i],
      CNVInfo$Sample[i],
      sep = "\t"
    )
    info <- c(info, infoTmp)
  }
  
  tmp <- getSORC(info)
  cn <- names(tmp)
  rlt <- NULL
  for(i in 1:length(tmp)){
    if(i == 1){
      rlt <- as.character(tmp[[i]])
    } else {
      rlt <- cbind(rlt, as.character(tmp[[i]]))
    }
  }
  rlt <- data.frame(rlt, stringsAsFactors = FALSE)
  colnames(rlt) <- cn
  
  for(i in 4:ncol(rlt)){
    idxDEL <- as.numeric(rlt[,i]) < 1
    idxAMP <- as.numeric(rlt[,i]) > 1
    rlt[idxDEL,i] <- "DEL"
    rlt[idxAMP,i] <- "AMP"
    rlt[(!idxDEL) & (!idxAMP), i] <- "NONE"
  }
  
  rlt$Start <- as.numeric(rlt$Start)
  rlt$End <- as.numeric(rlt$End)
  rlt
}
