#インストールしてなかったら、インストールする
#install.packages("httr")
#install.packages("Rook")
#install.packages("rjson")
#install.packages("ggplot2")
library(Rook)
library(httr)
library(rjson)
library(ggplot2)

#OAuth認証のための設定
token_url = "http://api.fitbit.com/oauth/request_token"
access_url = "http://api.fitbit.com/oauth/access_token"
auth_url = "http://www.fitbit.com/oauth/authorize"
key = "ckey"
secret = "secret"
fbr <- oauth_app('YourAppName',key,secret)


fitbit <- oauth_endpoint(token_url,auth_url,access_url)
token <- oauth1.0_token(fitbit,fbr)
sig <- sign_oauth1.0(fbr,
                     token=token$oauth_token,
                     token_secret=token$oauth_token_secret
)
sig <- sign_oauth1.0(fbr, token=token$oauth_token, token_secret=token$oauth_token_secret)

# get all step data from my first day of use to the current date:
steps = GET("http://api.fitbit.com/1/user/-/activities/steps/date/2013-12-31/today.json",sig)
rawData <- steps[[6]]
charData <- rawToChar(rawData, multiple = FALSE)
parseData <- fromJSON(charData, method = 'C')


#dataフレームの作成
date <- c();
step <- c();
i <- 1;
for(i in i:length(parseData$`activities-steps`)){
  date <- c(date,parseData$`activities-steps`[[i]]$dateTime)
  step <- c(step,parseData$`activities-steps`[[i]]$value)
  d <- cbind(date,step)
}
#ggplotで描画
qplot(date, step, geom="bar", stat="identity", fill = factor(date))
