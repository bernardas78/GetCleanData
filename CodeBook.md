### Code book

This code book describes the variables, the data, and any transformations or work that you performed to clean up the data

The raw data consists of the following:
* Train and test data stored in separate directories /Train and /Test. Train contains ~7000 measurements and test contains ~3000
* Each (train and test) data consists of:
** Subjects of the measurements (who) in files [Train|Test]/subject_[train|test].txt. A vector of int, a numeric value 1:30 for each measurement
** Activity indexes of the measurements (what kind of activity was performed) in files [Train|Test]/Y_[train|test].txt. A vector of int, a numeric value 1:6 for each measurement
** Measurements in files [Train|Test]/X_[train|test].txt. It's a matrix of 561 columns (measures) where one row is one measurement of each measure. Values are normalized to range -1..1
========
** Files in directories [Train|Test]/Inertial Signals contain raw signal data. I did not use it for this assignment as per explanation https://class.coursera.org/getdata-011/forum/thread?thread_id=69

Variables of raw data:
** Activity labels in file activity_labels.txt. This is a mapping between activity index in [Train|Test]/Y_[train|test].txt and a readable activity name
** Measure labels in file features.txt. This is a column headers vector for files [Train|Test]/X_[train|test].txt

Tidy data set consists of the following columns:
*subject - this a subject who measurement was performed on. Values 1:30
*act_label - a readable activity name, character values one of 6 activities
*var_name - a measure name (character value), a choice from file features.txt that contains "mean" or "std"
*mean(var_value) - average of all measurements per subject per activity for a given measure

Transformations performed to get from raw data to tidy data:
*Train and test data was merged to a 3 data sets: subject, activity, measurements
*Removed all columns from measurements data set other than the ones that contain "mean" or "std". Produced data set width was 79 columns
*Merged 3 data sets (subject, activity, column-filtered measurements) to a single data set.
*Pivoted the single data set to put 79 columns as rows (to make it more readable). This step produced a nice narrow data set (4 columns: subject,activity,measure name, measure value)
*Aggregated the above data set by first 3 columns (subject,activity,measure name), and calculated mean for measure value.

If you wish to run it yourself:
*Unpack contents of https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to a folder one above script run_analysis.R
*Running it requires packages dplyr and tidyr - make sure you have them installed
*set working directory where script run_analysis.R is
*run script run_analysis.R. it takes a few min, most time is used to read data
*resulting tidy data set is created in file tidyDS_task5.txt
