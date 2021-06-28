library(tidyr)
library(dplyr)

#Read Test Data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


#Read Training Data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Read Labels
labels <- read.table("./UCI HAR Dataset/features.txt")

#Columns Names
colnames(x_test) <- labels[,2]
colnames(x_train) <- labels[,2]
colnames(y_test) <- "ActivityId"
colnames(y_train) <- "ActivityId"
colnames(subject_test) <- "SubjectId"
colnames(subject_train) <- "SubjectId"

#Merge Data
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)

full_data <- rbind(test_data, train_data)


#Convert to table
point_2_data <- select(full_data,contains(c("mean","std")))

