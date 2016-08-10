library(ordinal)

bet <- mod$beta
int <- grep("MCYes:", names(bet), value=TRUE)
b <- bet[[int]]
se <- sqrt(vcov(mod)[[int, int]])
print(c(b=b, se=se))

brange <- c(
  lwr=b+se*qnorm(0.025),
  fit=b,
  upr=b+se*qnorm(0.975)
)

# mcs
# ordTrans(mcs$rawfit, mod$alpha)

rawcounterfactual <- with(mcs, 
                          rawfit[[2]]+rawfit[[3]]-rawfit[[1]]
)

# Interaction should match model
print(c(interaction=mcs$rawfit[[4]]-rawcounterfactual))

rawrange <- rawcounterfactual+brange

counterfactual <- ordTrans(rawcounterfactual, mod$alpha)
estRange <- ordTrans(rawrange, mod$alpha)

print(counterfactual)
print(estRange)
