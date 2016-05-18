library(plyr)

Answers <- envir_list[[1]][["Answers"]]
for(env in envir_list[-1]){
	Answers <- rbind(Answers, env[["Answers"]])
}


Answers <- ddply(Answers, .(CC), function(df){
	df$period <- as.factor(
		ifelse(df$recode>mean(df$recode), "new", "old")
	)
	return(df)
})

print(summary(Answers))
