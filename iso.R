library(ordinal)
library(splines)

attr(modAns,"terms") <- NULL 


isoList <- lapply(predNames, function(n){
  ordpred(mod, n, modAns)
})

#rdsave(isoList)