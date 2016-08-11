library(ordinal)
library(splines)
library(ggplot2)

mcs <- ff(mod, modAns, "MC", "period", isolate=TRUE)

# Use the same width for error bars and for dodge offset
ww <- 0.15

g <- ggplot(mcs,
            aes(x=period, y=(fit), color=MC, group=MC)
) +ylab("response")

ge <- (g + 
         geom_errorbar(
           aes(ymin=(lwr), ymax=(upr)), 
           width=ww, position = position_dodge(width=ww)
         )
       + geom_point(position = position_dodge(width=ww))
       + geom_line(position = position_dodge(width=ww))
)
print(ge)

#rdsave(mcs, mod, modAns)
