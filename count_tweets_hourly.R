install.packages("lubridate")
library(lubridate)
tt <- as.POSIXct(paste(toString(format(Sys.Date(), "%Y")),"-",toString(format(Sys.Date(), "%m")),"-",toString(format(Sys.Date(), "%d"))," 00:00:00",sep=""))
tts <- seq(tt, by = "hours", length = 25)
f='count_tweets_hourly.csv'
if (file.exists(f)){
  file.remove(f)
}
for (tim in 2:25){
  interv <- interval(tts[tim-1],tts[tim])
  data <- read.csv("data_for_today.csv")
  cnt_tweet <- 0
  cnt_re <- 0
  for (i in 1:nrow(data)){
    if(as.POSIXct(data$created_at[i]) %within% interv){
      if(data$is_retweet[i]==TRUE){
        cnt_re=cnt_re+1
      }
      else{
        cnt_tweet=cnt_tweet+1
      }
    }
  }
  f='count_tweets_hourly.csv'
  cat(toString(format(tts[tim], "%Y-%m-%d %H:%M:%OS")),file=f,append=TRUE)
  cat(",",file=f,append=TRUE)
  cat(cnt_tweet,file=f,append=TRUE)
  cat(",",file=f,append=TRUE)
  cat(cnt_re,file=f,append=TRUE)
  cat("\n",file=f,append=TRUE)
}
