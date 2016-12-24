# Coursera---Getting-and-Cleaning-Data---Assignment
Files created for assignment in week 4 of Getting and Cleaning Data
Assignment based on data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The "run_analysis.R" program will initially check if the data file is already saved in the local work directory.
If not found it will be downloaded to run the program.

Program steps are as follows:
0. Load and name all datasets
1. Merge training & test sets to create one data set. (total of 561 variables)
2. Extract only mean and std dev for each measurement 
2.1 Search for "mean" / "Mean" / "std" / "Std" anywhere in each label = 86 variables
2.2 Filter combined data (reduced from 561 to 86 variables)
3. Use descriptive activity names to name the activities in the data set
3.1 Replace integers with characters, then replace one type after the other, i.e. 1=Walking, 5=Standing
4. Appropriately label the data set with descriptive variable names
4.1 Eliminate abbreviations = long but self explanatory titles
5. From step 4 data set, create 2nd, independent tidy data set with avg of each variable for each activity and each subject
6. Save file from step 5 as "average_tidy.txt" in working directory
