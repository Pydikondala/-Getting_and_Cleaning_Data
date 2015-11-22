# Getting_and_Cleaning_Data
## By Subbarao Pydikondala

###Code Description

### 1. To Merge the training and the test sets to create one data set.
- Create Training Data Set and test data set
- Combine training and test data set as PSFinalData

###2. To extracts only the measurements on the mean and standard deviation for each measurement
- Create a logicalVector and subset data 

###3. To descriptive activity names to name the activities in the data set
- Merge the PSFinalData set with activityLabels and Update the colNames 

###4. To appropriately label the data set with descriptive activity names
- Reassigning the new descriptive column names to PSFinalData 

###5. To create a second, independent tidy data set with the average of each variable for each activity and each subject. 
-Create PSFinalDataNoactivityLabels, summarize and include mean of each variable for each activity and each subject and export it to PStidyData.txt