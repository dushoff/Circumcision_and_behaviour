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