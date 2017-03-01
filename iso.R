library(ordinal)
library(splines)
library(gridExtra)
library(dplyr)
library(ggplot2)
library(reshape)
theme_set(theme_bw())
attr(modAns,"terms") <- NULL 

predNames <- c("age", "wealth","CC", "religion", "edu", "urRural", "job",
           "maritalStat", "media", "knowledge","MC","period")

# predNames <- c("CC", "religion")

catNames <- c("CC","religion","urRural","job","maritalStat","MC","period")

# catNames <- c("CC","religion")

BSmat <- function(x){
  Smat <- diag(length(coef(x)))
  rownames(Smat) <- colnames(Smat) <- attr(coef(x),"name")
  return(Smat)
}

Smat <- BSmat(mod)

dd <- data.frame(model.matrix(delete.response(terms(mod)), modAns[rownames(model.frame(mod)), ]))
ddTZ4 <- (dd 
  %>% filter(CCTZ == 1) 
  %>% filter(religionTanzanian==0)
  %>% summarise_each(funs(mean))
)

if(nrow(Smat)!= length(ddTZ4)){
  ddTZ4 <- data.frame(0,ddTZ4)
}
Smat["CCTZ",grep(pattern="religion",colnames(Smat))] <- -1
Smat["CCTZ",] <- unlist(ddTZ4 * Smat["CCTZ",])


isoList <- lapply(predNames, function(n){
  ordpred(mod, n, modAns,Smat)
})

print(
grid.arrange(varPlot(rename(isoList[[1]],c(age="Age")),P=varlvlsum$`Pr(>Chisq)`[1]),
             varPlot(rename(isoList[[2]],c(wealth="Wealth")),P=varlvlsum$`Pr(>Chisq)`[2]),
             varPlot(rename(isoList[[3]],c(CC="Country")),P=varlvlsum$`Pr(>Chisq)`[3]),
             varPlot(rename(isoList[[4]]%>% filter(religion != "Tanzanian"),c(religion="Religion")),P=varlvlsum$`Pr(>Chisq)`[4]),
             varPlot(rename(isoList[[5]],c(edu="Education")),P=varlvlsum$`Pr(>Chisq)`[5]),
             varPlot(rename(isoList[[6]],c(urRural="Area")),P=varlvlsum$`Pr(>Chisq)`[6]),
             varPlot(rename(isoList[[7]],c(job="Job")),P=varlvlsum$`Pr(>Chisq)`[7]),
             varPlot(rename(isoList[[8]],c(maritalStat="Marital Status")),P=varlvlsum$`Pr(>Chisq)`[8]),
             varPlot(rename(isoList[[9]],c(media="Media")),P=varlvlsum$`Pr(>Chisq)`[9]),
             varPlot(rename(isoList[[10]],c(knowledge="Knowledge")),P=varlvlsum$`Pr(>Chisq)`[10]),
             varPlot(rename(isoList[[11]],c(MC="MC")),P=varlvlsum$`Pr(>Chisq)`[11]),
             varPlot(rename(isoList[[12]],c(period="Period")),P=varlvlsum$`Pr(>Chisq)`[12]),
             nrow=4)
)

#rdsave(isoList,varlvlsum)