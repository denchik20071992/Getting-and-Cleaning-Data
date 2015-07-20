library(RCurl)


# Merges the training and the test sets
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
x_full <- rbind(x_train, x_test)

subj_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subj_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subj_full <- rbind(subj_train, subj_test)

y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y_full <- rbind(y_train, y_test)

# Extracts only the measurements which suits the mean and standard deviation of measurement. 
features <- read.table('./UCI HAR Dataset/features.txt')
mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x_mean_std <- x_full[, mean_std]

# Uses descriptive activity names to name the activities in the data set
names(x_mean_std) <- features[mean_std, 2]
names(x_mean_std) <- tolower(names(x_mean_std)) 
names(x_mean_std) <- gsub("\\(|\\)", "", names(x_mean_std))

activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y_full[, 1] = activities[y_full[, 1], 2]
colnames(y_full) <- 'activity'
colnames(subj_full) <- 'subject'

# Appropriately labels the data set with descriptive activity names.
data <- cbind(subj_full, x_mean_std, y_full)
write.table(data, './UCI HAR Dataset/Project/merged.txt', row.names = F)

# Creates a second, independent tidy data set 
average_df <- aggregate(x=data, by=list(activities=data$activity, subj_full=data$subject), FUN=mean)
average_df <- average_df[, !(colnames(average_df) %in% c("subj_full", "activity"))]
write.table(average_df, './UCI HAR Dataset/Project/average.txt', row.names = F)