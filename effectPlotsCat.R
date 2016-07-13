library(ordinal)
library(effects)
library(splines)

summary(mod)
effobj <- allEffects(mod=mod)
print(plot(effobj))