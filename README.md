#Codebook on run_analysis.R

Setup, there is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. I want to merge these data sets into one single data set, extract the mean and standard deviation measurement, and calculate the mean of these variables for each activity and each subject.

Raw data is: inertial signals which include the total and body acceleration signals in the X-Y-Z direction and body gyro signals in the X-Y-Z direction. These raw signals are then used to calculate the following signals:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

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

The set of variables that were estimated from these signals are: 

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

Additional vectors that are used on the angle() variable:

gravityMean : gravity mean
tBodyAccMean : mean of time domain body acceleration mean
tBodyAccJerkMean : mean of time domain body acceleration jerk
tBodyGyroMean : mean of time domain body gyro
tBodyGyroJerkMean : mean of time domain body gyro jerk

These variables values are stored in X_train.txt (for train subjects) and X_test.txt (for test subjects), while the complete list of variables names are available in features.txt

Each person performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying). The number associated with each activity is as follow:

1 Walking
2 Walking upstairs
3 Walking downstairs
4 Sitting
5 Standing
6 Laying

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

1 walk
2 walkupstair
3 walkdownstair
4 sit
5 stand
6 lay

The subject id, the activities, the signal variables data are then combined to create "finaldata" which has dimensions of:

10299 observations (rows) record of each activity for each subject
563 columns, which includes sunject id, activity, and 561 signal variables

The names of variables are then processed to remove "-" and "()" for ease in further analysis and indexing

##Guide to create tidy data set with the average of each variable for each activity and each subject.

Two seperate data sets are created from "finaldata"

activity_mean: this data set contains the mean of each signal variable in "finaldata" for each particular activity
subject_mean: this data set contains the mean of each signal variable in "finaldata" for each particular subject

In activity_mean data set, each variable name is modified to include "activity" at the end to note that this is the measurement for an activity, not a subject. Also, in subject_mean data set, each variable name is modified to include "subject" at the end to note that this is the measurement for a subject, not an activity.

Then two data sets are combined by the following method: for each subject id, there will be 6 associated activities(walk, walkupstair, walkdownstair, sit, stand, lay). These activities will be followed by the mean measurements for each activity, and following that is the mean measurement for that particular subject:

subjectid < activity < mean1-activity < mean2-activity < mean1-subject < mean2-subject
1           walk                  a                   g               A               B
1           walkupstair           b                   h               A               B
1           walkdownstair         c                   i               A               B
1           sit                   d                   j               A               B
1           stand                 e                   k               A               B
1           lay                   f                   l               A               B

The final data set will be stored in data set "new"

The dimension of "new":

30 subject x 6 activities = 180 observations (rows) 
160 variables (columns): include subject id, activity, mean of each variables for each activiti, mean of each variable for each subject
