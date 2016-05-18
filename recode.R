cat("##############################################\n")
print(rtargetname)
cat("##############################################\n")
 

library(gdata)


## Reweight before subsetting.
Answers <- within(Answers, {
	sampleWeight <- sampleWeight/sum(sampleWeight)
})

## subsets
	# Drop people whose age is older than 49.
Answers <- subset(Answers, age <=49)

# Don't want people who haven't heard of HIV, don't know their circ history or have never had sex
Answers <- subset(Answers, !is.na(heardHIV) & heardHIV=="Yes")
Answers <- subset(Answers,
	!is.na(recentSex) & !grepl("Never", recentSex)
)
Answers <- subset(Answers,
	!is.na(MC) & !(MC=="Don't know") & !(MC=="DK")
)
Answers <- within(Answers, {
	MC <- drop.levels(MC, reorder=FALSE)
	recentSex <- drop.levels(recentSex, reorder=FALSE)
})

Answers <- within(Answers, {
	CC <- substring(survey, 1, 2)
	CC <- as.factor(CC)
	recode <- as.numeric(substring(survey, 3, 3))
})

Answers <- within(Answers, {
	wealth <- wealth/100000
	religion <- tableRecode(religion, "religion", maxCat=4)
	levels(religion) <- c(levels(religion), "Tanzanian")
	religion[survey=="TZ5"] <- "Tanzanian"

	maritalStat <- tableRecode(maritalStat, "partnership", maxCat=4)
})

# HIV knowledge
Answers <- within(Answers, {
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

## response variables ##

Answers <- within(Answers, {

	# Drop excess levels; there's no single best way or place to do this
	condom <- drop.levels(condom, reorder=FALSE)

	# partnerYear (MV766B):  for this variable, it is coded for now as 0/1/2/3 where 0=no partner within the last 12 months, 1 = 1 partners and 3 = multiple partners; DK=3.

partnerYearMax <- 3
partnerLifeMax <- 6

	partnerYear <- tfun(partnerYear, partnerYearMax)
	partnerYear[grepl("Never", recentSex)] <- 0

	partnerYear <- tfun(partnerYear, partnerYearMax)
	extraPartnerYear <- as.factor(ifelse(partnerYear==0, 0, partnerYear-1))

	partnerLife <- tfun(partnerLife, partnerLifeMax)
	partnerLife <- as.factor(partnerLife)
	levels(partnerLife)

## Random factors
	# Make cluster ID into a factor!
	clusterId <- as.factor(clusterId)

})

# Calculate MC statuses:
ctable <- read.csv(grep("mcc", input_files, value=TRUE))
print(ctable)
set <- sub("[.].*", "", "RTARGET")
ind <- cut <- which(set==rownames(ctable))
cut <- ifelse(length(ind)==1, ctable$cut[[ind]], NA)
Answers$mccut <- rep(cut, nrow(Answers))
baseAge <- with(Answers, 
	ifelse(ageMC==95 | ageMC==96 | ageMC==98, 0, ageMC)
)
oldMC <- with(Answers, 
	ifelse(age-baseAge>mccut, "Old", "New")
)
Answers$MCCategory <- as.factor(with(Answers,
	ifelse(MC=="No", "No", oldMC)
))

Answers <- within(Answers, {
	region <- as.factor(paste(CC, region, sep="_"))
	clusterId <- as.factor(paste(survey, clusterId, sep="_"))
})

Answers <- within(Answers, {
		levels(region)[levels(region)=="KE_North Eastern"] <- "KE_Northeastern"
		levels(region)[levels(region)=="LS_Qacha's-Nek"] <- "LS_Qasha's Nek"
		levels(region)[levels(region)=="LS_Qacha's-Nek"] <- "LS_Qasha's Nek"
		levels(region)[levels(region)=="LS_Thaba-Tseka"] <- "LS_Thaba Tseka"
		levels(region)[levels(region)=="LS_Butha-bothe"] <- "LS_Butha-Buthe"
		levels(region)[levels(region)=="MZ_Cabo delgado"] <- "MZ_Cabo Delgado"
		levels(region)[levels(region)=="MZ_Zamb\x82zia"] <- "MZ_Zambezia"
		levels(region)[levels(region)=="MZ_Maputo provincia"] <- "MZ_Maputo Provincia"
		levels(region)[levels(region)=="MZ_Maputo cidade"] <- "MZ_Maputo Cidade"
		levels(region)[levels(region)=="RW_City of Kigali"] <- "RW_Kigali City"
		levels(region)[levels(region)=="TZ_Dar Es Salaam"] <- "TZ_Dar Es Salam"
		levels(region)[levels(region)=="TZ_Kilimanjaro"] <- "TZ_Kilmanjaro"
		levels(region)[levels(region)=="TZ_Zanzibar South"] <- "TZ_Zanziba South"
		levels(region)[levels(region)=="UG_West-Nile"] <- "UG_West Nile"
		levels(region)[levels(region)=="ZW_Matabeleland North"] <- "ZW_Matebeleland North"
		levels(region)[levels(region)=="ZW_Matabeleland South"] <- "ZW_Matebeleland South"
		levels(region)[levels(region)=="MZ_Zamb\x82zia"] <- "MZ_Zambezia"
})

# rdsave(Answers)
