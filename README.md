# Getting and Cleaning Data Course Project

##Description of script: run_analysis.R

The script run_analysis.R is used to create the "tidy.txt" data set using R through a series of transformations using the original dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Information for the original dataset could be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

run_analysis.R aims to 

1. Merges the training and the test sets to create one data set. Files used to merge are X_test.txt, X_train.txt, y_test.txt, y_train.txt,    subject_train.txt, subject_test.txt, features.txt. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity (activity_labels.txt) names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names, replacing any abbreviations and tidying the variable names to allow    for easy recognition.
4. From the data set in step 4, creates a second, independent tidy data set named "tidy.txt" with the average of each variable for each     activity and each subject.

More information on this script can be found in the CodeBook.md
