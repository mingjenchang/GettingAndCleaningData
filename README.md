# Getting And Cleaning Data

This document is to explain how run_analysis.R is built step by step and why those 
variables are picked up.

###0. Preparing Data

As per instruction of course project, I download the project file and unzip to 
"UCI HAR Dataset" on home directory and load them into datasets via read.table()
function. 8 datasets are created in total, 3 test files(x,y,subject), 3 training files,
features and activity_labels files. Once datasets are created, column names are added 
to each datasets. Column names of x files are sourced from features dataset while y and
subject file are given 'activity' and 'subject' as column name.

###1. Merges the training and the test sets to create one data set.

Firstly, use cbind() to merge subjecttest, ytest, xtest datasets into test dataset and 
then repeat same step for training datasets. Finally, merge test and train datasets into 
mergedata dataset via rbind().

###2. Extracts only the measurements on the mean and standard deviation for each measurement.

As per the instruction, search for mean() and std() in the features dataset as variable
name of measurement. 66 variables are found in total. Some variables with meanFreq() in
their names are not included because the definition is "Weighted average of the frequency
components to obtain a mean frequency", not exactly the mean value. To search for mean()
or std() is done by grep() and extract new dataset called extractdata via subset().

###3. Uses descriptive activity names to name the activities in the data set

To achieve this, simply maps activity(1 to 6) to activity names (WALKING, WALKING_UPSTAIR,
etc.). Firstly, convert activity from integer to character. Then use factor() to map them 
into activity names.

###4. Appropriately labels the data set with descriptive variable names.

The variable names contains mostly abbreviation and may cause confusion. To appropriately
label them, I have done following replacement via sub(), to replace abbreviation with 
complete word and capitalise the first letter.
	std() -> StandardDeviation
	tBody -> TimeBody
	tGravity -> TimeGravity
	fBody -> FrequencyBody
	Acc -> Acceleration
	Gyco -> Gyroscopic
	Mag -> Magnitude
	BodyBody -> Body (this is to fix typo)
	
Above replacements are done by a function called relabel and then use to replace column 
names of extractdata dataset.

###5. From the data set in step 4, creates a second, independent tidy data set with the 
average of each variable for each activity and each subject.

Use aggregate() to group subject and activity, and calculate average of each variable.
The new tidy data set has 180 rows, which come from 30 subjects and 6 activities. And
66 average of variables are presented as new measurements.
	

