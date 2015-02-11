#Original task description: 
#   1.Merges the training and the test sets to create one data set.
#   2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3.Uses descriptive activity names to name the activities in the data set
#   4.Appropriately labels the data set with descriptive variable names. 
#   5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#read data from files
df_subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
df_label_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
df_data_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

df_subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
df_label_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
df_data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

#1.merge data to a single set
#first, merge test and train sets by rows; then merge columns of all 3 data sets (subjects, labels, data) 
#I am only including data from main directories (/train, /test), but excluding raw data from /Intertial Signals, 
# , as per explanation https://class.coursera.org/getdata-011/forum/thread?thread_id=69
df_subject<-rbind(df_subject_train,df_subject_test)
df_label<-rbind(df_label_train,df_label_test)
df_data<-rbind(df_data_train,df_data_test)

#4.set column names which we will later refer to
colnames(df_subject)<-c("subject") 
colnames(df_label)<-c("act_index") 
#column names of X_[test|train].txt come from features.txt
col_names_X <- read.table("./UCI HAR Dataset/features.txt", col.names=c("ord","name"))
colnames(df_data)<-as.character(col_names_X$name)

#finally, merge subject, activity, data to a single data set. this completes task 1
df <- cbind(df_subject, df_label, df_data)

#2.extract only measurements that contain "mean" or "std"
# first, read column names into a matrix col_names_X; then filter out columns that do not contain "mean" or "std"
col_rowNums_filtered <- c(grep("mean", col_names_X$name),grep("std", col_names_X$name)) #this is row numbers in file features.txt
col_names_filtered <- as.character(col_names_X[col_rowNums_filtered,"name"])

# preserve columns "subject" and "act_index"; remove all other columns not containing mean/std
df<-df[c("subject","act_index",col_names_filtered)]


#3. Replace activity index (act_index) field with label from file activity_labels.txt
activity_names <-read.table("./UCI HAR Dataset/activity_labels.txt", col.names=c("act_index","act_label"))
df<-merge(activity_names,df)
df$act_index <- NULL

#5. 
library(dplyr)
library(tidyr)

tbl_task5 <- tbl_df(df)
tbl_task5_pivot <-gather(tbl_task5,var_name,var_value,-subject,-act_label)
tbl_task5_pivot_grouped <- group_by(tbl_task5_pivot, subject,act_label,var_name)
tbl_task5_summary <- summarize(tbl_task5_pivot_grouped,mean(var_value))

write.table(tbl_task5_summary,"./tidyDS_task5.txt",row.names=FALSE)

