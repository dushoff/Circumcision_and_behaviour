library(dplyr)


Country <- (ddold4 
  %>% filter(Category2=="Total") 
  %>% filter(row_number()==1)
  %>% select(-c(Category,Category2,totalper))
)


cat(header
  , "\\bf{Sample Size} &" , latex(Country) ## sample size 
  , hline
  , "\\bf{Category (in percentage)}", spaces
  , hline
  , "\\bf{Age Group}" , spaces
  , latex(dfill(ddold4,"ageGroup"))
  , hline
  , "\\bf{Residence}" , spaces
  , latex(dfill(ddold4,"urRural"))
  , hline
  , "\\bf{Education}" , spaces
  , latex(dfill(ddold4,"edu"))
  , hline
  , "\\bf{Religion}" , spaces 
  , latex(dfill(ddold4,"religion"))
  , hline
  , "\\bf{Marital Status}" , spaces
  , latex(dfill(ddold4,"maritalStat"))
  , hline
  , "\\bf{Job}" , spaces
  , latex(dfill(ddold4,"job"))
  , hline
  , "\\bf{Condom Usage at Last Sex}" , spaces
  , latex(dfill(ddold4,"condom"))
  , hline
  , "\\bf{Non-habiting Partners}" , spaces
  , latex(dfill(ddold4,"extraPartnerYear"))
  , hline
  , "\\bf{Circumcised}" , spaces
  , latex(dfill(ddold4,"MC"))
  , hline
  , "\\bf{Knowledge}" , spaces
  , space , "\\bf{Condoms Protect}" , spaces
  , latex(dfill(ddold4,"knowledgeCondomsProtect"),space=TRUE)
  , space , "\\bf{Less Partner Protect}" , spaces
  , latex(dfill(ddold4,"knowledgeLessPartnerProtect"),space=TRUE)
  , space , "\\bf{Healthy Get Aids}" , spaces
  , latex(dfill(ddold4,"knowledgeHealthyGetAids"),space=TRUE)
  , hline
  , "\\bf{Media}" , spaces
  , space , "\\bf{Newspaper and Magazines}" , spaces
  , latex(dfill(ddold4,"mediaNpMg"),space=TRUE)
  , space , "\\bf{Radio}" , spaces
  , latex(dfill(ddold4,"mediaRadio"),space=TRUE)
  , space , "\\bf{TV}" , spaces
  , latex(dfill(ddold4,"mediaTv"),space=TRUE)
  , footer
  , file="old_table.tex")

