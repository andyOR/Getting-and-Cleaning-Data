#Downloaded the file and saved the file in the data folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#Unzipped the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#unzipped files are in the folder UCI HAR Dataset
dist_cd <- file.path("./data" , "UCI HAR Dataset")
file1<-list.files(dist_cd, recursive=TRUE)
file1

#Read the data from the files into the variables activity, Subject and Features
dataActivityTest  <- read.table(file.path(dist_cd, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(dist_cd, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <-  read.table(file.path(dist_cd, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <-  read.table(file.path(dist_cd, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(dist_cd, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(dist_cd, "train", "X_train.txt"),header = FALSE)

#Merge the training and the test sets to create one data set.
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

#set names to variables
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(dist_cd, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Merged columns to get the data frame Data for all datavalues
dataMerge <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataMerge)

#Extracts only the measurements on the mean and standard deviation for each measurement
meandataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectNames<-c(as.character(meandataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectNames)

#descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(dist_cd, "activity_labels.txt"),header = FALSE)

#factorize Variable activity in the data frame Data
Data$activity <- factor(data$activity, lablels = activity[,2])

# labelling the data set with descriptive variable names
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Datafile2 <- aggregate(. ~subject + activity, Data, mean)
Datafile2 <- Datafile2[order(Datafile2$subject,Datafile2$activity),]
write.table(Datafile2, file = "tidydata.txt",row.name=FALSE)