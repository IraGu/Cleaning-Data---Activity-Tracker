# Code Book

## run_analysis.R

This section will provide a detailed description of how the run_analysis.R script will create "tidy.txt"

The files that we will be using are found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The specific files we will be using to merge the data are:
X_test.txt, X_train.txt, y_test.txt, y_train.txt, subject_train.txt, subject_test.txt, features.txt

We will also be replacing the values found in y_train.txt and ytest.txt with the corresponding activity found in activity_labels.txt

### run_analysis.R code breakdown

The plyr package is required to run the following code.
```
library(plyr)
```
Taking a look at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones , we can see that the number of instances that is expected in the body of the dataset is 10299 instances with 561 attributes. Which is to say 561 columns and 10299 rows. If we include the subjects and activity types columns we expect 10299 rows with 563 columns. Using the  ```dim(x)``` function we can easily see what each piece of data looks like. Piecing it together we should expect the following scheme:
```
[feature]    [subject]          [activitytype]
X_train.txt  subject_train.txt  y_train.txt
X_test.txt   subject_test.txt   y_test.txt
```
The below reads in all the necessary files that will be merged to following the above scheme. 
```
xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep = '', header = FALSE)
##[1] 2947  561
xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep = '', header = FALSE)
##[1] 7352  561
ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep = '', header = FALSE)
##[1] 2947    1
ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep = '', header = FALSE)
##[1] 7352    1
strain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep = '', header = FALSE)
##[1] 7352    1
stest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep = '', header = FALSE)
##[1] 2947    1
feature <- read.table('./data/UCI HAR Dataset/features.txt', sep = '', header =  FALSE)
##[1] 561   2
```

This will merge the files, X_test.txt, X_train.txt use features.txt as the name, a quick check of the dimensions show that we have all the body of the data with 10299 rows, 561 columns

```
xtotal <- rbind(xtrain,xtest)
##[1] 10299   561
feature1 <- feature$V2
##[1] 561
names(xtotal) <- feature1
```

The below will merge the  y_test.txt, y_train.txt, subject_train.txt, subject_test.txt files and add column names to each 
```
subttl <- rbind(strain,stest)
##[1] 10299     1

ytotal <- rbind(ytrain,ytest)
##[1] 10299     1

names(ytotal) <- c("activitytype")
names(subttl) <- c("subject")

subytotal <- cbind(subttl,ytotal)
```

Combining everything, we have a data set with dimensions 10299 rows 563 columns , column 562 being the subject, and 563 being the activity type

```
dat <- cbind(xtotal,subytotal)
##[1] 10299   563
```

The below will store any feature with "mean" and std" into the featname variable and then we will remove the meanFrequency measurements and store that into featname1 variable. featname1 now contains all features with measurements "mean" and "std"
```
featname <- grep("mean|std" ,feature1,value = TRUE)
featname1 <- featname[!grepl("meanFreq",featname)]
##remove meanFREQ measurement
```

We subset the data by taking only column names that are stored in featname1. We are left with 68 columns and 10299 rows
```
dat1 <- subset(dat,select = c(as.character(featname1), "subject", "activitytype"))
##[1] 10299    68
```

The below will replace each activitytype number with the corresponding activity found in activity_labels.txt, where:
1 = WALKING
2 = WALKING_UPSTAIRS
3 = WALKING DOWNSTAIRS
4 = SITTING
5 = STANDING
6 = LAYING
```
dat1$activitytype <- as.factor(dat1$activitytype)

##library(plyr)
dat1$activitytype <- revalue(dat1$activitytype, c("1" = "WALKING"))
dat1$activitytype <- revalue(dat1$activitytype, c("2" = "WALKING_UPSTAIRS"))
dat1$activitytype <- revalue(dat1$activitytype, c("3" = "WALKING_DOWNSTAIRS"))
dat1$activitytype <- revalue(dat1$activitytype, c("4" = "SITTING"))
dat1$activitytype <- revalue(dat1$activitytype, c("5" = "STANDING"))
dat1$activitytype <- revalue(dat1$activitytype, c("6" = "LAYING"))
```

Modify the column names to be more readable
```
names(dat1)<-gsub("^t", "time", names(dat1))
names(dat1)<-gsub("^f", "frequency", names(dat1))
names(dat1)<-gsub("Mag", "magnitude", names(dat1))
names(dat1)<-gsub("Acc", "accelerometer", names(dat1))
names(dat1)<-gsub("Gyro", "gyroscope", names(dat1))
names(dat1)<-gsub("-", "", names(dat1))
names(dat1) <- as.character(names(dat1))
names(dat1) <- tolower(names(dat1))
```

Use aggregate function to create a second dataframe with the average for each variable in the subsetted dataframe (dat1) for each subject and activity. Then that dataframe will be witten into a text file called "tidy.txt"
```
dat2 <- aggregate(. ~subject + activitytype, dat1, mean)
write.table(dat2, file = "tidy.txt",row.name=FALSE)
```

## Data set information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Description of variables
Prior to normalization, the acceleration signal from the smartphone accelerometer is in standard gravity units 'g' (9.8m/s^2), gyroscope angular velocity unis are radians/seconds. Frequency are in Hertz. The data then is normalized and bounded within domain (-1,1).

Accelerometer used to capture 3-axial linear acceleration. The variables containing "mean" depicts the mean of the acceleration. The variables containing "std" is the standard deviation of the measurement. Variables ending in x, y, z are measurements of the time measured values on the x,y,z axis of a 3 dimensional plane. (Because movements happen in a 3-D space)

```
"timebodyaccelerometermean()x"      "timebodyaccelerometermean()y"
"timebodyaccelerometermean()z"	    "timebodyaccelerometerstd()x"
"timebodyaccelerometerstd()y"	      "timebodyaccelerometerstd()z"
"timegravityaccelerometermean()x"   "timegravityaccelerometermean()y"
"timegravityaccelerometermean()z"	  "timegravityaccelerometerstd()x"
"timegravityaccelerometerstd()y"	  "timegravityaccelerometerstd()z"
"timebodyaccelerometerjerkmean()x"  "timebodyaccelerometerjerkmean()y"
"timebodyaccelerometerjerkmean()z"  "timebodyaccelerometerjerkstd()x"
"timebodyaccelerometerjerkstd()y"	  "timebodyaccelerometerjerkstd()z"
```
Same as above except it is a measurement of angular acceleration. 
```
"timebodygyroscopemean()x"	"timebodygyroscopemean()y"
"timebodygyroscopemean()z"	"timebodygyroscopestd()x"
"timebodygyroscopestd()y"	"timebodygyroscopestd()z"
"timebodygyroscopejerkmean()x"	"timebodygyroscopejerkmean()y"
"timebodygyroscopejerkmean()z"	"timebodygyroscopejerkstd()x"
"timebodygyroscopejerkstd()y"	"timebodygyroscopejerkstd()z"
```
The respective mean and standard deviation magnitude of the measurements using accelerometer (linear) and gyroscope (angular).
```
"timebodyaccelerometermagnitudemean()"	"timebodyaccelerometermagnitudestd()"
"timegravityaccelerometermagnitudemean()"	"timegravityaccelerometermagnitudestd()"
"timebodyaccelerometerjerkmagnitudemean()"	"timebodyaccelerometerjerkmagnitudestd()"
"timebodygyroscopemagnitudemean()"	"timebodygyroscopemagnitudestd()"
"timebodygyroscopejerkmagnitudemean()"	"timebodygyroscopejerkmagnitudestd()"
```

Fast Fourier Transform (FFT) applied to the measurements above to convert into frequency. A sinusoidal curve with amplitude and phase. 
```
"frequencybodyaccelerometermean()x"	"frequencybodyaccelerometermean()y"
"frequencybodyaccelerometermean()z"	"frequencybodyaccelerometerstd()x"
"frequencybodyaccelerometerstd()y"	"frequencybodyaccelerometerstd()z"
"frequencybodyaccelerometerjerkmean()x"	"frequencybodyaccelerometerjerkmean()y"
"frequencybodyaccelerometerjerkmean()z"	"frequencybodyaccelerometerjerkstd()x"
"frequencybodyaccelerometerjerkstd()y"	"frequencybodyaccelerometerjerkstd()z"
"frequencybodygyroscopemean()x"	"frequencybodygyroscopemean()y"
"frequencybodygyroscopemean()z"	"frequencybodygyroscopestd()x"
"frequencybodygyroscopestd()y"	"frequencybodygyroscopestd()z"
"frequencybodyaccelerometermagnitudemean()"	"frequencybodyaccelerometermagnitudestd()"
"frequencybodybodyaccelerometerjerkmagnitudemean()"	"frequencybodybodyaccelerometerjerkmagnitudestd()"
"frequencybodybodygyroscopemagnitudemean()"	"frequencybodybodygyroscopemagnitudestd()"
"frequencybodybodygyroscopejerkmagnitudemean()"	"frequencybodybodygyroscopejerkmagnitudestd()"
```

Subjects of 30 volunteers numbered 1-30 age 19-48 years 
```
"subject"
```

The activity during measurement, see activity_labels.txt
```
"activitytype"
```







