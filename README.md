Tidy Data Assignment
================================================
Human Activity Recognition Using Smartphones Data Set 
--------------------------------

### Raw Data Set  

  * Data set was downloaded from the following link and unzipped into a local folder.    
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
  

  * Data Set description is available at the following link:    
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

  * Data Set Information:
    * This data set has obervations from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person was required to perform six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.  
    
    * Using the phone's embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity was observed for each subject while performing these activities. The gravitational and body motion components of the  sensor signals (accelerometer and gyroscope) for each observation has been separated and a vector of 561 features has been provided based on the time and frequency domain. 
    * Data set has following files:
      - 'README.txt'

      - 'features_info.txt': Shows information about the variables used on the feature vector.

      - 'features.txt': List of all features.

      - 'activity_labels.txt': Links the class labels with their activity name.

      - 'train/X_train.txt': Training set.

      - 'train/y_train.txt': Training labels.

      - 'test/X_test.txt': Test set.

      - 'test/y_test.txt': Test labels.

      - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

      - 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

      - 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

### Tidy Data Set 

  * Tidy data set summarises the mean and standard deviations of the time and frequency domain features of gravitational and body motion components of the  sensor signals for each observation. 
  
  * Since task is to extract only the measurements on the mean and standard deviation for each measurement, other features like `meanFreq` is not considered. 
  
  * Since features with mean and std suffixed by '-XYZ' denoting 3-axial signals in the X, Y and Z directions are used to estimate the `mean()` and `std()`, as indicated in the `feature_info.txt`, these features are ignored.

  * In total 18 features are extracted for tidy data set.
  
     * mean and std measures of time domain body acceleration magnitude 
     * mean and std measures of time domain gravity acceleration magnitude
     * mean and std measures of time domain body linear acceleration jerk magnitude
     * mean and std measures of time domain body angular velocity magnitude
     * mean and std measures of time domain body angular velocity jerk magnitude
     * mean and std measures of frequency domain body acceleration magnitude 
     * mean and std measures of frequency domain body linear acceleration jerk magnitude
     * mean and std measures of frequency domain body angular velocity magnitude
     * mean and std measures of frequency domain body angular velocity jerk magnitude
     
  
  * It presents the average of each such features  for each activity and each volunteer. Since 6 activities are performed by each of 30 volunteers, there are 180 data rows in total.
  
  * Variables:
  
    * Total number of variables: 20 
    * Variables have been renamed in lower camel case for easy readability and fulfills the convention as indicated here
    
          https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
          
    * subject: range 1:30, represents group of 30 volunteers on whom experiments where carried out.
    * activity: activities performed by each volunteer
    
              walking
              walkup
              walkdown
              sitting
              standing
              laying
              
    * avgTimeDomainBodyAccMagMean ->  average of tBodyAccMag-mean()
    * avgTimeDomainBodyAccMagStd ->  average of tBodyAccMag-std()
    * avgTimeDomainGravityAccMagMean -> average of tGravityAccMag-mean()
    * avgTimeDomainGravityAccMagStd ->  average of tGravityAccMag-std()
    * avgTimeDomainBodyAccJerkMagMean -> average of tBodyAccJerkMag-mean()
    * avgTimeDomainBodyAccJerkMagStd ->  average of tBodyAccJerkMag-std()
    * avgTimeDomainBodyGyroMagMean ->  average of tBodyGyroMag-mean()
    * avgTimeDomainBodyGyroMagStd -> average of tBodyGyroMag-std()
    * avgTimeDomainBodyGyroJerkMagMean -> average of tBodyGyroJerkMag-mean()
    * avgTimeDomainBodyGyroJerkMagStd -> average of tBodyGyroJerkMag-std()
    * avgFrequencyDomainBodyAccMagMean -> average of fBodyAccMag-mean()
    * avgFrequencyDomainBodyAccMagStd ->  average of fBodyAccMag-std()
    * avgFrequencyDomainBodyAccJerkMagMean -> average of fBodyBodyAccJerkMag-mean()
    * avgFrequencyDomainBodyAccJerkMagStd -> average of fBodyBodyAccJerkMag-std()
    * avgFrequencyDomainBodyGyroMagMean -> average of fBodyBodyGyroMag-mean()
    * avgFrequencyDomainBodyGyroMagStd -> average of fBodyBodyGyroMag-std()
    * avgFrequencyDomainBodyGyroJerkMagMean -> average of fBodyBodyGyroJerkMag-mean()
    * avgFrequencyDomainBodyGyroJerkMagStd -> average of fBodyBodyGyroJerkMag-std()

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

  * As _only_ the measurements on the mean and standard deviation for each measurement is required, `grep()` is used to extract these relevant columns. 
  
  * `grep()` is used get only those columns with `mean()` and `std()` at the end. This gives a vector of column names `selectColumns` only with `mean()` and `std()` as required.
  
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
          
