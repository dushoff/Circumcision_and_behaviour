library(dplyr)

Answers <- (Answers
	%>% mutate(religion = factor(religion,levels=c("Catholic/Orthodox","Other Christian","Muslim","None/Other","Tanzanian"))
	, maritalStat = factor(maritalStat,levels=c("Never","Married","Partnered","Separated","Widowed")
									, labels=c("Never Unioned", "Married", "Partnered", "Separated", "Widowed")
									)
	, MCCategory = factor(MCCategory,levels=c("No","Old","New")) 
	)
)

summary(Answers)
