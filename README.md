### README file

As per instructions: "You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. "

The contents of the reposirory consists of:
* Single script file run_analysis.R, which performs all tasks required by the project
* A tidy data set, result of a task 5 in file tidyDS_task5.txt
* Code book in file CodeBook.md which includes description of what transformations were done as well as variable descriptions
* This readme.md file

If you wish to run it yourself:
* Put file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to the working folder (do not unzip)
* Running it requires packages dplyr and tidyr - make sure you have them installed. You can install by running install.packages("dplyr"), install.packages("tidyr")
* run script run_analysis.R. it takes a few min, most time is used to read data
* resulting tidy data set is created in file working directory, file tidyDS_task5.txt

Script uses raw data zip file provided by instructor and produces a tidy summarized data set in a file. Description of how script works:
* Script uses "unz" function to create a file connections to zip file provided by the instrctor. 
* First it reads data to data frames df_subject_train, df_label_train, df_data_train (and _test)
* (1 task) merges train and test data sets together to 3 sets (as of this point task 1 is not fully finished; I found it more convenient to set columns names at this point before merging sets together, which is task 4)
* (4 task) sets descriptive column names; column names for various measurements come from file features.txt
* (1 task) finishing to merge 3 data sets - subjects, activity, measurement - to a single set. This completes task 1
* (2 task) removes measurments that do not contain "mean" or "std" in their column names. "grep" function is used to evaluate string contents
* (3 task) changes the activity index (valued 1-6) to a descriptive activity name. Activity names come from file activity_labels.txt
* (5 task) summarizes data set by subject and activity. In order to make resulting data set more readable, measurements are pivoted. Resulting data set is output to a file in working directory. Packages dplyr and tidyr are used for grouping and summarization
