library(dplyr)

old <- Answers %>% filter(period=="old")
new <- Answers %>% filter(period=="new")

old_table <- function(x){
  return(table(old[,x],old[,"CC"]))
}

new_table <- function(x){
  return(table(new[,x],new[,"CC"]))
}
predictors <- c("ageGroup","urRural","edu","religion","maritalStat","job","condom"
                ,"partnerYear", "partnerLife", "MC", "MCCategory")


oldlist <- lapply(predictors,old_table)
newlist <- lapply(predictors,new_table)

combdf <- function(pred,lldf){
  tempdf <- as.data.frame.matrix(lldf)
  df <- data.frame(predictor=pred,pred_cat=rownames(tempdf),tempdf)
  return(df)
}

ddold <- data.frame()
ddnew <- data.frame()
for(i in seq_along(predictors)){
  ddold <- rbind(ddold,combdf(predictors[i],oldlist[[i]]))
  ddnew <- rbind(ddnew,combdf(predictors[i],newlist[[i]]))
}
row.names(ddold) <- row.names(ddnew) <- NULL

knitr::kable(ddold,format="markdown")
knitr::kable(ddnew,format="markdown")
