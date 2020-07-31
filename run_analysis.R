# Getting and Cleaning Data Project 
# 
# This project is part of John Hopkins Coursera course in Data Science
#
# It should:
#
# 1. Merge data sets to create one data set.
#
# 2. Extract measurements on the mean and standard deviation for each measurement.
#
# 3. Use descriptive activity names to name the activities in the data set
#
# 4. Label the data set with descriptive variable names.
#
# 5. From the data set in step 4, create a second tidy data set with 
# the average of each variable for each activity and each subject.
#
#
# Data source:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Checking and installing needed packages
#
# function to install and load packages from a char vector
#
InstallLoadPackages <- function(needed_pkg){

        new_pkg <- needed_pkg[!(needed_pkg %in% installed.packages()[, "Package"])]
        
        if (length(new_pkg)) 
            install.packages(new_pkg, dependencies = TRUE)
        
        sapply(needed_pkg, require, character.only = TRUE)
}
#
# List of needed packages
#
needed_pkg <- c("dplyr","data.table","janitor")
InstallLoadPackages(needed_pkg)


#
# download and unzip data - data dir will be created by unzip
#
source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

source_zip <- "UCI HAR Dataset.zip"

download.file(source_url, source_zip)

if(file.exists(source_zip)) unzip(source_zip) else stop(paste("Source file does 
                                        not exist. Program stopped!!!", sep=""))  

#
# Use descriptive activity names to name the activities in the data set         
#
ActivityNames <- fread(list.files(path = "./", pattern = "activity_labels.txt", 
                        recursive = TRUE, full.names = TRUE), 
                        col.names = c("ActivityCode", "ActivityName"))

AllFeatures <- fread(list.files(path = "./", pattern = "features.txt",
                  recursive = TRUE, full.names = TRUE), 
                  col.names = c("FeatureCode", "FeatureName"))

SelectedFeatures <- filter(AllFeatures, grepl('mean|std', FeatureName))

#
# Remove special char and repeated tag BodyBody (from codes 516 to 552)
#
SelectedFeaturesEdited <- mutate(SelectedFeatures, FeatureName = gsub("-", "", FeatureName),
                                 FeatureName = gsub("\\(", "", FeatureName),
                                 FeatureName = gsub("\\)", "", FeatureName),
                                 FeatureName = gsub("BodyBody", "Body", FeatureName))

#
# Read train data set according selected features
#

TrainDataSet <- fread(list.files(path = "./", pattern = "^X_train.txt$",
                             recursive = TRUE, full.names = TRUE),
                             col.names = AllFeatures$FeatureName)[,SelectedFeatures$FeatureName, 
                                                          with = FALSE] 

colnames(TrainDataSet) <- SelectedFeaturesEdited$FeatureName                             


TrainActivity <- fread(list.files(path = "./", pattern = "^y_train.txt$",
                                 recursive = TRUE, full.names = TRUE), 
                                 col.names = c("activity"))

TrainSubject <- fread(list.files(path = "./", pattern = "^subject_train.txt$",
                                 recursive = TRUE, full.names = TRUE), 
                                 col.names = c("subject"))

TrainData <- cbind(TrainSubject,TrainActivity,TrainDataSet)

#
# Read test data set according selected features
#

TestDataSet <- fread(list.files(path = "./", pattern = "^X_test.txt$",
                                 recursive = TRUE, full.names = TRUE), 
                                 col.names = AllFeatures$FeatureName)[,SelectedFeatures$FeatureName, 
                                                                       with = FALSE] 

colnames(TestDataSet) <- SelectedFeaturesEdited$FeatureName


#
# Check consistence between train and test data sets (column names and classes)
#
ComparasionResults <- compare_df_cols(TrainDataSet,TestDataSet,return="mismatch")
if (nrow(ComparasionResults) != 0) { 
        print(paste("Train and Test Data Sets do not match!!!", sep=""))              
}    
#
#

TestActivity <- fread(list.files(path = "./", pattern = "^y_test.txt$",
                                  recursive = TRUE, full.names = TRUE), 
                                  col.names = c("activity"))

TestSubject <- fread(list.files(path = "./", pattern = "^subject_test.txt$",
                                 recursive = TRUE, full.names = TRUE), 
                                 col.names = c("subject"))

TestData <- cbind(TestSubject,TestActivity,TestDataSet)


# Bind test and train data sets 

AllData <- rbind(AllTrainData,AllTestData)


# set subject and activity as factor and set activities to their names instead 
# codes

AllData$subject = as.factor(AllData$subject)


AllData[["activity"]] <- factor(AllData[, activity],levels = ActivityNames$ActivityCode,
                                      labels = ActivityNames$ActivityName)

# summarizes and sort variables by subject and activity and calculates mean 
# of variables

AllData <- aggregate(AllData[, 3:81], list(AllData$subject,AllData$activity), 
                     mean) 
names(AllData)[1:2] <- c("subject","activity")

AllData <- AllData %>% arrange(subject,desc(activity))

fwrite(x = AllData, file = "TidyData.csv", quote = FALSE, na="NA",
       row.names=FALSE)

## program end - evaluated

            


        











