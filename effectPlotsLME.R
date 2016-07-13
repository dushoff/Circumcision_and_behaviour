library(lme4)
library(effects)
library(splines)

summary(lmemod)
effobj <- allEffects(mod=lmemod)
# print(plot(effobj))
for(eff in effobj){
	print(plot(eff))
}
