run_analysis<-function(){   
  
  # Requirement: 
  # library(data.table)
  # library(reshape2)
    
  # load Training and Test data sets from "UCI HAR Dataset" directory
  zipdir<-"UCI HAR Dataset"
  data_Train<-read.table(paste(zipdir,"train/X_train.txt", sep= "/"), stringsAsFactors = FALSE)
  data_Test<-read.table(paste(zipdir,"test/X_test.txt", sep= "/"), stringsAsFactors = FALSE)
  
  # load Training and Test subjects
  data_SubTrain<-read.table(paste(zipdir,"train/subject_train.txt", sep= "/"), stringsAsFactors = FALSE)
  data_SubTest<-read.table(paste(zipdir,"test/subject_test.txt", sep= "/"), stringsAsFactors = FALSE)
  
  # load Training and Test Activity labels
  data_Train_Activity<-read.table(paste(zipdir,"train/y_train.txt", sep= "/"), stringsAsFactors = FALSE)
  data_Test_Activity<-read.table(paste(zipdir,"test/y_test.txt", sep= "/"), stringsAsFactors = FALSE)
  
  # load list of all features which are the column names for Training and Test data sets
  data_features<-read.table(paste(zipdir,"features.txt", sep= "/"), stringsAsFactors = FALSE)
  
  # load activity name for each Activity labels
  data_activity_labels<-read.table(paste(zipdir,"activity_labels.txt", sep= "/"), stringsAsFactors = FALSE)  

  # Merge the train and test datasets
  data_Observations<-rbind(data_Train, data_Test)
  data_Subject<-rbind(data_SubTrain,data_SubTest)
  data_Activity<-rbind(data_Train_Activity, data_Test_Activity)
    
  # Set data_features as the column names for data_Observations
  setnames(data_Observations,names(data_Observations), data_features[,2])
  
  # Set approriate names for columns in data_Subject and data_Activity data frames.
  setnames(data_Subject, names(data_Subject), "subject")
  setnames(data_Activity, names(data_Activity), "activity")
   
  # Grep the column with names having pattern 'mean()' or 'std()' 
  selectColumns<-(grepl("-mean\\()$",names(data_Observations)) &
                    !grepl("-meanFreq\\()",names(data_Observations)) | grepl("-std\\()$",names(data_Observations)))
  data_Observations<-data_Observations[,selectColumns]
  
  # column bind all the three data frames.
  data_All<-cbind(data_Activity, data_Observations)  
  data_All<-cbind(data_Subject, data_All)
    
  # set descriptive activity names for all activities
  data_activity_labels[,2]<-tolower(gsub("_"," ", data_activity_labels[,2]))
  data_All$activity<-as.factor(data_All$activity)
  setattr(data_All$activity, "levels", data_activity_labels[,2])  
  
  # Variables renamed in lower camel case for easy readability.
  # Features are renamed to make it more descriptive by substituting 
  # mean for -mean(), std for -std(), timedomain for t and frequencydomain for f
  names(data_All)<-gsub("-mean\\()","Mean", names(data_All)) 
  names(data_All)<-gsub("-std\\()","Std", names(data_All)) 
  names(data_All)<-gsub("^t","timeDomain", names(data_All)) 
  names(data_All)<-gsub("^f","frequencyDomain", names(data_All)) 
  names(data_All)<-gsub("BodyBody","Body", names(data_All)) 
  
  # Create multiple rows of unique id-variable combinations and save in a new data frame.
  tidydata<-melt(as.data.frame(data_All), id=c("subject",  "activity"))
  
  # Compute average of each variable for each activity and each subject.
  tidydata<-dcast(tidydata, subject + activity ~ variable, mean)  
  
  # Rename the measure variables as average and convert the names to lower case.
  names(tidydata)<-gsub("^timeDomain","avgTimeDomain", names(tidydata)) 
  names(tidydata)<-gsub("^frequencyDomain","avgFrequencyDomain", names(tidydata))  
  
  #write tidyData to a text file
  write.table(tidydata, file = "tidyData.txt", row.names = FALSE, col.names = TRUE)
  
}