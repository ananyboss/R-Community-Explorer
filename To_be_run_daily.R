## install devtools package if it's not already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## install dev version of rtweet from github
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


data <- search_tweets(q="#rstats", since=Sys.Date()-1, until=Sys.Date(),retryonratelimit = TRUE,include_rts = TRUE)
dir.create(file.path(getwd(),'/dailies/'))
setwd(file.path(getwd(),'/dailies/'))
dir1<-toString(format(Sys.Date()-1, "%Y"))
dir.create(file.path(getwd(),dir1))
setwd(file.path(getwd(),dir1))
dir2<-toString(format(Sys.Date()-1, "%b"))
dir.create(file.path(getwd(),dir2))
setwd(file.path(getwd(),dir2))
file_pref <- toString(format(Sys.Date()-1, "%d"))
dirf<-paste(toString(format(Sys.Date()-1, "%Y")),"-",toString(format(Sys.Date()-1, "%b")),"-",file_pref,".csv",sep="")
save_as_csv(data, dirf, prepend_ids = FALSE, na = "", fileEncoding = "UTF-8")
setwd("..")
setwd("..")
setwd("..")

