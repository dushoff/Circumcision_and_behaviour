library(ordinal)
library(splines)
library(dplyr)

Answers <- subset(Answers, CC != "LS")

modAns <- model.frame(
  condom ~ 
    age + wealth + religion + edu + urRural + job + maritalStat 
  + media + knowledge + MC + period + clusterId + CC, 
  data=Answers, na.action=na.exclude, drop.unused.levels=TRUE
)

old <- modAns %>% filter(period=="old")
new <- modAns %>% filter(period=="new")

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
  df <- data.frame(Category=pred,Sub_Category=rownames(tempdf),tempdf)
  return(df)
}

ddold <- data.frame()
ddnew <- data.frame()
for(i in seq_along(predictors)){
  ddold <- rbind(ddold,combdf(predictors[i],oldlist[[i]]))
  ddnew <- rbind(ddnew,combdf(predictors[i],newlist[[i]]))
}
row.names(ddold) <- row.names(ddnew) <- NULL

ddold2 <- (ddold 
  %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)
ddoldpercent <- (ddold2
  %>% group_by(Category)
  %>% mutate(KE = signif(KE/sum(KE),2)
            , LS = signif(LS/sum(LS),2)
            , MW = signif(MW/sum(MW),2)
            , MZ = signif(MZ/sum(MZ),2)
            , NM = signif(NM/sum(NM),2)
            , RW = signif(RW/sum(RW),2)
            , TZ = signif(TZ/sum(TZ),2)
            , UG = signif(UG/sum(UG),2)
            , ZM = signif(ZM/sum(ZM),2)
            , ZW = signif(ZW/sum(ZW),2)
            , Category2 = Sub_Category
  )
  %>% select(-c(Sub_Category))
)
ddold3 <- (ddold2
  %>% select(-Sub_Category)
  %>% group_by(Category)
  %>% summarise_each(funs(sum(.))) 
  %>% ungroup()
  %>% mutate(Category2=as.factor("Total"))
  %>% rbind.data.frame(ddoldpercent,.)
  %>% arrange(Category,Category2)
  %>% ungroup()
  %>% select(Category2,KE:ZW,Total)
)

ddnew2 <- (ddnew 
           %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)
ddnewpercent <- (ddnew2
                 %>% group_by(Category)
                 %>% mutate(KE = signif(KE/sum(KE),2)
                            , LS = signif(LS/sum(LS),2)
                            , MW = signif(MW/sum(MW),2)
                            , MZ = signif(MZ/sum(MZ),2)
                            , NM = signif(NM/sum(NM),2)
                            , RW = signif(RW/sum(RW),2)
                            , TZ = signif(TZ/sum(TZ),2)
                            , UG = signif(UG/sum(UG),2)
                            , ZM = signif(ZM/sum(ZM),2)
                            , ZW = signif(ZW/sum(ZW),2)
                            , Category2 = Sub_Category
                 )
                 %>% select(-c(Sub_Category))
)
ddnew3 <- (ddnew2
           %>% select(-Sub_Category)
           %>% group_by(Category)
           %>% summarise_each(funs(sum(.))) 
           %>% ungroup()
           %>% mutate(Category2=as.factor("Total"))
           %>% rbind.data.frame(ddnewpercent,.)
           %>% arrange(Category,Category2)
           %>% ungroup()
)
           %>% select(Category2,KE:ZW,Total)
)


knitr::kable(ddold3,format="latex",align="l")
knitr::kable(ddnew3,format="latex",align="l")
