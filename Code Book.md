# Getting and Cleaning Data - Code Book

## Steps

### 1 - Extract data from files to variables

The test, training and subject data are stored in the followings variables:

-   y_test.txt --\> x_test

-   y_test.txt --\> y_test

-   subject_test.txt --\> subject_test

-   y_train.txt --\> x_train

-   y_train.txt --\> y_train

-   subject_train.txt --\> subject_train

-   features.txt --\> labels

-   activity_labels --\> activity

### 2  - Replace the columns names

For each training, test and subject data, the columns names are added:

```{r}
colnames(x_test) <- labels[,2]
colnames(x_train) <- labels[,2]
colnames(y_test) <- "ActivityId"
colnames(y_train) <- "ActivityId"
colnames(subject_test) <- "SubjectId"
colnames(subject_train) <- "SubjectId"
```

### 3 - Merge the train and test data

First merge the test and training data, and finally merge both in one single data set

```{r}
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)

full_data <- rbind(test_data, train_data)

```

### 4 - Extract the measurements on the mean and standard deviation 

```{r}
full_data <- select(full_data, SubjectId, ActivityId, contains(c("mean","std")))

```

### 5 - Replace ActivityId with Activity Description

```{r}
full_data$ActivityId <- activity[full_data$ActivityId,2]
```

### 6 - Replace Columns Names with appropriate descriptive names

```{r}
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
```

### 7 - Calculate the Mean of each measure

```{r}
final_data <- full_data %>%
        group_by(ActivityId,SubjectId) %>%
        summarise_all(funs(mean))
```
