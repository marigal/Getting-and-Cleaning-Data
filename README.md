GThis repository has been created to contain the work developed for the Course Project from “Getting and Cleaning Data”.

There are three files:

1.	README.md: a brief description of the assignment
2.	CodeBook: a larger description of the assignment, including organization of data inside the files
3.	run_analysis.R: R script performing the tasks from the Course Project.

The data are downloaded and uncompressed inside the working directory.
First they are assigned to various data.tables, and conveniently labeled. 

Then, they are merged in a big data.table (Data), which is also labeled.

Then, data on mean and std from the variables is extracted in a subset (sub_Data)

Finally, from sub_Data, a second, independent tidy data set with the average of each variable for each activity and each subject is created. Function “aggregate” is used here.

A file called “tidy_data.txt” is created (the one uploaded at the Course Project.)

