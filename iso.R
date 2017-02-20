library(ordinal)
library(splines)
library(gridExtra)
library(ggplot2)
library(reshape)
theme_set(theme_bw())
attr(modAns,"terms") <- NULL 

predNames <- c("age", "wealth","CC", "religion", "edu", "urRural", "job",
           "maritalStat", "media", "knowledge")

catNames <- c("CC","religion","urRural","job","maritalStat")

isoList <- lapply(predNames, function(n){
  ordpred(mod, n, modAns)
})

print(
grid.arrange(varPlot(rename(isoList[[1]],c(age="Age")),P=varlvlsum$`Pr(>Chisq)`[1]),
             varPlot(rename(isoList[[2]],c(wealth="Wealth")),P=varlvlsum$`Pr(>Chisq)`[2]),
             varPlot(rename(isoList[[3]],c(CC="Country")),P=varlvlsum$`Pr(>Chisq)`[3]),
             varPlot(rename(isoList[[4]],c(religion="Religion")),P=varlvlsum$`Pr(>Chisq)`[4]),
             varPlot(rename(isoList[[5]],c(edu="Education")),P=varlvlsum$`Pr(>Chisq)`[5]),
             varPlot(rename(isoList[[6]],c(urRural="Area")),P=varlvlsum$`Pr(>Chisq)`[6]),
             varPlot(rename(isoList[[7]],c(job="Job")),P=varlvlsum$`Pr(>Chisq)`[7]),
             varPlot(rename(isoList[[8]],c(maritalStat="Marital Status")),P=varlvlsum$`Pr(>Chisq)`[8]),
             varPlot(rename(isoList[[9]],c(media="Media")),P=varlvlsum$`Pr(>Chisq)`[9]),
             varPlot(rename(isoList[[10]],c(knowledge="Knowledge")),P=varlvlsum$`Pr(>Chisq)`[10]),
             nrow=4)
)

#rdsave(isoList,varlvlsum)