options(width=200)
library(brms)
library(splines)

modAns <- model.frame(
  extraPartnerYear ~ age + wealth + religion + edu + urRural + job + maritalStat +
    media + knowledge + MC + period + clusterId + CC,
  data=Answers, na.action=na.exclude, drop.unused.levels=TRUE
)

## We can't let R use the terms from this object instead of working it out from the model!
attr(modAns, "terms") <- NULL

mod <- brm(as.numeric(extraPartnerYear) ~
              ns(age, 4) + ns(wealth,3)
            + religion + edu + urRural + job + maritalStat
            + media + knowledge + MC*period + (1|clusterId)+ (1 + media|CC),
            data=modAns, family=cumulative())

print(summary(mod))

# rdsave(mod, modAns)
