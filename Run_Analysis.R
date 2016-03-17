setwd("C:/Users/zambezis/Desktop/Data Science Coursera/Gatting clean data")
library(data.table)
library(dplyr)
library(tidyr)
##Get  Data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
Subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
Subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
##Tidy features data
features <- features %>% rename(Feature = V2) %>% select(-V1)
features$Feature <- as.character(as.factor(features$Feature))
features$Feature <- gsub("\\(", "",features$Feature)
features$Feature <- gsub("\\)", "",features$Feature)
features$Feature <- gsub("mean", "Mean",features$Feature)
features$Feature <- gsub("std", "Std",features$Feature)
#Set column names for test data
colnames(X_test) <- features$Feature
##set column names for train data
colnames(X_train) <- features$Feature
##Merge data sets test and train
X_data <- rbind(X_test, X_train)
Subject <- rbind(Subject_test,Subject_train)
X_data <- cbind(X_data, Subject$V1)
names(X_data)[names(X_data) == "Subject$V1"] <- "SubjectID"
##select mean data coloumns
my_data_mean <- X_data[,c(grep("Mean",features$Feature))]
names <- colnames(my_data_mean)
my_data_mean2 <- my_data_mean[,-c(grep("MeanFreq", names))]
##select std data coloumns
my_data_std <- X_data[,c(grep("Std",features$Feature))]
##Bind Coloumns
my_data_mean_std <- cbind(my_data_mean2,my_data_std)
##name activities in dataset
Activities <- rbind(Y_test, Y_train)
library(plyr)
merge_activities_data <- join(Activities,activity_labels)
X_data <- cbind(X_data, merge_activities_data)
names(X_data)[names(X_data) == "V1"] <- "ActivityID"
names(X_data)[names(X_data) == "V2"] <- "Activity"
## write tidy data table
write.table(X_data,"tidy_data.txt")
library(dplyr)
#get average of each activity
avg_activity <- X_data %>% slice_rows("Activity") %>%dmap(mean)
avg_subject <-X_data %>% slice_rows("SubjectID") %>%dmap(mean)