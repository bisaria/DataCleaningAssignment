Tidy Data Assignment
================================================
Human Activity Recognition Using Smartphones Data Set 
--------------------------------

### Assignment
  Create one R script `run_analysis.R` to do the following: 

  1. Merge the training and the test sets to create one data set.
  2. Extract only the measurements on the mean and standard deviation for each measurement. 
  3. Use descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive feature names. 
  5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

##### Step 1 : Merge the training and the test sets

  * The required dataset was downloaded and unzipped in a local directory using the following R script
  
        get_zip_file <- function(zipdir, url) 
        {            
          #Create a temp file to save the downloaded zipped file          
          temp <- tempfile()   
          
          #download the file from the given url         
          download.file(url, temp) 
          
          #Create the zipdir directory         
          dir.create(zipdir)    
          
          #Unzip the file into the directory         
          unzip(temp, exdir = zipdir)     
        }
        
  * Local directory is assigned to `zipdir` in order to access all the relevant files.
  
        zipdir<-"UCI HAR Dataset"
  
  * Observed Data from `train/X_train.txt` and `test/X_test.txt` is read into data frames `data_Train` and `data_Test` respectively from appropriate folders in `zipdir`, 
  
        data_Train<-read.table(paste(zipdir,"train/X_train.txt", sep= "/"), stringsAsFactors = FALSE)
        data_Test<-read.table(paste(zipdir,"test/X_test.txt", sep= "/"), stringsAsFactors = FALSE)
        
  * Subject Info from `train/subject_train.txt` and `test/subject_test.txt` is read into data frames `data_SubTrain` and `data_SubTest` respectively, 
        
        data_SubTrain<-read.table(paste(zipdir,"train/subject_train.txt", sep= "/"), stringsAsFactors = FALSE)
        data_SubTest<-read.table(paste(zipdir,"test/subject_test.txt", sep= "/"), stringsAsFactors = FALSE)       
  
  * Labels from `train/y_train.txt` and `test/y_test.txt` is read into data frames `data_Train_Activity` and `data_Test_Activity` respectively,
      
        data_Train_Activity<-read.table(paste(zipdir,"train/y_train.txt", sep= "/"), stringsAsFactors = FALSE)
        data_Test_Activity<-read.table(paste(zipdir,"test/y_test.txt", sep= "/"), stringsAsFactors = FALSE)
        

  * List of all features from `features.txt` is read into data frame `data_features`. These are the 561 observed variables in the Train and Test data sets.
  
        data_features<-read.table(paste(zipdir,"features.txt", sep= "/"), stringsAsFactors = FALSE)
        
  * Activity name for each activity, which has been provided in the file `activity_labels.txt`, is loaded into to data frame  `data_activity_labels`, which will be used in Step 3.
  
        data_activity_labels<-read.table(paste(zipdir,"activity_labels.txt", sep= "/"), stringsAsFactors = FALSE)        
  
  * Data frame `data_Train` and `data_Test` are merged together using rbind() into data frame `data_Observations`.
  
        data_Observations<-rbind(data_Train, data_Test)
  
  * Data frame `data_SubTrain` and `data_SubTest` are merged together using rbind() into data frame `data_Subject`.
  
        data_Subject<-rbind(data_SubTrain,data_SubTest)
  
  * Data frame `data_Train_Activity` and `data_Test_Activity` are merged together using rbind() into data frame `data_Activity`.
  
        data_Activity<-rbind(data_Train_Activity, data_Test_Activity)
  
  * Column names for data frame `data_Observations` is assigned as
  
        setnames(data_Observations,names(data_Observations), data_features[,2])
  
  * Column names for `data_SubTrain` and  `data_Train_Activity` is also assigned as
  
        setnames(data_Subject, names(data_Subject), "subject")         
        setnames(data_Activity, names(data_Activity), "activity")
      
##### Step 2 : Extract only the measurements on the mean and standard deviation for each measurement     

  * As _only_ the measurements on the mean and standard deviation for each measurement is required, `grepl()` is used to extract these relevant columns. 
  
  * `grepl()` is used get only those columns with `mean()` and `std()` at the end. This gives a logical vector of column names `selectColumns` only with `mean()` and `std()` as required.
  
        selectColumns<-(grepl("-mean\\()$",names(data_Observations)) &
                    !grepl("-meanFreq\\()",names(data_Observations)) | 
                     grepl("-std\\()$",names(data_Observations)))
    
  * `selectColumns` is used to extract only the relevant columns from the `data_Observations` data frame.
  
        data_Observations<-data_Observations[,selectColumns]
  
  * Now, all three data frames are ready to be merged together by `cbind()` to create one complete data frame `data_All`
  
        data_All<-cbind(data_Activity, data_Observations)  
        data_All<-cbind(data_Subject, data_All)
  
##### Step 3 : Descriptive activity names for the activities in the data set

  * Activity name for each activity, which has been loaded into data frame `data_activity_labels` in Step 1, is used to give proper description. Remove "_" from the activity label and convert it to lower case.
  
        data_activity_labels[,2]<-gsub("WALKING_UPSTAIRS","walkup", data_activity_labels[,2])
        data_activity_labels[,2]<-gsub("WALKING_DOWNSTAIRS","walkdown", data_activity_labels[,2])
        data_activity_labels[,2]<-tolower(gsub("_"," ", data_activity_labels[,2]))
        
  * `activity` column of data frame `data_All` is converted to factor as
  
        data_All$activity<-as.factor(data_All$activity)
    
  * Appropriate labels are assigned to the levels as
  
        setattr(data_All$activity, "levels", data_activity_labels[,2])
        
##### Step 4 : Descriptive feature names for the selected features in the data set 

  * Lower camel case is adopted for renaming the features for easy readability.
  
  * Features are renamed to make it more descriptive by substituting `Mean` for `-mean()`, `Std` for `-std()`,
  `timeDomain` for `t` and `frequencyDomain` for `f`.   
  
        names(data_All)<-gsub("-mean\\()","Mean", names(data_All)) 
        names(data_All)<-gsub("-std\\()","Std", names(data_All)) 
        names(data_All)<-gsub("^t","timeDomain", names(data_All)) 
        names(data_All)<-gsub("^f","frequencyDomain", names(data_All)) 
        
  * There appeared to be an error in the naming of some features in the original dataset, 
  for example `fBodyBodyGyroJerkMag-mean()` has `Body` repeated twice, hence all occurence of `BodyBody` is replaced by `Body`
        
        names(data_All)<-gsub("BodyBody","Body", names(data_All))           
  
##### Step 5 : Create a second, independent tidy data set with the average of each variable for each activity and each subject.

  * Assignment suggests to find variables pertaining to mean and standard deviations of various observations and produce a tidy dataset of the average of these variables for each combination of subject and activity.
  
  * It is assumed that tidy data set is to be created for _each variable_ extracted in previous step.

  * `library(reshape2)` is required to perform this final step.

  * `melt()` is used on `data_All` with `id=c("subject",  "activity")` to create multiple rows of unique id-variable combinations.
  
        tidydata<-melt(as.data.frame(data_All), id=c("subject",  "activity"))
        
  * Average of each variable for each activity and each subject is computed into final data frame `tidydata` using `dcast()` 
  
        tidydata<-dcast(tidydata, subject + activity ~ variable, mean) 
        
  * Rename all measure variables with prefix `avg` and maintaine the lower camel case convention.
  
        names(tidydata)<-gsub("^timeDomain","avgTimeDomain", names(tidydata)) 
        names(tidydata)<-gsub("^frequencyDomain","avgFrequencyDomain", names(tidydata)) 
    
  * Write tidy data to a text file.
        
        write.table(tidydata, file = "tidyData.txt", row.names = FALSE, col.names = TRUE)
          
