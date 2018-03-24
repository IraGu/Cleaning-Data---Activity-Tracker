# Getting and Cleaning Data Course Project

## Background information 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Information for the original dataset "Human Activity Recognition Using Smartphones Data Set" (HAR) could be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Repository file information

This repository contains the following files:
1. run_analysis.R - this script will create the "tidy.txt" file, more information see "Description of script: run_analysis.R"
2. tidy.txt - created using run_analysis.R, with the average of each variable for each activity and each subject from orginal data set.
3. CodeBook.md -  a code book that describes the variables, the data, and how run_analysis.R cleans up the "Human Activity Recognition      Using Smartphones Data Set"
4. Readme.txt - includes background information of the project, quick rundown of the files in the repo, and a brief description of the      purpose of run_analysis.R 

## Description of script: run_analysis.R

The script run_analysis.R is used to create the "tidy.txt" data set using R through a series of transformations using the "Human Activity Recognition Using Smartphones Data Set"

run_analysis.R aims to 

1. Merges the training and the test sets to create one data set. Files used to merge are X_test.txt, X_train.txt, y_test.txt, y_train.txt,    subject_train.txt, subject_test.txt, features.txt. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity (activity_labels.txt) names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names, replacing any abbreviations and tidying the variable names to allow    for easy recognition.
4. From the data set in step 4, creates a second, independent tidy data set named "tidy.txt" with the average of each variable for each     activity and each subject.

More information on this script can be found in the CodeBook.md
