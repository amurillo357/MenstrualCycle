# MenstrualCycle

This code describes and summarizes sensitivity ratio in a one month period in order to identify patterns associated with the menstrual cycle.

## Getting Started

These instructions will provide information on the packages needed to run the file “MD-SensRatio-081418.R” to analyze sensitivity ratio data.

### Prerequisites

To run the commands in this R file, be sure to have the following packages installed: lubridate, ggplot2, scales, timeSeries

These can be installed using the options “tools” -> “install packages” in the menu bar. Alternatively, the command “install.packages(“[name of package]”) can be implemented in the command window.

```
install.packages("lubridate")
install.packages("ggplot2")
install.packages("scales")
install.packages(“timeSeries”)
```

### Installing

After installing packages, use “library()” to load the packages before using the functions defined in each of the packages.

```
library(lubridate)
library(ggplot2)
library(scales)
library(timeSeries)
```


## Objectives of this R file

The R file will: 1) read data in csv format, 2) create time variables, and 3) create plots to visualize data.

### Initializing time variables to visualize data
In order to plot the time series data, the following date string can be recoded into specific days, times, week, month, or year variables.

```
# first extract the Year, month and day and reformat as Year-month-day
rawdatamarch$time_new=as.Date(rawdatamarch$dateString, "%Y-%m-%d")

# second extract the time in hours, minutes, and seconds
rawdatamarch$time_hour=substr(rawdatamarch$dateString, 12,16)

# third create a new time variables merging the date and time
rawdatamarch$newtime=paste(rawdatamarch$time_new,rawdatamarch$time_hour)

# fourth reformat and merge date and time information only
rawdatamarch$timenew = as.POSIXct(rawdatamarch$newtime, format = "%Y-%m-%d %H:%M", tz = "EST")

# create a new variable “Week” recoding the time stamps as weeks
rawdatamarch$Week=week(rawdatamarch$timenew)

# creata a new variable “Hour” recoding the time stamps by hours (on a 24 hour interval)
rawdatamarch$Hour = hour(rawdatamarch$timenew)
```

### Outcomes/Results using ggplot  

These initial steps are needed in order to plot the data. Sensitivity ratio can be plotted yearly, monthly, weekly, or daily.

```
#plot of the whole month and color coded by day
ggplot(data = rawdatamarch, aes(x = timenew, y = sensitivityRatio, color = time_day)) +
  geom_line() + geom_point() +
  labs(title = "March menstrual cycle dates were 3/8 to 3/13 \n", x = "Day", y = "Sensitivity Ratio", color = "Day\n") + 
  theme_bw()


#plot of the whole month split by week and color coded by week
ggplot(data = rawdatamarch, aes(x = timenew, y = sensitivityRatio, color = Week)) + 
  geom_path() + scale_x_datetime(breaks=date_breaks("1 week"), labels=date_format("%d")) +
  facet_grid(Week~.) +
  theme(legend.position="none") +
  labs(title = "March menstrual cycle dates were 3/8 to 3/13 \n", x = "Day", y = "Sensitivity Ratio", color = "Week\n") + 
  theme_bw()


#plot of the hours for each day in specific weeks during the menstrual cycle
rawdataweek10to11=rawdatamarch[rawdatamarch$Week == 10 | rawdatamarch$Week == 11, ]
ggplot(rawdataweek10to11, aes(x=same_day(timenew), y=sensitivityRatio, color = as.factor(day(timenew)))) + 
  geom_line()  + 
  scale_x_datetime(date_breaks = "2 hour", date_labels="%H") +
  labs(title = "March menstrual cycle dates were in days 8 to 13 \n", x = "Hour", y = "Sensitivity Ratio", color = "Day\n") + 
  theme_bw()

```
