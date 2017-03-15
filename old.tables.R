options(width=400)
library(dplyr)
dfill <- function(dat,x){
  return(dat
  %>% filter(Category==x)
  %>% filter(Category2!="Total")
  %>% select(-c(Total,Category))
  )
}

latex <- function(x,spaces=FALSE){
  n <- nrow(x)
  string <- knitr:::kable(x,format="latex",digits=3,align="l",col.names = NULL,booktabs=FALSE)
  tab <- unlist(strsplit(string[1],"\n"))
  if(spaces){
    return(paste("\\hspace{0.2in}",tab[2+2*1:n]))
  }
  return(tab[2+2*1:n])
}

header <- c("
\\documentclass{article}
\\usepackage[top=0.01in,left=1in]{geometry}

\\begin{document}
\\begin{table}{}
\\tiny{
\\begin{tabular}{|lrrrrrrrrrr|r|}
\\hline
\\bf{Country} & KE & LS & MW & MZ & NM & RW & TZ & UG & ZM & ZW & Total \\\\
\\hline
\\bf{Survey Year} & 2003 & 2004 & 2004 & 2003 & 2006-7 & 2005 & 2004-5 & 2006 & 2007 & 2005-6 & \\\\
")

footer <- c("
\\hline
\\end{tabular}
}
\\end{table}
\\end{document}
")

space <- c("
\\hspace{0.2in}
")
hline <- c("
\\hline
")  

spaces <- c("&&&&&&&&&&&\\\\")

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

