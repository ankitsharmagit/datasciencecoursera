library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}
## test data:
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

##Part1 - merges train and test data in one dataset (full dataset at the end)
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

index<-grep("mean\\(\\)|std\\(\\)", features[,2]) ##getting features indeces which contain mean() and std() in their name
length(index) ## count of features


X<-X[,index] ## getting only variables with mean/stdev
dim(X) ## checking dim of subset 

names<-features[index,2] ## getting names for variables

names(X)<-names ## updating colNames for new dataset
names(Subject)<-"SubjectID"
names(Y)<-"Activity"

CleanedData<-cbind(Subject, Y, X)
head(CleanedData[,c(1:4)]) ## first 5 columns

CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] ## features average by Subject and by activity
dim(TidyData)
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
