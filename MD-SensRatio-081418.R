##############################################################################
# MD-SensRatio-08142018.R
#
# menstrual cycle data of one patient of March, April, May, and June
# this code is used to analyze the SensRatio data for ID XXXXXX
# 
#
# Created on July 26, 2018
# Last Updated on August 14, 2018
#
# By Anarina Murillo (amurillo@uab.edu)
#
##############################################################################

library(lubridate)
library(ggplot2)
library(scales)

#########################################
#              CLEAN DATA               #
#########################################
#-------read all data
rawdatamarch.unedited = read.csv("/Users/rina/Dropbox/Github-amurillo357/Menstrual-Cycle/isf-2018-03-copy3.csv")

#-------create subset of data with first readings
rawdatamarch = rawdatamarch.unedited

#########################################
#        CREATE TIME VARIABLES          #
#########################################
#---------March
rawdatamarch$time_new=as.Date(rawdatamarch$dateString, "%Y-%m-%d")
rawdatamarch$time_hour=substr(rawdatamarch$dateString, 12,16)
rawdatamarch$time_day=substr(rawdatamarch$time_new, 9,10)
rawdatamarch$newtime=paste(rawdatamarch$time_new,rawdatamarch$time_hour)
rawdatamarch$timenew = as.POSIXct(rawdatamarch$newtime, format = "%Y-%m-%d %H:%M", tz = "EST")
rawdatamarch$Week=week(rawdatamarch$timenew)
rawdatamarch$Day=wday(rawdatamarch$timenew)
rawdatamarch$Hour = hour(rawdatamarch$timenew)

#########################################
#        CREATE PLOTS                   #
#########################################
#---------March
par(mfrow=c(2,1))
plot(rawdatamarch$timenew, rawdatamarch$sensitivityRatio, type = "l",main="Monthly - March",xlab="Time (Days)",ylab="Sensitivity Ratio",lwd=2,col=2)
# now label every hour on the time axis
plot(rawdatamarch$timenew, rawdatamarch$sensitivityRatio, type = "l", xaxt = "n",main="Monthly - March",xlab="Time (Hours)",ylab="Sensitivity Ratio",lwd=2,col=4)
r <- as.POSIXct(round(range(rawdatamarch$timenew), "hours")) #match.arg(units) : 'arg' should be one of “secs”, “mins”, “hours”, “days”
axis.POSIXct(1, at = seq(r[1], r[2], by = "hours"), format = "%H")

#--whole month and color coded by day
ggplot(data = rawdatamarch, aes(x = timenew, y = sensitivityRatio, color = time_day)) +
  geom_line() + geom_point() +
  labs(title = "March menstrual cycle dates were 3/8 to 3/13 \n", x = "Day", y = "Sensitivity Ratio", color = "Day\n") + 
  theme_bw()

#--whole month and color coded by week
ggplot(data = rawdatamarch, aes(x = timenew, y = sensitivityRatio, group=Week, color = Week)) + 
  geom_path() + geom_point() + scale_x_datetime(breaks=date_breaks("1 week")) +
  labs(title = "March menstrual cycle dates were 3/8 to 3/13 \n", x = "Day", y = "Sensitivity Ratio", color = "Week\n") + 
  theme_bw()

#--split by week and color coded by week
ggplot(data = rawdatamarch, aes(x = timenew, y = sensitivityRatio, color = Week)) + 
  geom_path() + scale_x_datetime(breaks=date_breaks("1 week"), labels=date_format("%d")) +
  facet_grid(Week~.) +
  theme(legend.position="none") +
  labs(title = "March menstrual cycle dates were 3/8 to 3/13 \n", x = "Day", y = "Sensitivity Ratio", color = "Week\n") + 
  theme_bw()

#--overlay each week
same_week <- function(x) {
  week(x) <- 20
  x
}

ggplot(rawdatamarch, aes(x=same_week(timenew), y=sensitivityRatio, color = as.factor(week(timenew)))) + 
  geom_line()  + 
  scale_x_datetime(date_breaks = "1 day", date_labels="%d") +
  labs(title = "March menstrual cycle dates were in week 10 \n", x = "Day", y = "Sensitivity Ratio", color = "Week\n") + 
  theme_bw()

#--overlay each day
same_day <- function(x) {
  day(x) <- 31
  x
}

ggplot(rawdatamarch, aes(x=same_day(timenew), y=sensitivityRatio, color = as.factor(day(timenew)))) + 
  geom_line()  + 
  scale_x_datetime(date_breaks = "2 hour", date_labels="%H") +
  labs(title = "March menstrual cycle dates were in days 8 to 13 \n", x = "Day", y = "Sensitivity Ratio", color = "Day\n") + 
  theme_bw()

#--hours for each day in specific week
rawdataweek10to11=rawdatamarch[rawdatamarch$Week == 10 | rawdatamarch$Week == 11, ]
ggplot(rawdataweek10to11, aes(x=same_day(timenew), y=sensitivityRatio, color = as.factor(day(timenew)))) + 
  geom_line()  + 
  scale_x_datetime(date_breaks = "2 hour", date_labels="%H") +
  labs(title = "March menstrual cycle dates were in days 8 to 13 \n", x = "Hour", y = "Sensitivity Ratio", color = "Day\n") + 
  theme_bw()
