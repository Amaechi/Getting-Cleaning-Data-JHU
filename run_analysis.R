# The purpose of this project is to demonstrate the ability to collect, work 
# with, and clean a data set that can be used for later analysis. First load
# required library's
library(tidyverse)
library(data.table)

# Get relevant link in order to download dataset file to working directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download file to working directory and unzip
download.file(fileUrl, destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# Physically review file/s to get an overview of structure and content
# The unzipped UCI HAR Dataset folder contains 4 text files with further "test" 
# and "train" folders, which contain further text files. The "inertial signals"
# folders will be ignored.

# The 3 text files in "test" folder (subject_test, y_test and x_test) and the 3
# text files in the "train" folder need to be extracted and merged, along with
# the fetures and activity labels.
# Read in the "test" folder files
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subjectId"))
xTest <- read.table("UCI HAR Dataset/test/X_test.txt") 
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activityId"))

# Read in the "train" folder files
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subjectId"))
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt") 
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("activityId"))

# Read in the "features" file (but not the "features info" file)
features <- read.table("UCI HAR Dataset/features.txt")

# Read in the "activity_labels" file
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityType"))

# Assign column names to xTest and xTrain from features values
colnames(xTest) <- features[,2]
colnames(xTrain) <- features[,2]

# Merge all x and y test and train data
mergedTest <- cbind(xTest, yTest, subjectTest)
mergedTrain <- cbind(xTrain, yTrain, subjectTrain)
mergedTestTrain <- rbind(mergedTest, mergedTrain)

# Extract measurements on the mean and standard deviation for each measurement
# Create vector containing mean and standard deviation
meanSD <- (grepl("activityId", colnames(mergedTestTrain)) | 
               grepl("subjectId", colnames(mergedTestTrain)) | 
               grepl("mean..", colnames(mergedTestTrain)) | 
               grepl("std..", colnames(mergedTestTrain)))
setmeanSD <- mergedTestTrain[, meanSD == TRUE]

# Set activity names
setActivityNames <- merge(setmeanSD, activityLabels, by = "activityId", all.x = TRUE)

# Introduce descriptive variable names replacing abbreviated names
names(setActivityNames)<-gsub("^t", "time", names(setActivityNames))
names(setActivityNames)<-gsub("^f", "frequency", names(setActivityNames))
names(setActivityNames)<-gsub("Acc", "Accelerometer", names(setActivityNames))
names(setActivityNames)<-gsub("Gyro", "Gyroscope", names(setActivityNames))
names(setActivityNames)<-gsub("Mag", "Magnitude", names(setActivityNames))
names(setActivityNames)<-gsub("BodyBody", "Body", names(setActivityNames))

# create a second, independent tidy data set with the average of each variable 
# for each activity and each subject
tidyDataSet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$subjectId, tidyDataSet$activityId),]

# Write to file
write.table(tidyDataSet, "tidyDataSet.txt", row.name=FALSE)

