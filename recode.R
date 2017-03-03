cat("##############################################\n")
print(rtargetname)
cat("##############################################\n")

library(gdata)
library(dplyr)

Answers <- (Answers
  ## Reweight before subsetting.
	%>% mutate(sampleWeight = sampleWeight/sum(sampleWeight))
  # Drop people whose age is older than 49.
	%>% filter(age <= 49)
  # Don't want people who haven't heard of HIV, don't know their circ history or have never had sex
	%>% filter(!is.na(heardHIV) & heardHIV=="Yes")
	%>% filter(!is.na(recentSex) & !grepl("Never", recentSex))
  %>% filter(!is.na(MC) & !(MC=="Don't know") & !(MC=="DK") & !(MC=="DK/Not sure"))
  %>% mutate(MC = drop.levels(MC, reorder=FALSE)
  , recentSex = drop.levels(recentSex, reorder=FALSE)
  , CC = as.factor(substring(survey, 1, 2))
  , recode = as.numeric(substring(survey, 3, 3))
  , wealth = wealth/100000
  , religion = tableRecode(religion, "religion", maxCat=4) # 
  , religion = factor(religion,levels=c(levels(religion), "Tanzanian"))
  # , religion = ifelse(survey=="TZ5","Tanzanian",religion)
  , maritalStat = tableRecode(maritalStat, "partnership", maxCat=5)
  , condom = drop.levels(condom, reorder=FALSE)
  , partnerYearMax = 3 
  , partnerLifeMax = 6
  , partnerYear = tfun(partnerYear, 3) ## avoid warning message
  , extraPartnerYear = as.factor(ifelse(partnerYear==0, 0, partnerYear-1))
  , partnerLife = tfun(partnerLife, 6)
  , partnerLife = as.factor(partnerLife)
  , clusterId = as.factor(clusterId)
  )
)

# HIV knowledge
Answers <- within(Answers, {
  religion[survey=="TZ5"] <- "Tanzanian"
	if(sum(!is.na(knowledgeCondomsProtect))>0){
		levels(knowledgeCondomsProtect)[levels(knowledgeCondomsProtect)=="Reduce chances of AIDS by always using condoms during sex"] <- "Yes"}
	if(sum(!is.na(knowledgeLessPartnerProtect))>0){
		levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partner with no oth partner"] <- "Yes"
		levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partner with no other partn"] <- "Yes"
		levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partnr with no other partn"] <- "Yes"
		levels(knowledgeLessPartnerProtect)[levels(knowledgeLessPartnerProtect)=="Reduce chance of AIDS: have 1 sex partnr with no oth partner"] <- "Yes"}
	if(sum(!is.na(knowledgeHealthyGetAids))>0){
		levels(knowledgeHealthyGetAids)[levels(knowledgeHealthyGetAids)=="DK"] <- "Don't know"
		levels(knowledgeHealthyGetAids)[levels(knowledgeHealthyGetAids)=="Don't know anyone with AIDS"] <- NA}
})

# Calculate MC statuses:
# in ageMC, 98 is "don't know" and 95 and 96 are "during childhood <5 years"  So 98 shall be coded as NA and 95 and 96 oldMC.
# zw7_6 (Zimbabwe)(phase_recode), 8 (using 2007 as threshold for MC cutting time) (2015)
# rw7_6, 7 (2014-5)
# ls7_6, 7 (2014)
# ke7_6, 7 (2014)
# nm6_6, 6 (2013)
# zm6_6 (Zambia), 6 (2013-4)
# mz6_6, 4 (2011)
# ug6_6, 4 (2011)
# mw6_5, 3 (2010)
# tz6_5, 3 (2009 Dec -2010)

ctable <- read.csv(grep("mcc", input_files, value=TRUE))
print(ctable)
set <- sub("[.].*", "", rtargetname)
ind <- cut <- which(set==rownames(ctable))
cut <- ifelse(length(ind)==1, ctable$cut[[ind]], NA)

Answers <- (Answers
  %>% mutate(mccut = cut
   , ageMC = ifelse(ageMC==95 | ageMC==96,5,ifelse(ageMC==98,NA,ageMC))
   , oldMC = ifelse(age-ageMC>mccut,"Old","New")
   , MCCategory = as.factor(ifelse(MC=="No","No",oldMC))
   , clusterID = as.factor(paste(survey, clusterId, sep="_"))
  )
)


# rdsave(Answers)
