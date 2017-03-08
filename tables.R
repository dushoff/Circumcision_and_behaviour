library(ordinal)
library(splines)
library(dplyr)

# Answers <- subset(Answers, CC != "LS")

LSdat <- Answers %>% filter(CC=="LS") %>% mutate(condom="No")
noLSdat <- Answers %>% filter(CC != "LS")
Ans2 <- rbind(LSdat,noLSdat)

oldAns <- model.frame(
  condom ~ 
    ageGroup + urRural + religion + edu + job + maritalStat + extraPartnerYear + MC 
  + knowledgeCondomsProtect + knowledgeLessPartnerProtect + knowledgeHealthyGetAids 
  + period + mediaNpMg + mediaRadio + CC + mediaTv,
  data=Ans2, na.action=na.exclude, drop.unused.levels=TRUE
)


newAns <- model.frame(
  condom ~ 
    ageGroup + urRural + religion + edu + job + maritalStat + extraPartnerYear + MC 
  + knowledgeCondomsProtect + knowledgeLessPartnerProtect + knowledgeHealthyGetAids 
  + period + mediaNpMg + mediaRadio + CC + mediaTv,
  data=Ans2, na.action=na.exclude, drop.unused.levels=TRUE
)



old <- oldAns %>% filter(period=="Old")
new <- newAns %>% filter(period=="New")

old_table <- function(x){
  return(table(old[,x],old[,"CC"]))
}

new_table <- function(x){
  return(table(new[,x],new[,"CC"]))
}

predictorsOLD <- c("ageGroup","urRural","edu","religion","maritalStat","job","condom"
                   ,"extraPartnerYear", "MC","knowledgeCondomsProtect"
                   ,"knowledgeLessPartnerProtect", "knowledgeHealthyGetAids","mediaNpMg"
                   ,"mediaRadio","mediaTv")


predictorsNEW <- c("ageGroup","urRural","edu","religion","maritalStat","job","condom"
                ,"extraPartnerYear", "MC","knowledgeCondomsProtect"
                ,"knowledgeLessPartnerProtect", "knowledgeHealthyGetAids","mediaNpMg"
                ,"mediaRadio","mediaTv")


oldlist <- lapply(predictorsOLD,old_table)
newlist <- lapply(predictorsNEW,new_table)

combdf <- function(pred,lldf){
  tempdf <- as.data.frame.matrix(lldf)
  df <- data.frame(Category=pred,Sub_Category=rownames(tempdf),tempdf)
  return(df)
}

ddold <- data.frame()
ddnew <- data.frame()
for(i in seq_along(predictorsOLD)){
  ddold <- rbind(ddold,combdf(predictorsOLD[i],oldlist[[i]]))
}

for(i in seq_along(predictorsNEW)){
  ddnew <- rbind(ddnew,combdf(predictorsNEW[i],newlist[[i]]))
}
row.names(ddold) <- row.names(ddnew) <- NULL

ddold2 <- (ddold 
  %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)
ddoldpercent <- (ddold2
  %>% group_by(Category)
  %>% mutate(KE = signif(KE*100/sum(KE),2)
            , LS = signif(LS*100/sum(LS),2)
            , MW = signif(MW*100/sum(MW),2)
            , MZ = signif(MZ*100/sum(MZ),2)
            , NM = signif(NM*100/sum(NM),2)
            , RW = signif(RW*100/sum(RW),2)
            , TZ = signif(TZ*100/sum(TZ),2)
            , UG = signif(UG*100/sum(UG),2)
            , ZM = signif(ZM*100/sum(ZM),2)
            , ZW = signif(ZW*100/sum(ZW),2)
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
  %>% arrange(Category)
  %>% ungroup()
  %>% select(Category,Category2,KE:ZW,Total)
)

ddnew2 <- (ddnew 
           %>% mutate(Total = KE+LS+MW+MZ+NM+RW+TZ+UG+ZM+ZW)
)
ddnewpercent <- (ddnew2
                 %>% group_by(Category)
                 %>% mutate(KE = signif(KE*100/sum(KE),2)
                            , LS = signif(LS*100/sum(LS),2)
                            , MW = signif(MW*100/sum(MW),2)
                            , MZ = signif(MZ*100/sum(MZ),2)
                            , NM = signif(NM*100/sum(NM),2)
                            , RW = signif(RW*100/sum(RW),2)
                            , TZ = signif(TZ*100/sum(TZ),2)
                            , UG = signif(UG*100/sum(UG),2)
                            , ZM = signif(ZM*100/sum(ZM),2)
                            , ZW = signif(ZW*100/sum(ZW),2)
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
           %>% arrange(Category)
           %>% ungroup()
           %>% select(Category,Category2,KE:ZW,Total)
)

# knitr::kable(ddold3,format="latex",digits=3,align="l")
# knitr::kable(ddnew3,format="latex",digits=3,align="l")

ddold4 <- ddold3 %>% mutate(totalper = signif(Total*100/24109,2))
ddnew4 <- ddnew3 %>% mutate(totalpar = signif(Total*100/42261,2))
print(ddold4)