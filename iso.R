library(ordinal)
library(splines)

attr(modAns,"terms") <- NULL 

predNames <- c(
  "age", "wealth", "religion", "edu", "urRural", "job",
  "maritalStat", "media", "knowledge", "MCCategory"
)

isoList <- lapply(predNames, function(n){
  ordpred(mod, n, modAns)
})

#rdsave(isoList)