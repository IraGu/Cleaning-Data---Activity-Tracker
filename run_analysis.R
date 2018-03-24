library(plyr)

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

xtotal <- rbind(xtrain,xtest)
##[1] 10299   561
feature1 <- feature$V2
##[1] 561
names(xtotal) <- feature1

subttl <- rbind(strain,stest)
##[1] 10299     1

ytotal <- rbind(ytrain,ytest)
##[1] 10299     1

names(ytotal) <- c("activitytype")
names(subttl) <- c("subject")

subytotal <- cbind(subttl,ytotal)

dat <- cbind(xtotal,subytotal)
##[1] 10299   563

featname <- grep("mean|std" ,feature1,value = TRUE)
featname1 <- featname[!grepl("meanFreq",featname)]

##remove meanFREQ measurement
dat1 <- subset(dat,select = c(as.character(featname1), "subject", "activitytype"))
##[1] 10299    68

dat1$activitytype <- as.factor(dat1$activitytype)

##library(plyr)
dat1$activitytype <- revalue(dat1$activitytype, c("1" = "WALKING"))
dat1$activitytype <- revalue(dat1$activitytype, c("2" = "WALKING_UPSTAIRS"))
dat1$activitytype <- revalue(dat1$activitytype, c("3" = "WALKING_DOWNSTAIRS"))
dat1$activitytype <- revalue(dat1$activitytype, c("4" = "SITTING"))
dat1$activitytype <- revalue(dat1$activitytype, c("5" = "STANDING"))
dat1$activitytype <- revalue(dat1$activitytype, c("6" = "LAYING"))

names(dat1)<-gsub("^t", "time", names(dat1))
names(dat1)<-gsub("^f", "frequency", names(dat1))
names(dat1)<-gsub("Mag", "magnitude", names(dat1))
names(dat1)<-gsub("Acc", "accelerometer", names(dat1))
names(dat1)<-gsub("Gyro", "gyroscope", names(dat1))
names(dat1)<-gsub("-", "", names(dat1))
names(dat1) <- as.character(names(dat1))
names(dat1) <- tolower(names(dat1))

dat2 <- aggregate(. ~subject + activitytype, dat1, mean)
write.table(dat2, file = "tidy.txt",row.name=FALSE)