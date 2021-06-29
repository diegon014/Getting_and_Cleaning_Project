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

#Read Activity names
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

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


#Extract the measurements on the mean and standard deviation
full_data <- select(full_data, SubjectId, ActivityId, contains(c("mean","std")))


#Replace ActivityId with Activity Description
full_data$ActivityId <- activity[full_data$ActivityId,2]


#Replace Columns Names with appropriate descriptive names
names(full_data)<-gsub("^t", "Time", names(full_data))
names(full_data)<-gsub("^f", "Frequency", names(full_data))
names(full_data)<-gsub("-mean()", "Mean", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-std()", "STD", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-mad()", "Median", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-max()", "Largest", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-min()", "Small", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-sma()", "SignalMagnitude", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-energy()", "Energy", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-iqr()", "Interquartile", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("-entropy()", "SignalEntropy", names(full_data), ignore.case = TRUE)
names(full_data)<-gsub("angle", "Angle", names(full_data))

#Calculate the Mean of each measure
final_data <- full_data %>%
        group_by(ActivityId,SubjectId) %>%
        summarise_all(funs(mean))

#Write the final result to final_data.txt
write.table(final_data, "final_data.txt", row.name=FALSE)
