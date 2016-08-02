library(ordinal)
library(effects)
library(splines)

summary(mod)
effobj <- allEffects(mod=mod)
for(eff in effobj){
	print(plot(eff))
}

