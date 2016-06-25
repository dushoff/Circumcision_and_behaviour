options(width=200)
library(splines)
library(ordinal)

Answers <-subset(Answers, period=="new")

modAns <- model.frame(
	partnerLife ~ age + wealth + religion + edu + urRural + job + maritalStat + media + knowledge + MCCategory + clusterId,
	data=Answers, na.action=na.exclude, drop.unused.levels=TRUE
)

## We can't let R use the terms from this object instead of working it out from the model!
attr(modAns, "terms") <- NULL 
 
mod <- clmm(partnerLife ~ 
ns(age, 4) + ns(wealth,3)
+ religion + edu + urRural + job + maritalStat
+ media + knowledge + MCCategory + (1|clusterId),
data=modAns)
 
# rdsave(mod, modAns)

