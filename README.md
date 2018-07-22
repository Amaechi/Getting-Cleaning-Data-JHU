# Getting-Cleaning-Data-JHU

The output files within this repo are in response to the JHU Coursera "Getting and Cleaning Data" course.

The file "run_analysis.R" contains the set of code to read in, restructure, merge and output data ready for data analysis.

The file "codebook.Rmd" gives a more detailed explanation of the actions undertaken to prepare the raw data for analysis.

The file "tidyDataSet.txt" is the output of the raw data wrangling to produce a tidy data set for actual data analysis 

An R script is created and saved as run_analysis.R 

The UCI HAR Dataset folders are downloaded and unzipped into the following: 
* test folder 
* train folder
* activity_labels.txt
* features_info.txt
* features.txt
* README.txt

Extract and read in .txt files from test folder and train folder along with features.txt and activity_labels.txt files. These are read into the following files:
* subjectTest
* xTest
* yTest
* subjectTrain
* xTrain
* yTrain

The inertial signals folder is ignored.

Merge the test (subjectTest, xTest, yTest) and train (subjectTrain, xTrain, yTrain) data (via cbind and rbind) into mergedTestTrain.

Search through merged data and extract measurements on the mean and standard deviation for each measurement, using grepl() and store the selected value locations within *meanSD*.

Include activity labels to merged test and train data such as:
1. WALKING
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING

Replace abbreviated names using more descriptive variable names such as:
* from "*t*" to "time"
* from "*f*" to "frequency"
* from "*Acc*" to "Accelerometer"
* from "*Gyro*" to "Gyroscope" 
* from "*Mag*" to "Magnitude"
* from "*BodyBody*" to "Body"

Generate a new text file with cleaned up data and write to "tidyDataSet.txt".
