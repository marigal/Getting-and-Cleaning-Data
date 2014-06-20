# Here are the data for the project:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for
# each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.


library(data.table)

#The data set is downloaded from the provided Url

fileUrl<-“http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip”

download.file(fileUrl, destfile = "Dataset.zip")

#The file is unzipped
unzip("Dataset.zip")

#Every file is read and assigned to a table

#Test data

test_set <- read.table("./UCI HAR Dataset/test/X_test.txt",header=F)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",header=F)
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=F)

#Train data

train_set <- read.table("./UCI HAR Dataset/train/X_train.txt",header=F)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt",header=F)
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=F)

#Activities are correctly labeled and turned from factor into character
activity <- read.table("./UCI HAR Dataset/activity_labels.txt",header=F)
activity$V1<-as.character(activity$V1)
activity$V2<-as.character(activity$V2)

#Both for test data
test_labels$V1 <- factor(test_labels$V1,levels=activity$V1,labels=activity$V2)

#and for train data
train_labels$V1 <- factor(train_labels$V1,levels=activity$V1,labels=activity$V2)

#features file is read and assigned to a table
feat <- read.table("./UCI HAR Dataset/features.txt",header=F)

#colnames for the 561 variables are included in both tables (test and train)
colnames(test_set)<-feat$V2
colnames(train_set)<-feat$V2

#labels for “subject” and “activity” are placed
colnames(sub_test)<-"subject"
colnames(sub_train)<-"subject"
colnames(test_labels)<-"activity"
colnames(train_labels)<-"activity"

#Test data are merged by column
labeled_test_set<-cbind(sub_test,test_labels, test_set)

#Train data are merged by column
labeled_train_set<-cbind(sub_train, train_labels, train_set)

#Test and train data are merged by row
Data<-rbind(labeled_test_set, labeled_train_set)

#Extraction of measures only for the mean and std deviation
Extract_test_Cols <- grep("[-]mean[(][)]|std", names(test_set))
Extract_train_Cols <- grep("[-]mean[(][)]|std", names(train_set))

sub_test_Data<-test_set[, Extract_test_Cols]
sub_train_Data<-train_set[, Extract_train_Cols]
labeled_sub_test_Data<-cbind(sub_test, test_labels, sub_test_Data)
labeled_sub_train_Data<-cbind(sub_train, train_labels, sub_train_Data)
sub_Data<-rbind(labeled_sub_test_Data, labeled_sub_train_Data)

# Creation of a second, independent tidy data set with the average of each
#variable for each activity and each subject.
mean_data<-aggregate(sub_Data[,3:68], by=list(sub_Data$subject, sub_Data$activity), mean)


names(mean_data)[1] <- "subject"
names(mean_data)[2] <- "activity"

#A text file is created with the tidy data set created in the 5th task
write.table(mean_data,file="tidy_data.txt",col.names=TRUE)
