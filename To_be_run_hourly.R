
install.packages("data.table")
library(data.table)
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

devtools::install_github("mkearney/rtweet")
library(rtweet)
args = commandArgs(trailingOnly=TRUE)

api_key <- "BDAXuqA2M4Ro6j4vE2p5BSDbv"
api_secret_key <- "wIyeHYJtfqlnGE1H3wjtH1FlP5bXVliHubRkBGEWWRPEtZ6XeF"
access_token <- args[1]
access_token_secret <- args[2]

token <- create_token(
  app = "Data_Collect_1234567890",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)


data <- search_tweets(q="#rstats", since=Sys.Date()-1, retryonratelimit = TRUE,include_rts = TRUE)
sel <- data[0,]
for (i in 1:nrow(data)){
  if((toString(format(as.POSIXct(data$created_at[i]),"%d")))==(toString(format(as.POSIXct(Sys.time()),"%d"))) || (toString(format(as.POSIXct(data$created_at[i]),"%H"))) > (toString(format(as.POSIXct(Sys.time()),"%H")))){
    sel[nrow(sel)+1,]=data[i,]
  }
}

save_as_csv(sel, "data_for_today.csv", prepend_ids = FALSE, na = "", fileEncoding = "UTF-8")


tweets <- sel[sel$is_retweet == FALSE,]
retweets <- sel[sel$is_retweet == TRUE,]

tweet1 <- as.data.table(tweets)
retweet1 <- as.data.table(retweets)

tweet1[,hours:=format(as.POSIXct(created_at),"%d-%m %H:00")]
tweet2 <- data.frame(tweet1[,.N,by=hours])
tweet2 <- tweet2[order(tweet2$hours),]

retweet1[,hours:=format(as.POSIXct(created_at),"%d-%m %H:00")]
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

sel <- read.csv('data_for_today.csv')
hashtags <- as.data.frame(table(as.data.frame(unlist(sel$hashtags))))
orderedhashtags <- hashtags[order(-hashtags$Freq),]
top20_hashtags <- orderedhashtags[3:22,]

tweeters <- as.data.frame(table(sel$screen_name))
orderedtweeters <- tweeters[order(-tweeters$Freq),]
top20_tweeters <- orderedtweeters[1:20,]

sel_like <- sel[order(-sel$favorite_count),]
sel_like <- sel_like[1:10,]
text <- sel_like$text
top10_tweets_like <- text

sel_retweet <- sel[order(-sel$retweet_count),]
sel_like <- sel_like[1:10,]
text <- sel_like$text
top10_tweets_retweet <- text


stats <- data.frame(total_tweets_today=nrow(sel),average_tweets_per_hour=round(nrow(sel)/24,0),tweeters_today=length(unique(sel[["user_id"]])),total_likes_today=sum(sel$favorite_count))
data <- jsonlite::toJSON(list(summary = stats,top20_hashtags =top20_hashtags , top20_tweeters = top20_tweeters, top10_tweets_like  = top10_tweets_like , top10_tweets_retweet  = top10_tweets_retweet ), auto_unbox = FALSE, pretty = TRUE,force=TRUE)
writeLines(data, "stats.json")
