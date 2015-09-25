---
title: "Codebook on run_analysis.R"
author: "Long Nguyen"
date: "09/24/2015"
output:
  html_document:
    keep_md: yes
---
#Project Description
Setup, there is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. I want to merge these data sets into one single data set, extract the mean and standard deviation measurement, and calculate the mean of these variables for each activity and each subject.

#Study design and data processing
##Collection of the raw data

Raw data is: inertial signals which include the total and body acceleration signals in the X-Y-Z direction and body gyro signals in the X-Y-Z direction. These raw signals are then used to calculate the following signals:
"XYZ" is used to denote 3-axial signals in the X, Y and Z directions.
```
tBodyAcc-XYZ : time domain body acceleration
tGravityAcc-XYZ : time domain gravity acceleration
tBodyAccJerk-XYZ : time domain body acceleration jerk
tBodyGyro-XYZ : time domain body gyro
tBodyGyroJerk-XYZ : time domain body gyro jerk
tBodyAccMag : time domain body acceleration magnitude
tGravityAccMag : time domain gravity acceleration magnitude
tBodyAccJerkMag : time domain body acceleration jerk magnitude
tBodyGyroMag : time domain body gyro magnitude
tBodyGyroJerkMag : time domain body gyro jerk magnitude
fBodyAcc-XYZ : frequency domain body acceleration
fBodyAccJerk-XYZ : frequency domain body acceleration jerk
fBodyGyro-XYZ : frequency domain body gyro
fBodyAccMag : frequency domain body acceleration magnitude
fBodyAccJerkMag : frequency domain body acceleration jerk magnitude
fBodyGyroMag : frequency domain body gyro magnitude
fBodyGyroJerkMag : frequency domain body gyro jerk magnitude
```
The set of variables that were estimated from these signals are: 
```
mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between two vectors.
```
Additional vectors that are used on the angle() variable:
```
gravityMean : gravity mean
tBodyAccMean : mean of time domain body acceleration mean
tBodyAccJerkMean : mean of time domain body acceleration jerk
tBodyGyroMean : mean of time domain body gyro
tBodyGyroJerkMean : mean of time domain body gyro jerk
```
These variables values are stored in X_train.txt (for train subjects) and X_test.txt (for test subjects), while the complete list of variables names are available in features.txt

Each person performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying). The number associated with each activity is as follow:
```
1 Walking
2 Walking upstairs
3 Walking downstairs
4 Sitting
5 Standing
6 Laying
```
These activity labels are stored in activity_labels.txt

Each activity is repeated several times for each subject. The signal variables as mentioned above are calculated for each performed activity. There are total 561 signal variables.

Each subject is assigned a subject id. Subject id ranges from 1 - 30. The information about which subject perform which particular activity is stored in subject_train.txt (for train subjects) and subject_test.txt (for test subject)

The task is to take information from the variable values files, the subject id file, the activity labels file, and the features file to create one complete data set that include all the measurements of all the activities for each subject id. Then it's required that all but the measurements of mean and standard deviation will be exluded from the date set. Names of the signal variables should be changed to make it easy for indexing and downstream analysis. Also each activity should be clearly labeled (not numbered) for easy reading  

##Guide to clean and create the tidy data:

First, the data for train subjects and test subjects are loaded into R. These data includes: signal variable values (X_train.txt. X_test.txt), subject id (sbject_train.txt, subject_test.txt), variable names (features.txt), and activity index number (y_train.txt, y_test.txt)

Then the variable names in features.txt is assigned to each column in X_train and X_test

Since activity index data set (for both train and test subjects) is just a column vector of index number without names, the column is assigned the name "activity"

The subject id data set (for both train and test subjects) is also just a column vector of ids with no name, the column is assigned the name "subjectid"

From the signal variables values X_train and X_test data, a function was run to retain only variables with the name "mean" or "std" since we only interested in mean and standard deviation measurements.

The activity index data set was orignially a factor with levels 1-6 with no labels for each level. File activity_labels.txt is loaded and each index number is assigned with a particular name:
```
1 walk
2 walkupstair
3 walkdownstair
4 sit
5 stand
6 lay
```
The subject id, the activities, the signal variables data are then combined to create "finaldata" which has dimensions of:

10299 observations (rows) record of each activity for each subject
563 columns, which includes sunject id, activity, and 561 signal variables

The names of variables are then processed to remove "-" and "()" for ease in further analysis and indexing.

Subject id is converted to factor and the signal variables are converted to numeric for downstream analysis.

##Guide to create tidy data set with the average of each variable for each activity and each subject.

Two seperate data sets are created from "finaldata"

activity_mean: this data set contains the mean of each signal variable in "finaldata" for each particular activity
subject_mean: this data set contains the mean of each signal variable in "finaldata" for each particular subject

In activity_mean data set, each variable name is modified to include "activity" at the end to note that this is the measurement for an activity, not a subject. Also, in subject_mean data set, each variable name is modified to include "subject" at the end to note that this is the measurement for a subject, not an activity.

Then two data sets are combined by the following method: for each subject id, there will be 6 associated activities(walk, walkupstair, walkdownstair, sit, stand, lay). These activities will be followed by the mean measurements for each activity, and following that is the mean measurement for that particular subject:
```
subjectid < activity < mean1-activity < mean2-activity < mean1-subject < mean2-subject
1           walk                  a                   g               A               B
1           walkupstair           b                   h               A               B
1           walkdownstair         c                   i               A               B
1           sit                   d                   j               A               B
1           stand                 e                   k               A               B
1           lay                   f                   l               A               B
```
Subject id and activity column are changed to factor for ease in further analysis and indexing

The final data set will be stored in data set "new" and export to newdata.txt

#Description of the variables in the newdata.txt file

The dimension: 

30 subject x 6 activities = 180 observations (rows) 
160 variables (columns): include subject id, activity, mean of each variables for each activity, mean of each variable for each subject

Subject id is a factor vector with levels 1-30 indicate the id for each subject.
Activity is a factor with levels: walk, walkupstair, walkdownstair, sit, stand, lay.
List of variables with "activity" at the end of name: indicate the mean of this particular measurement for each variable.
List of variables with "subject" at the end of name: indicate the mean of this particular measurement for each subject.

The example data structure is as follow:
```
subjectid < activity < mean1-activity < mean2-activity < mean1-subject < mean2-subject
1           walk                  a                   g               A               B
1           walkupstair           b                   h               A               B
1           walkdownstair         c                   i               A               B
1           sit                   d                   j               A               B
1           stand                 e                   k               A               B
1           lay                   f                   l               A               B
2           walk                  a                   g               C               D
2           walkupstair           b                   h               C               D
2           walkdownstair         c                   i               C               D
2           sit                   d                   j               C               D
2           stand                 e                   k               C               D
2           lay                   f                   l               C               D
```
Variables present in the newdata.txt:
```
 "subjectid"                            "activity"                             "tBodyAccmeanXactivity"               
 "tBodyAccmeanYactivity"                "tBodyAccmeanZactivity"                "tBodyAccstdXactivity"                
 "tBodyAccstdYactivity"                 "tBodyAccstdZactivity"                 "tGravityAccmeanXactivity"            
 "tGravityAccmeanYactivity"             "tGravityAccmeanZactivity"             "tGravityAccstdXactivity"             
 "tGravityAccstdYactivity"              "tGravityAccstdZactivity"              "tBodyAccJerkmeanXactivity"           
 "tBodyAccJerkmeanYactivity"            "tBodyAccJerkmeanZactivity"            "tBodyAccJerkstdXactivity"            
 "tBodyAccJerkstdYactivity"             "tBodyAccJerkstdZactivity"             "tBodyGyromeanXactivity"              
 "tBodyGyromeanYactivity"               "tBodyGyromeanZactivity"               "tBodyGyrostdXactivity"               
 "tBodyGyrostdYactivity"                "tBodyGyrostdZactivity"                "tBodyGyroJerkmeanXactivity"          
 "tBodyGyroJerkmeanYactivity"           "tBodyGyroJerkmeanZactivity"           "tBodyGyroJerkstdXactivity"           
 "tBodyGyroJerkstdYactivity"            "tBodyGyroJerkstdZactivity"            "tBodyAccMagmeanactivity"             
 "tBodyAccMagstdactivity"               "tGravityAccMagmeanactivity"           "tGravityAccMagstdactivity"           
 "tBodyAccJerkMagmeanactivity"          "tBodyAccJerkMagstdactivity"           "tBodyGyroMagmeanactivity"            
 "tBodyGyroMagstdactivity"              "tBodyGyroJerkMagmeanactivity"         "tBodyGyroJerkMagstdactivity"         
 "fBodyAccmeanXactivity"                "fBodyAccmeanYactivity"                "fBodyAccmeanZactivity"               
 "fBodyAccstdXactivity"                 "fBodyAccstdYactivity"                 "fBodyAccstdZactivity"                
 "fBodyAccmeanFreqXactivity"            "fBodyAccmeanFreqYactivity"            "fBodyAccmeanFreqZactivity"           
 "fBodyAccJerkmeanXactivity"            "fBodyAccJerkmeanYactivity"            "fBodyAccJerkmeanZactivity"           
 "fBodyAccJerkstdXactivity"             "fBodyAccJerkstdYactivity"             "fBodyAccJerkstdZactivity"            
 "fBodyAccJerkmeanFreqXactivity"        "fBodyAccJerkmeanFreqYactivity"        "fBodyAccJerkmeanFreqZactivity"       
 "fBodyGyromeanXactivity"               "fBodyGyromeanYactivity"               "fBodyGyromeanZactivity"              
 "fBodyGyrostdXactivity"                "fBodyGyrostdYactivity"                "fBodyGyrostdZactivity"               
 "fBodyGyromeanFreqXactivity"           "fBodyGyromeanFreqYactivity"           "fBodyGyromeanFreqZactivity"          
 "fBodyAccMagmeanactivity"              "fBodyAccMagstdactivity"               "fBodyAccMagmeanFreqactivity"         
 "fBodyBodyAccJerkMagmeanactivity"      "fBodyBodyAccJerkMagstdactivity"       "fBodyBodyAccJerkMagmeanFreqactivity" 
 "fBodyBodyGyroMagmeanactivity"         "fBodyBodyGyroMagstdactivity"          "fBodyBodyGyroMagmeanFreqactivity"    
 "fBodyBodyGyroJerkMagmeanactivity"     "fBodyBodyGyroJerkMagstdactivity"      "fBodyBodyGyroJerkMagmeanFreqactivity"
 "tBodyAccmeanXsubject"                 "tBodyAccmeanYsubject"                 "tBodyAccmeanZsubject"                
 "tBodyAccstdXsubject"                  "tBodyAccstdYsubject"                  "tBodyAccstdZsubject"                 
 "tGravityAccmeanXsubject"              "tGravityAccmeanYsubject"              "tGravityAccmeanZsubject"             
 "tGravityAccstdXsubject"               "tGravityAccstdYsubject"               "tGravityAccstdZsubject"              
 "tBodyAccJerkmeanXsubject"             "tBodyAccJerkmeanYsubject"             "tBodyAccJerkmeanZsubject"            
 "tBodyAccJerkstdXsubject"              "tBodyAccJerkstdYsubject"              "tBodyAccJerkstdZsubject"             
 "tBodyGyromeanXsubject"                "tBodyGyromeanYsubject"                "tBodyGyromeanZsubject"               
 "tBodyGyrostdXsubject"                 "tBodyGyrostdYsubject"                 "tBodyGyrostdZsubject"                
 "tBodyGyroJerkmeanXsubject"            "tBodyGyroJerkmeanYsubject"            "tBodyGyroJerkmeanZsubject"           
 "tBodyGyroJerkstdXsubject"             "tBodyGyroJerkstdYsubject"             "tBodyGyroJerkstdZsubject"            
 "tBodyAccMagmeansubject"               "tBodyAccMagstdsubject"                "tGravityAccMagmeansubject"           
 "tGravityAccMagstdsubject"             "tBodyAccJerkMagmeansubject"           "tBodyAccJerkMagstdsubject"           
 "tBodyGyroMagmeansubject"              "tBodyGyroMagstdsubject"               "tBodyGyroJerkMagmeansubject"         
 "tBodyGyroJerkMagstdsubject"           "fBodyAccmeanXsubject"                 "fBodyAccmeanYsubject"                
 "fBodyAccmeanZsubject"                 "fBodyAccstdXsubject"                  "fBodyAccstdYsubject"                 
 "fBodyAccstdZsubject"                  "fBodyAccmeanFreqXsubject"             "fBodyAccmeanFreqYsubject"            
 "fBodyAccmeanFreqZsubject"             "fBodyAccJerkmeanXsubject"             "fBodyAccJerkmeanYsubject"            
 "fBodyAccJerkmeanZsubject"             "fBodyAccJerkstdXsubject"              "fBodyAccJerkstdYsubject"             
 "fBodyAccJerkstdZsubject"              "fBodyAccJerkmeanFreqXsubject"         "fBodyAccJerkmeanFreqYsubject"        
 "fBodyAccJerkmeanFreqZsubject"         "fBodyGyromeanXsubject"                "fBodyGyromeanYsubject"               
 "fBodyGyromeanZsubject"                "fBodyGyrostdXsubject"                 "fBodyGyrostdYsubject"                
 "fBodyGyrostdZsubject"                 "fBodyGyromeanFreqXsubject"            "fBodyGyromeanFreqYsubject"           
 "fBodyGyromeanFreqZsubject"            "fBodyAccMagmeansubject"               "fBodyAccMagstdsubject"               
 "fBodyAccMagmeanFreqsubject"           "fBodyBodyAccJerkMagmeansubject"       "fBodyBodyAccJerkMagstdsubject"       
 "fBodyBodyAccJerkMagmeanFreqsubject"   "fBodyBodyGyroMagmeansubject"          "fBodyBodyGyroMagstdsubject"          
 "fBodyBodyGyroMagmeanFreqsubject"      "fBodyBodyGyroJerkMagmeansubject"      "fBodyBodyGyroJerkMagstdsubject"      
 "fBodyBodyGyroJerkMagmeanFreqsubject"
```
##Variable description

###subjectid

Range: 1-30. The id number of each subject. 

Factor variable. 
Levels : 1-30.
No unit of measurement.

###activity

The namme of the activities being tested. 

Factor variable. 
Levels : walk, walkupstair, walkdownstair, sit, stand, lay
No unit of measurement.

###tBodyAccmeanXactivity

The mean of time domain body acceleration mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccmeanYactivity

The mean of time domain body acceleration mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccmeanZactivity

The mean of time domain body acceleration mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdXactivity

The mean of time domain body acceleration standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdYactivity

The mean of time domain body acceleration standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdZactivity

The mean of time domain body acceleration standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanXactivity

The mean of time domain gravity acceleration mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanYactivity

The mean of time domain gravity acceleration mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanZactivity

The mean of time domain gravity acceleration mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdXactivity

The mean of time domain gravity acceleration standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdYactivity

The mean of time domain gravity acceleration standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdZactivity

The mean of time domain gravity acceleration standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccJerkmeanXactivity

The mean of time domain body acceleration jerk mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkmeanYactivity

The mean of time domain body acceleration jerk mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkmeanZactivity

The mean of time domain body acceleration jerk mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdXactivity

The mean of time domain body acceleration jerk standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdYactivity

The mean of time domain body acceleration jerk standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdZactivity

The mean of time domain body acceleration jerk standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyromeanXactivity

The mean of time domain body gyro mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyromeanYactivity

The mean of time domain body gyro mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyromeanZactivity

The mean of time domain body gyro mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdXactivity

The mean of time domain body gyro standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdYactivity

The mean of time domain body gyro standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdZactivity

The mean of time domain body gyro standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyroJerkmeanXactivity

The mean of time domain body gyro jerk mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkmeanYactivity

The mean of time domain body gyro jerk mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkmeanZactivity

The mean of time domain body gyro jerk mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdXactivity

The mean of time domain body gyro jerk standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdYactivity

The mean of time domain body gyro jerk standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdZactivity

The mean of time domain body gyro jerk standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccMagmeanactivity

The mean of time domain body acceleration magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tBodyAccMagstdactivity

The mean of time domain body acceleration magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tGravityAccMagmeanactivity

The mean of time domain gravity acceleration magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tGravityAccMagstdactivity

The mean of time domain gravity acceleration magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tBodyAccJerkMagmeanactivity

The mean of time domain body acceleration jerk magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###tBodyAccJerkMagstdactivity

The mean of time domain body acceleration jerk magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroMagmeanactivity

The mean of time domain body gyro magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###tBodyGyroMagstdactivity

The mean of time domain body gyro magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###tBodyGyroJerkMagmeanactivity

The mean of time domain body gyro jerk magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###tBodyGyroJerkMagstdactivity

The mean of time domain body gyro jerk magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###fBodyAccmeanXactivity

The mean of frequency domain body acceleration mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanYactivity

The mean of frequency domain body acceleration mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanZactivity

The mean of frequency domain body acceleration mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdXactivity

The mean of frequency domain body acceleration standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdYactivity

The mean of frequency domain body acceleration standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdZactivity

The mean of frequency domain body acceleration standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanFreqXactivity

The mean of frequency domain body acceleration mean frequency in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccmeanFreqYactivity

The mean of frequency domain body acceleration mean frequency in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccmeanFreqZactivity

The mean of frequency domain body acceleration mean frequency in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccJerkmeanXactivity

The mean of frequency domain body acceleration jerk mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanYactivity

The mean of frequency domain body acceleration jerk mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanZactivity

The mean of frequency domain body acceleration jerk mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdXactivity

The mean of frequency domain body acceleration jerk standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdYactivity

The mean of frequency domain body acceleration jerk standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdZactivity

The mean of frequency domain body acceleration jerk standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanFreqXactivity

The mean of frequency domain body acceleration jerk mean frequency in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyAccJerkmeanFreqYactivity

The mean of frequency domain body acceleration jerk mean frequency in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyAccJerkmeanFreqZactivity

The mean of frequency domain body acceleration jerk mean frequency in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyGyromeanXactivity

The mean of frequency domain body gyro mean in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanYactivity

The mean of frequency domain body gyro mean in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanZactivity

The mean of frequency domain body gyro mean in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdXactivity

The mean of frequency domain body gyro standard deviation in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdYactivity

The mean of frequency domain body gyro standard deviation in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdZactivity

The mean of frequency domain body gyro standard deviation in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanFreqXactivity

The mean of frequency domain body gyro mean frequency in X direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyGyromeanFreqYactivity

The mean of frequency domain body gyro mean frequency in Y direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyGyromeanFreqZactivity

The mean of frequency domain body gyro mean frequency in Z direction per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccMagmeanactivity

The mean of frequency domain body acceleration magnitude mean per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###fBodyAccMagstdactivity

The mean of frequency domain body acceleration magnitude standard deviation per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###fBodyAccMagmeanFreqactivity

The mean of frequency domain body acceleration magnitude mean frequency per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. Weighted average of the frequency components to obtain a mean frequency

###fBodyBodyAccJerkMagmeanactivity

The mean of frequency domain body acceleration jerk magnitude averages per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyAccJerkMagstdactivity

The mean of frequency domain body acceleration jerk magnitude standard deviations per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyAccJerkMagmeanFreqactivity

The mean of frequency domain body acceleration jerk magnitude mean frequencies per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyBodyGyroMagmeanactivity

The mean of frequency domain body gyro magnitude averages per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###fBodyBodyGyroMagstdactivity

The mean of frequency domain body gyro magnitude standard deviations per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###fBodyBodyGyroMagmeanFreqactivity

The mean of frequency domain body gyro magnitude mean frequencies per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. Weighted average of the frequency components to obtain a mean frequency.

###fBodyBodyGyroJerkMagmeanactivity

The mean of frequency domain body gyro jerk magnitude averages per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyGyroJerkMagstdactivity

The mean of frequency domain body gyro jerk magnitude standard deviations per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyGyroJerkMagmeanFreqactivity

The mean of frequency domain body gyro jerk magnitude mean frequencies per activity

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Weighted average of the frequency components to obtain a mean frequency.

###tBodyAccmeanXsubject

The mean of time domain body acceleration mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccmeanYsubject

The mean of time domain body acceleration mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccmeanZsubject

The mean of time domain body acceleration mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdXsubject

The mean of time domain body acceleration standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdYsubject

The mean of time domain body acceleration standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccstdZsubject

The mean of time domain body acceleration standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanXsubject

The mean of time domain gravity acceleration mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanYsubject

The mean of time domain gravity acceleration mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccmeanZsubject

The mean of time domain gravity acceleration mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdXsubject

The mean of time domain gravity acceleration standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdYsubject

The mean of time domain gravity acceleration standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tGravityAccstdZsubject

The mean of time domain gravity acceleration standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

###tBodyAccJerkmeanXsubject

The mean of time domain body acceleration jerk mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkmeanYsubject

The mean of time domain body acceleration jerk mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkmeanZsubject

The mean of time domain body acceleration jerk mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdXsubject

The mean of time domain body acceleration jerk standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdYsubject

The mean of time domain body acceleration jerk standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccJerkstdZsubject

The mean of time domain body acceleration jerk standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyromeanXsubject

The mean of time domain body gyro mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyromeanYsubject

The mean of time domain body gyro mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyromeanZsubject

The mean of time domain body gyro mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdXsubject

The mean of time domain body gyro standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdYsubject

The mean of time domain body gyro standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyrostdZsubject

The mean of time domain body gyro standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

###tBodyGyroJerkmeanXsubject

The mean of time domain body gyro jerk mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkmeanYsubject

The mean of time domain body gyro jerk mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkmeanZsubject

The mean of time domain body gyro jerk mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdXsubject

The mean of time domain body gyro jerk standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdYsubject

The mean of time domain body gyro jerk standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroJerkstdZsubject

The mean of time domain body gyro jerk standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyAccMagmeansubject

The mean of time domain body acceleration magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tBodyAccMagstdsubject

The mean of time domain body acceleration magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tGravityAccMagmeansubject

The mean of time domain gravity acceleration magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tGravityAccMagstdsubject

The mean of time domain gravity acceleration magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###tBodyAccJerkMagmeansubject

The mean of time domain body acceleration jerk magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###tBodyAccJerkMagstdsubject

The mean of time domain body acceleration jerk magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###tBodyGyroMagmeansubject

The mean of time domain body gyro magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###tBodyGyroMagstdsubject

The mean of time domain body gyro magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###tBodyGyroJerkMagmeansubject

The mean of time domain body gyro jerk magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###tBodyGyroJerkMagstdsubject

The mean of time domain body gyro jerk magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: these time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals 

###fBodyAccmeanXsubject

The mean of frequency domain body acceleration mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanYsubject

The mean of frequency domain body acceleration mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanZsubject

The mean of frequency domain body acceleration mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdXsubject

The mean of frequency domain body acceleration standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdYsubject

The mean of frequency domain body acceleration standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccstdZsubject

The mean of frequency domain body acceleration standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyAccmeanFreqXsubject

The mean of frequency domain body acceleration mean frequency in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccmeanFreqYsubject

The mean of frequency domain body acceleration mean frequency in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccmeanFreqZsubject

The mean of frequency domain body acceleration mean frequency in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccJerkmeanXsubject

The mean of frequency domain body acceleration jerk mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanYsubject

The mean of frequency domain body acceleration jerk mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanZsubject

The mean of frequency domain body acceleration jerk mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdXsubject

The mean of frequency domain body acceleration jerk standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdYsubject

The mean of frequency domain body acceleration jerk standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkstdZsubject

The mean of frequency domain body acceleration jerk standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyAccJerkmeanFreqXsubject

The mean of frequency domain body acceleration jerk mean frequency in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyAccJerkmeanFreqYsubject

The mean of frequency domain body acceleration jerk mean frequency in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyAccJerkmeanFreqZsubject

The mean of frequency domain body acceleration jerk mean frequency in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyGyromeanXsubject

The mean of frequency domain body gyro mean in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanYsubject

The mean of frequency domain body gyro mean in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanZsubject

The mean of frequency domain body gyro mean in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdXsubject

The mean of frequency domain body gyro standard deviation in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdYsubject

The mean of frequency domain body gyro standard deviation in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyrostdZsubject

The mean of frequency domain body gyro standard deviation in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. 

###fBodyGyromeanFreqXsubject

The mean of frequency domain body gyro mean frequency in X direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyGyromeanFreqYsubject

The mean of frequency domain body gyro mean frequency in Y direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyGyromeanFreqZsubject

The mean of frequency domain body gyro mean frequency in Z direction per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. Weighted average of the frequency components to obtain a mean frequency

###fBodyAccMagmeansubject

The mean of frequency domain body acceleration magnitude mean per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###fBodyAccMagstdsubject

The mean of frequency domain body acceleration magnitude standard deviation per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm.

###fBodyAccMagmeanFreqsubject

The mean of frequency domain body acceleration magnitude mean frequency per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. Weighted average of the frequency components to obtain a mean frequency

###fBodyBodyAccJerkMagmeansubject

The mean of frequency domain body acceleration jerk magnitude averages per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyAccJerkMagstdsubject

The mean of frequency domain body acceleration jerk magnitude standard deviations per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyAccJerkMagmeanFreqsubject

The mean of frequency domain body acceleration jerk magnitude mean frequencies per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Weighted average of the frequency components to obtain a mean frequency.

###fBodyBodyGyroMagmeansubject

The mean of frequency domain body gyro magnitude averages per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###fBodyBodyGyroMagstdsubject

The mean of frequency domain body gyro magnitude standard deviations per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. 

###fBodyBodyGyroMagmeanFreqsubject

The mean of frequency domain body gyro magnitude mean frequencies per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. Weighted average of the frequency components to obtain a mean frequency.

###fBodyBodyGyroJerkMagmeansubject

The mean of frequency domain body gyro jerk magnitude averages per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyGyroJerkMagstdsubject

The mean of frequency domain body gyro jerk magnitude standard deviations per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals

###fBodyBodyGyroJerkMagmeanFreqsubject

The mean of frequency domain body gyro jerk magnitude mean frequencies per subject

Numeric variable. 
No unit of measurement.

Notes: The signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. The acceleration signal was separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. A Fast Fourier Transform (FFT) was applied to these signals to produce frequency domain signals. The magnitude of these three-dimensional signals were calculated using the Euclidean norm. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Weighted average of the frequency components to obtain a mean frequency.
