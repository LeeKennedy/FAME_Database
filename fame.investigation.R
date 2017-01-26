# Clean up ---------------------------------------------------------------
rm(list=ls())

# Packages ---------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)
library(readr)
library(lubridate)

# data in ----------------------------------------------------------------
fame.in <- read_csv("~/Documents/GitHub/FAME_Data/MEAT_2015a.csv")
fame.in <- fame.in[,-3]
colnames(fame.in)[1] <- "SAMPLE_NUMBER"

# Filter -----------------------------------------------------------------

fame.in2 <- fame.in %>% 
        filter(!grepl("trans", REPORTED_NAME)) %>% 
        filter(grepl("^C", REPORTED_NAME))

fame.in2$REPORTED_NAME<- sapply(fame.in2$REPORTED_NAME, gsub, pattern = "_", replacement = ".", fixed = FALSE)
fame.in2$REPORTED_NAME<- sapply(fame.in2$REPORTED_NAME, gsub, pattern = " ", replacement = "", fixed = FALSE)

unique(fame.in2$REPORTED_NAME)

FA <- c("C:4.0", "C:6.0","C:8.0","C:10.0","C:12.0","C:14.0","C:16.0","C:16.1w7cis","C:18.0","C:20.0","C:22.0","C:24.0","C:18.3w6cis","C:18.3w3cis","C:22.1w9cis", "C:18.3w6cis","C:18.2w6cis","C:18.1cis")

fame.in3 <- fame.in2 %>% 
        filter(REPORTED_NAME %in% FA)
fame.in3$ENTRY <- as.numeric(fame.in3$ENTRY)

fame.library <- spread(fame.in3, REPORTED_NAME, ENTRY)
fame.library$LOGIN_DATE <- dmy_hm(fame.library$LOGIN_DATE)

fame.library <- fame.library %>% 
        mutate(fat = rowSums(fame.library[,c(8:22)]))

# Load database -------------------------------------------------------
fame.db <- read_csv("~/Documents/GitHub/FAME_Data/Database.csv")
fame.db <- fame.db[,-1]
fame.library <- rbind(fame.library, fame.db)
write.csv(fame.library, "~/Documents/GitHub/FAME_Data/Database.csv")
