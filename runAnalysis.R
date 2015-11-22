# runAnalysis.r File Description:
# clearning environment variables
rm(list=ls())

# 1. To Merge the training and the test sets to create one data set.

#set working directory
setwd('D:/Data Science/Course by JohnHopkins/Getting and Cleaning Data/Course Project/UCI HAR Dataset');
#Create Training Data Set
features     = read.table('./features.txt',header=FALSE);
activityLabels = read.table('./activity_labels.txt',header=FALSE);
subjectTrain = read.table('./train/subject_train.txt',header=FALSE);
xTrain       = read.table('./train/x_train.txt',header=FALSE);
yTrain       = read.table('./train/y_train.txt',header=FALSE);


colnames(activityLabels)  = c('activityId','activityLabels');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

trainingData = cbind(yTrain,subjectTrain,xTrain);

# Create test data set
subjectTest = read.table('./test/subject_test.txt',header=FALSE); 
xTest       = read.table('./test/x_test.txt',header=FALSE); 
yTest       = read.table('./test/y_test.txt',header=FALSE); 

colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

testData = cbind(yTest,subjectTest,xTest);

# Combine training and test data set
PSFinalData = rbind(trainingData,testData);
colNames  = colnames(PSFinalData); 

# 2. To extracts only the measurements on the mean and standard deviation for each measurement
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));
PSFinalData = PSFinalData[logicalVector==TRUE];

# 3. To descriptive activity names to name the activities in the data set

PSFinalData = merge(PSFinalData,activityLabels,by='activityId',all.x=TRUE);
colNames  = colnames(PSFinalData); 

# 4. To appropriately label the data set with descriptive activity names

for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

colnames(PSFinalData) = colNames;

# 5. To create a second, independent tidy data set with the average of each variable for each activity and each subject. 

PSFinalDataNoactivityLabels  = PSFinalData[,names(PSFinalData) != 'activityLabels'];
tidyData    = aggregate(PSFinalDataNoactivityLabels[,names(PSFinalDataNoactivityLabels) != c('activityId','subjectId')],by=list(activityId=PSFinalDataNoactivityLabels$activityId,subjectId = PSFinalDataNoactivityLabels$subjectId),mean);
tidyData    = merge(tidyData,activityLabels,by='activityId',all.x=TRUE);
write.table(tidyData, './PStidyData.txt',row.names=FALSE,sep='\t');## Writing to Textfile