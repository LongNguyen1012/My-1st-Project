#Instruction on run_analysis.R

There are two folders that contain the traaining dataset and the test dataset
In each folder is an Inertial signal which contains the gravitation and body signal from Samsung device
These signals are then used to calculate variables such as body acceleration mean, standarad deviation.
There are 561 variables correspond to each column in x data (for each folder train and test)
Each row in the x data correspond to a particular activity (walking, walking upstairs, etc.)
The y data tells exactly which row of x belongs to which activity.
The subject data tells which row (activity) of x belongs to which subject. Each row of subject is a number indicating subject id.

The procedure in run_analysis.R combinds the x, y, and subject data set to create one data for test and train subjects.
Each data created has the subject id, it's activity, and the variable (acceleration mean, standard deviation, etc.) associated with that paricular movement of that subject.

The data for train subjects is called traindata and testdata

These data are then combined to create one final data (finaldata) which contains values for each activity of each subject both in train and test groups

This data is then filtered to select only mean and standard deviation variables

This final data is then split by activity and subject id to create two datasets:
* One is the activity and the mean of each variable for each activity. Each variable able is appended by the word "activity" to indicate the mean value is for a particular activity. For example "fBodyBodyGyroJerkMagmeanFreqactivity" means the mean of "fBodyBodyGyroJerkMagmean" value for a particular activity 
* One is tha subject id and the mean of each variable for each subject id. Each variable is appended by the word "subject" to indicate the mean value is for each subject. For example "fBodyBodyGyroJerkMagmeanFreqsubject" means the mean of "fBodyBodyGyroJerkMagmean" value for a particular subject

These two datasets are later combined to create one datasets with subject id, it's activity , the means of variables for each activity and the means of variables for each subject
