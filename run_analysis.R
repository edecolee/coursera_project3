# Step 1. Merge the training and test sets to create onone data set

# Read txt files from test folder and assign to variables
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read txt files from train folder and assign to variables
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Combin each data to one set. x, y and subject
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)


# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement

# Read features txt file and assign to variable
features <- read.table("./UCI HAR Dataset/features.txt")

# Extract column that contains mean or std
new_features <- grepl("mean|std", features[,2])

# Remain the data that has correct column
x <- x[,new_features]

# Give correct column names
names(x) <- features[new_features, 2]
names(y) <- "activity"
names(subject) <- "subject"

# Combin all data
whole_data <- cbind(x, subject,y)

# Step 3. Use descriptive activity names to name the activities in the data set

# Read activity_label txt file and assign to variable
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merge whole data and activity list and update description
new_data <- merge(whole_data, activity, by.x= "activity", by.y= "V1")


# Step 4. Appropriately label the data set with descriptive variable names

# Remove the first column because it is resorted by merge function
new_whole_data <- new_data[,2:82]

# Rename the activiy column
names(new_whole_data)[81] <- "activity"


# Step 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Call library plyr
library(plyr)
tidy_data <- ddply(new_whole_data, .(subject, activity), function(x) colMeans(x[, 1:79]))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)