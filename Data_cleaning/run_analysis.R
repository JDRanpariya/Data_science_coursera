# Loading pakages and getting data

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
if(!dir.exists('data')) { dir.create('/data')}                          # checks if data dir is already there or not
path <- getwd()                                                         # get the current path save it to use for future
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filez <- download.file(Url, destfile = file.path(path, "datafiles.zip"))
unzip(zipfile = "datafiles.zip")                                        # unzip downloaded file


# load activitylabels and features

activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames]) # which contains only mean or sd

measurments <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)  # to remove the () from featurename

# load training dataset

train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)                      # apply the col names as in measurments
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))                           #read file and set col name to activity
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))                            #read file and set col name to subjectNum
train <- cbind(trainSubjects, trainActivities, train)


# load testing dataset/ validation dataset

test <- fread(file.path(path, "UCI HAR DATASET/test/X_test.txt"))[, featuresWanted, with=FALSE]

data.table::setnames(test,colnames(test), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                         , col.names = c("Activity"))                               # same comments as above
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                       , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)


# merge datasets
combined <- rbind(train, test)               # it joins two datatables



# Convert classLabels to activityName. 
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)        # tidyData file created for evalution perpose


















