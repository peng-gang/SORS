
getSOR <- function(CNVInfo){
  idxDEL <- CNVInfo$CNV == "DEL"
  idxAMP <- CNVInfo$CNV == "AMP"
  CNVInfo$CNV[idxDEL] <- 0.5
  CNVInfo$CNV[idxAMP] <- 1.5
  CNVInfo$CNV[(!idxDEL) & (!idxAMP)] <- 1
  
  info <- NULL
  for(i in 1:nrow(CNVInfo)){
    infoTmp <- paste(
      CNVInfo$chr[i],
      CNVInfo$start[i],
      CNVInfo$end[i],
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
    colnames(rlt) <- cn
    rlt <- data.frame(rlt, stringsAsFactors = FALSE)
  }
  
  for(i in 4:ncol(rlt)){
    idxDEL <- as.numeric(rlt[,i]) < 1
    idxAMP <- as.numeric(rlt[,i]) > 1
    rlt[idxDEL,i] <- "DEL"
    rlt[idxAMP,i] <- "AMP"
    rlt[(!idxDEL) & (!idxAMP), i] <- "NONE"
  }
  
  rlt
}
