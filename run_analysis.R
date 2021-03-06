#Original task description: 
#   1.Merges the training and the test sets to create one data set.
#   2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3.Uses descriptive activity names to name the activities in the data set
#   4.Appropriately labels the data set with descriptive variable names. 
#   5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#packages required
require(tidyr)
require(dplyr)

#read data from files
df_subject_train <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/train/subject_train.txt") %>% read.table
df_label_train <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/train/y_train.txt") %>% read.table
df_data_train <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/train/X_train.txt") %>% read.table

df_subject_test <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/test/subject_test.txt") %>% read.table
df_label_test <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/test/y_test.txt") %>% read.table
df_data_test <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/test/X_test.txt") %>% read.table

#1.merge data to 3 data sets: subject, activity label, measurements data
#first, merge test and train sets by rows; then merge columns of all 3 data sets (subjects, labels, data) 
#I am only including data from main directories (/train, /test), but excluding raw data from /Intertial Signals, 
df_subject<-rbind(df_subject_train,df_subject_test)
df_label<-rbind(df_label_train,df_label_test)
df_data<-rbind(df_data_train,df_data_test)

#4.set column names which we will later refer to
colnames(df_subject)<-c("subject") 
colnames(df_label)<-c("act_index") 
#column names of X_[test|train].txt come from features.txt
col_names_X <- unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/features.txt") %>% read.table(col.names=c("ord","name"))
colnames(df_data)<-as.character(col_names_X$name)

#1.finally, merge subject, activity, data to a single data set. this completes task 1
df <- cbind(df_subject, df_label, df_data)

#2.extract only measurements for variables containing "mean" or "std". 
col_rowNums_filtered <- c(grep("mean", col_names_X$name),grep("std", col_names_X$name)) #this is row numbers in file features.txt
col_names_filtered <- as.character(col_names_X[col_rowNums_filtered,"name"])
df<-df[c("subject","act_index",col_names_filtered)] # preserve columns "subject" and "act_index"; remove all other columns not containing mean/std

#3. Replace activity index (act_index) field with label from file activity_labels.txt
activity_names <-unz(description="./getdata_projectfiles_UCI HAR Dataset.zip",filename="UCI HAR Dataset/activity_labels.txt")%>% read.table(col.names=c("act_index","act_label"))
df<-merge(activity_names,df)
df$act_index <- NULL

#5. Create a tidy narrow data set with means for each measure by subject and activity;
# first, pivot the table to make each measure as row;
# then summarize mean by subject, activity and measure name
tbl_task5 <- tbl_df(df)
tbl_task5_pivot <-gather(tbl_task5,var_name,var_value,-subject,-act_label)
tbl_task5_pivot_grouped <- group_by(tbl_task5_pivot, subject,act_label,var_name)
tbl_task5_summary <- summarize(tbl_task5_pivot_grouped,mean(var_value))

#write out the resulting data set to a file
write.table(tbl_task5_summary,"./tidyDS_task5.txt",row.names=FALSE)

