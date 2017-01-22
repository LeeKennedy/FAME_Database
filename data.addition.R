# libraries to use ----------------------------------------------------------------------
library(lubridate)
library(dplyr)

# Note : lower case ----------------------------------------------------------------
dataset <- c("melbourne", "kerang")

for (i in 1:2) {

# Import data ----------------------------------------------------------------------
new.data <- read.csv(paste("~/Desktop/In Tray/", dataset[i],".csv", sep=""), as.is=TRUE, header=FALSE,skip=6)
new.data <- new.data[,c(2:5)]

data <- read.csv(paste("~/Documents/GitHub/Climate/data/", dataset[i],".csv",sep=""), as.is=TRUE, header=TRUE)

j <- nrow(data)
station <- data$Station.Code[j]
p.code <- data$Product.code[j]
new.data$Product.code <- p.code
new.data$Station.Code <- station

# Separate out date ---------------------------------------------------------------
new.data <- new.data %>%
        mutate(Year = year(ymd(V2)),
               Month = month(ymd(V2)),
               Day = day(ymd(V2)))

# Rename & reorder columns --------------------------------------------------------
colnames(new.data)[2] <- "Min"
colnames(new.data)[3] <- "Max"
colnames(new.data)[4] <- "Rain"
new.data$Item <- 1
new.data$X <- 1
new.data <- new.data[, c(11,10,5:9,3,2,4)]

# Combine & Save ------------------------------------------------------------------
combined <- rbind(data, new.data)
combined$Item <- as.numeric(row.names(combined))
combined <- combined[,-1]

write.csv(combined, paste("~/Documents/GitHub/Climate/data/", dataset[i],".csv", sep=""))
}