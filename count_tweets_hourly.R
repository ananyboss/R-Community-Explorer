install.packages("data.table")
library(data.table)


dat <- read.csv("https://raw.githubusercontent.com/ananyboss/R-Community-Explorer/master/data_for_today.csv")
tweets <- dat[dat$is_retweet == FALSE,]
retweets <- dat[dat$is_retweet == TRUE,]

tweet1 <- as.data.table(tweets)
retweet1 <- as.data.table(retweets)

tweet1[,hours:=format(as.POSIXct(created_at),"%H:00")]
tweet2 <- data.frame(tweet1[,.N,by=hours])
tweet2 <- tweet2[order(tweet2$hours),]

retweet1[,hours:=format(as.POSIXct(created_at),"%H:00")]
retweet2 <- data.frame(retweet1[,.N,by=hours])
retweet2 <- retweet2[order(retweet2$hours),]

if(nrow(retweet2)>nrow(tweet2)){
  temp <- c(retweet2$hours[nrow(retweet2)],0)
  tweet2 <- rbind(tweet2,temp)
}

if(nrow(tweet2)>nrow(retweet2)){
  temp <- c(tweet2$hours[nrow(tweet2)],0)
  retweet2 <- rbind(retweet2,temp)
}

fulldata <- cbind(tweet2, retweet2$N)
names(fulldata) <- c("Hour","Tweets", "Retweets")
write.csv(fulldata,'count_tweets_hourly.csv',row.names=FALSE)


prev_date <- Sys.Date()-2
year <- toString(format(prev_date,"%Y"))
month <- toString(format(prev_date,"%b"))
day <- toString(format(prev_date,"%Y-%b-%d"))
prev_data <- read.csv(paste("https://raw.githubusercontent.com/ananyboss/R-Community-Explorer/master/dailies/",year,"/",month,"/",day,".csv",sep=""))

sel <- prev_data[0,]
for (i in 1:nrow(prev_data)){
  if((toString(format(as.POSIXct(prev_data$created_at[i]),"%H"))) >= (strsplit(tweet2$hours[nrow(tweet2)],":")[[1]][1])){
    sel[nrow(sel)+1,]=prev_data[i,]
  }
}
# prev_date_tweets <- subset(prev_data, prev_data(toString(format(as.POSIXct(prev_data$created_at[i]),"%H"))) >= (strsplit(tweet2$hours[nrow(tweet2)],":")[[1]][1]))
sel <- rbind(sel,dat)

f="stats.txt"
if(file.exists(f)){
  file.remove(f)
}
f="stats.txt"
cat("Total tweets today: ",file=f,append=TRUE)
cat(nrow(sel),file=f,append=TRUE)
cat("\nAverage Tweets Per Hour: ",file=f,append=TRUE)
cat(round(nrow(sel)/24,0),file=f,append=TRUE)
cat("\nTweeters today are: ",file=f,append=TRUE)
cat(length(unique(sel[["user_id"]])),file=f,append=TRUE)
cat("\nTotal likes today: ",file=f,append=TRUE)
cat(sum(sel$favorite_count),file=f,append=TRUE)
cat("\n",file=f,append=TRUE)

cat("Top 10 tweets today based on likes: \n",file=f,append=TRUE)
sel_like <- sel[order(-sel$favorite_count),]
for(i in 1:10){
  cat(i,file=f,append=TRUE)
  cat(" ",file=f,append=TRUE)
  cat(toString(sel_like$text[i]),file=f,append=TRUE)
  cat("\n",file=f,append=TRUE)
}

cat("Top 10 tweets today based on retweets: \n",file=f,append=TRUE)
sel_like <- sel[order(-sel$retweet_count),]
for(i in 1:10){
  cat(i,file=f,append=TRUE)
  cat(" ",file=f,append=TRUE)
  cat(toString(sel_like$text[i]),file=f,append=TRUE)
  cat("\n",file=f,append=TRUE)
}
