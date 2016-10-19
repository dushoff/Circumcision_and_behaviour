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
                ,"partnerYear", "partnerLife", "MC", "MCCategory","knowledgeCondomsProtect"
                ,"knowledgeLessPartnerProtect", "knowledgeHealthyGetAids","mediaNpMg"
                ,"mediaRadio","mediaTv")


oldlist <- lapply(predictors,old_table)
newlist <- lapply(predictors,new_table)

combdf <- function(pred,lldf){
  tempdf <- as.data.frame.matrix(lldf)
  df <- data.frame(Category=pred,pred_cat=rownames(tempdf),tempdf)
  return(df)
}

ddold <- data.frame()
ddnew <- data.frame()
for(i in seq_along(predictors)){
  ddold <- rbind(ddold,combdf(predictors[i],oldlist[[i]]))
  ddnew <- rbind(ddnew,combdf(predictors[i],newlist[[i]]))
}
row.names(ddold) <- row.names(ddnew) <- NULL

aa <- head(ddold)

ddold2 <- (ddold 
  %>% group_by(predictor)
  %>% mutate(KE = paste(KE,"(",signif(KE/sum(KE),2),")",sep="")
             , LS = paste(LS,"(",signif(LS/sum(LS),2),")",sep="")
             , MW = paste(MW,"(",signif(MW/sum(MW),2),")",sep="")
             , MZ = paste(MZ,"(",signif(MZ/sum(MZ),2),")",sep="")
             , NM = paste(NM,"(",signif(NM/sum(NM),2),")",sep="")
             , RW = paste(RW,"(",signif(RW/sum(RW),2),")",sep="")
             , TZ = paste(TZ,"(",signif(TZ/sum(TZ),2),")",sep="")
             , UG = paste(UG,"(",signif(UG/sum(UG),2),")",sep="")
             , ZM = paste(ZM,"(",signif(ZM/sum(ZM),2),")",sep="")
             , ZW = paste(ZW,"(",signif(ZW/sum(ZW),2),")",sep="")
             )
)

knitr::kable(ddold2,format="markdown",align="c")
knitr::kable(ddnew,format="markdown")
