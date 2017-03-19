library(dplyr)


Country <- (ddnew4 
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
    , latex(dfill(ddnew4,"ageGroup"))
    , hline
    , "\\bf{Residence}" , spaces
    , latex(dfill(ddnew4,"urRural"))
    , hline
    , "\\bf{Education}" , spaces
    , latex(dfill(ddnew4,"edu"))
    , hline
    , "\\bf{Religion}" , spaces 
    , latex(dfill(ddnew4,"religion"))
    , hline
    , "\\bf{Marital Status}" , spaces
    , latex(dfill(ddnew4,"maritalStat"))
    , hline
    , "\\bf{Job}" , spaces
    , latex(dfill(ddnew4,"job"))
    , hline
    , "\\bf{Condom Usage at Last Sex}" , spaces
    , latex(dfill(ddnew4,"condom"))
    , hline
    , "\\bf{Non-habiting Partners}" , spaces
    , latex(dfill(ddnew4,"extraPartnerYear"))
    , hline
    , "\\bf{Circumcised}" , spaces
    , latex(dfill(ddnew4,"MC"))
    , hline
    , "\\bf{Knowledge}" , spaces
    , space , "\\bf{Condoms Protect}" , spaces
    , latex(dfill(ddnew4,"knowledgeCondomsProtect"),space=TRUE)
    , space , "\\bf{Less Partner Protect}" , spaces
    , latex(dfill(ddnew4,"knowledgeLessPartnerProtect"),space=TRUE)
    , space , "\\bf{Healthy Get Aids}" , spaces
    , latex(dfill(ddnew4,"knowledgeHealthyGetAids"),space=TRUE)
    , hline
    , "\\bf{Media}" , spaces
    , space , "\\bf{Newspaper and Magazines}" , spaces
    , latex(dfill(ddnew4,"mediaNpMg"),space=TRUE)
    , space , "\\bf{Radio}" , spaces
    , latex(dfill(ddnew4,"mediaRadio"),space=TRUE)
    , space , "\\bf{TV}" , spaces
    , latex(dfill(ddnew4,"mediaTv"),space=TRUE)
    , footer
    , file="new_table.tex")

