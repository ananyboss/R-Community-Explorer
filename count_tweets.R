data <- read.csv(paste(toString(format(Sys.Date()-1, "%Y")),"/",toString(format(Sys.Date()-1, "%b")),"/Tweet_data_",toString(format(Sys.Date()-1, "%d")),".csv",sep=""))
arr<-data$is_retweet
cnt_tweet <- 0
cnt_re <- 0
for (ele in arr){
  if(ele==TRUE){
    cnt_re=cnt_re+1
  }
  else{
    cnt_tweet=cnt_tweet+1
  }
}
f='count_tweets.csv'
cat(paste(toString(format(Sys.Date()-1, "%d")),toString(format(Sys.Date()-1, "%b")),toString(format(Sys.Date()-1, "%Y")),sep="-"),file=f,append=TRUE)
cat(",",file=f,append=TRUE)
cat(cnt_tweet,file=f,append=TRUE)
cat(",",file=f,append=TRUE)
cat(cnt_re,file=f,append=TRUE)
cat("\n",file=f,append=TRUE)
