library(ordinal)

bet <- mod$beta
int <- grep("MCYes:", names(bet), value=TRUE)
b <- bet[[int]]
se <- sqrt(vcov(mod)[[int, int]])

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

rawrange <- rawcounterfactual+brange

counterfactual <- ordTrans(rawcounterfactual, mod$alpha)
estRange <- ordTrans(rawrange, mod$alpha)


if(unlist(strsplit(rtargetname,"[.]")) == "condomStatus_int"){
  print(brange)
  print("Inverting odds ratio (since periodnew was the baseline")
  print(exp(-brange))
}

if(unlist(strsplit(rtargetname,"[.]")) == "partnerYearStatus_int"){
  print(counterfactual)
  print(estRange)
  print(estRange - counterfactual)
}
