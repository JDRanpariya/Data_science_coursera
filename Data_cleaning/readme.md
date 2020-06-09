 IT'S PROJECT FROM COURSERA IN DATA CLEANING
 some steps taken are:
 - load required packages
 - download the zip file and unzip it ( don't forget to save the current dir in variable )
 - get the activity labels and features using fread and set the col names filter on (mean|std) funcs.
 - now get the data from the train set using fread and set the col names to one that are present as featurenames
 - do same for the test data set
 - after that combine both test and train using cbind
 - then factor it & use melt to dcast the data into required formate
 - write your tidydataset into txt file using either fwrite to write.table()
