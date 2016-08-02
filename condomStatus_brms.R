options(width=200)
library(brms)
library(splines)

# Lesotho is missing one set of condom responses, so we need to exclude the whole country
Answers <- subset(Answers, CC != "LS")

modAns <- model.frame(
  condom ~ 
    age + wealth + religion + edu + urRural + job + maritalStat 
  + media + knowledge + MC + period + clusterId + CC, 
  data=Answers, na.action=na.exclude, drop.unused.levels=TRUE
)

## We can't let R use the terms from this object instead of working it out from the model!
attr(modAns, "terms") <- NULL 

mod <- brm(as.numeric(condom) ~ 
              ns(age, 4) + ns(wealth,3) 
            + religion + edu + urRural + job + maritalStat 
            + media + knowledge + MC*period + (1|clusterId) 
            + (1 + media|CC)
            , data=modAns
            , family = cumulative()
)

print(summary(mod))

# rdsave(mod, modAns)
