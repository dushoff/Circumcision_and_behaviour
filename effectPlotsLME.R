library(lme4)
library(effects)
library(splines)

summary(mod)
effobj <- allEffects(mod=lmemod)
print(plot(effobj))