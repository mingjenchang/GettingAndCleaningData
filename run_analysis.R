## run_analysis.R
## Course Project for Getting and Cleaning Data

## 0. preparing data
## assuming zip file for this project has been loaded to home directory
## set working dir
setwd("~/UCI HAR Dataset")

## load files into datasets
## test files
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subjecttest <- read.table("./test/subject_test.txt")

## train files
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")

## features and activity
features <- read.table("./features.txt")
activitylabels <- read.table("./activity_labels.txt")

## add column names to each dataset
colnames(xtest) <- features[,2]
colnames(ytest) <- c("activity")
colnames(subjecttest) <- c("subject")

colnames(xtrain)<-features[,2]
colnames(ytrain)<-c("activity")
colnames(subjecttrain)<-c("subject")

## 1. Merges the training and the test sets to create one data set.
test <- cbind(subjecttest,ytest,xtest)
train <- cbind(subjecttrain,ytrain,xtrain)
mergedata <- rbind(train,test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanstd <- c(grep("mean()",features$V2,value=TRUE,fixed=TRUE),grep("std()",features$V2,value=TRUE,fixed=TRUE))
extractdata <- subset(mergedata, select = (names(mergedata) %in% c("subject","activity",meanstd)))

## 3. Uses descriptive activity names to name the activities in the data set
extractdata[["activity"]] <- as.character(extractdata[["activity"]])
extractdata[["activity"]] <- factor(extractdata[["activity"]],activitylabels[["V1"]],activitylabels[["V2"]])

## 4. Appropriately labels the data set with descriptive variable names.
## create a function to convert abbreviation to complete word as descriptive variable names
relabel <- function(x) {
        x <- sub("-std\\(\\)","StandardDeviation",x)
        x <- sub("tBody","TimeBody",x)
        x <- sub("tGravity","TimeGravity",x)
        x <- sub("fBody","FrequencyBody",x)
        x <- sub("Acc","Acceleration",x)
        x <- sub("Gyro","Gyroscopic",x)
        x <- sub("-mean\\(\\)","Mean",x)
        x <- sub("Mag","Magnitude",x)
        x <- sub("BodyBody","Body",x)
        x
}

## rename variable names
names(extractdata) <-c("subject","activity",relabel(colnames(extractdata[,-(1:2)])))

## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
tidydata <- aggregate(. ~subject + activity, data = extractdata, FUN = mean)


