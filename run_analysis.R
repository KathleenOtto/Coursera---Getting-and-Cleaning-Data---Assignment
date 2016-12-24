# Data Source
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<-"training_test.zip"

# Check if file is already downloaded
if(!file.exists(filename)){
download.file(fileURL,filename)
unzip(filename)}

# Load Descriptions
activitylabels<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("activity_ID","activity_Label"))
features<-read.table("UCI HAR Dataset/features.txt",col.names = c("features_ID","features_Label"))

# Load Data and Name Columns
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject_ID")
train_x<-read.table("UCI HAR Dataset/train/x_train.txt",col.names = features$features_Label)
train_y<-read.table("UCI HAR Dataset/train/y_train.txt",col.names = "activity_ID")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject_ID")
test_x<-read.table("UCI HAR Dataset/test/x_test.txt",col.names = features$features_Label)
test_y<-read.table("UCI HAR Dataset/test/y_test.txt",col.names = "activity_ID")

# 1.  Merge training & test sets to create one data set.
train<-cbind(train_x,train_y,train_subject)
test<-cbind(test_x,test_y,test_subject)
train_test_combined<-rbind(train,test)
                          
# 2.	Extract only mean and std dev for each measurement
# Search for "mean" / "Mean" / "std" / "Std" anywhere in each label = 86 variables
# add "activity_ID" and "subject_ID" to search to not lose y and subject column = 88 variables
label_filter<-grepl("*[mM]ean*|*[sS]td*|activity_ID|suject_ID",colnames(train_test_combined))
# filter combined data (reduced from 561 to 86 variables)
train_test_combined_filter<-train_test_combined[,label_filter==TRUE]

# 3.	Use descriptive activity names to name the activities in the data set
# replace integers with characters, then replace one type after the other
train_test_combined_filter$activity_ID<-as.character(train_test_combined_filter$activity_ID)
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==1]<-"Walking"
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==2]<-"Walking_Upstairs"
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==3]<-"Walking_Downstairs"
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==4]<-"Sitting"
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==5]<-"Standing"
train_test_combined_filter$activity_ID[train_test_combined_filter$activity_ID==6]<-"Laying"
#rename "activity_ID" column to "activity"
names(train_test_combined_filter)<-gsub("activity_ID","activity",names(train_test_combined_filter))

# 4.	Appropriately label the data set with descriptive variable names
# eliminate abbreviations = long but self explanatory titles
names(train_test_combined_filter)<-gsub("^t","Time",names(train_test_combined_filter))
names(train_test_combined_filter)<-gsub("^f","Frequency",names(train_test_combined_filter))
names(train_test_combined_filter)<-gsub("Acc","Accelerator",names(train_test_combined_filter))
names(train_test_combined_filter)<-gsub("Gyro","Gyroscope",names(train_test_combined_filter))
names(train_test_combined_filter)<-gsub("Mag","Magnitude",names(train_test_combined_filter))

# 5.	From step 4 data set, create 2nd, independent tidy data set 
#     with avg of each variable for each activity and each subject
library(plyr)
averages_data <- ddply(train_test_combined_filter, .(subject_ID, activity), function(x) colMeans(x[, 1:86]))
# 6.  Save file from step 5 as "average_tidy.txt" in working directory
write.table(averages_data,"averages_tidy.txt",row.names = FALSE,quote = FALSE)

