run <- function() {

# load the train data
value_train <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/train/X_train.txt")
activity_train <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/train//y_train.txt")
subject_train <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/train/subject_train.txt")

# load the test data
value_test <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/test/X_test.txt")
activity_test <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/test//y_test.txt")
subject_test <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/test/subject_test.txt")

# load the variable names
feature <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/features.txt")

# get rid off extra column and rename the column contains variable names to "signal"
feature <- select(feature, -V1)
feature <- rename(feature, signal = V2)

# assign variable names to train datasets
names(value_train) <- feature$signal
activity_train <- rename(activity_train, activity = V1)
subject_train <- rename(subject_train, subjectid = V1)

# assign variable names to test datasets
names(value_test) <- feature$signal
activity_test <- rename(activity_test, activity = V1)
subject_test <- rename(subject_test, subjectid = V1)

# select only variable that has the word "mean" or "std" for each dataset
value_train <- value_train[,grep("mean|std", names(value_train))]
value_test <- value_test[,grep("mean|std", names(value_test))]

# combind train datasets into one big data
traindata <- cbind(subject_train, activity_train, value_train)

# combind test dataset into one big data
testdata <- cbind(subject_test, activity_test, value_test)

# assign activity label to make easy reading
label <- read.table("C:/Users/Long Nguyen/My-1st-Project/Data/UCI HAR Dataset/activity_labels.txt")
label <- mutate(label, activity = c("walk","walkupstair","walkdownstair","sit","stand","lay"))
traindata$activity <- factor(traindata$activity, levels = c(1,2,3,4,5,6), labels = label$activity)
testdata$activity <- factor(testdata$activity, levels = c(1,2,3,4,5,6), labels = label$activity)

# combind train and test data into oe big data
finaldata <- rbind(traindata, testdata)
finaldata <- arrange(finaldata, subjectid)

# fixing the variable names to exclude "()" and "-"
names(finaldata) <- gsub("\\()|-","",names(finaldata))

meanvalue <- function (data, s) {
  lapply(split(data,s), mean)
}

# split the final data by each variable and calculate the mean value for each activity
activity_mean <- sapply(select(finaldata, -subjectid), meanvalue, finaldata$activity)
activity_mean <- as.data.frame(activity_mean)
activity_mean <- mutate(activity_mean, activity = row.names(activity_mean))

# rename the variable to me more appropriate
len <- length(names(activity_mean))
names(activity_mean)[2:len] <- paste0(names(activity_mean)[2:len],"activity")

# split the final data by each variable and calculate the mean value for each subject
subject_mean <- sapply(select(finaldata, -activity), meanvalue, finaldata$subjectid)
subject_mean <- as.data.frame(subject_mean)
subject_mean <- mutate(subject_mean, subjectid = row.names(subject_mean))

# rename the variable to be more appropriate
len <- length(names(activity_mean))
names(subject_mean)[2:len] <- paste0(names(subject_mean)[2:len],"subject")

# merge activity mean and subject mean data to create on big data
newdb <- lapply(split(subject_mean, subject_mean$subjectid), cbind, activity_mean)

# convert list into data frame (adding row by row)
new <- NULL
for (e in 1:length(newdb)) {
  new <- rbind(new, newdb[[e]])
}

# arrange the columns
col_indx <- grep("activity", names(new))
new <- new[,c(1, col_indx, (1:ncol(new))[-col_indx][-1])]

# final data set (part 5)
new
}