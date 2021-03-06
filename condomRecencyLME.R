options(width=200)
# library(coefplot)
library(lme4)
library(splines)

Answers <-subset(Answers, period=="new")

modAns <- model.frame(
  condom ~  survey + age+wealth+religion+edu+urRural+job+maritalStat+
    media + knowledge + MCCategory + clusterId,
  data=Answers, na.action=na.exclude, drop.unused.levels=TRUE
)

## We can't let R use the terms from this object instead of working it out from the model!
attr(modAns, "terms") <- NULL 

lmemod <- glmer(condom ~ 
                  ns(age, 4) + ns(wealth,3) 
                + religion + edu + urRural + job + maritalStat 
                + media + knowledge + MCCategory + (1|clusterId) 
                + (1 + media|survey)
                , data=modAns
                , family = "binomial")

print(summary(lmemod))

# rdsave(lmemod, modAns)
