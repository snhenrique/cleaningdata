
Getting and Cleaning Data Course Project - Code Book
=======================================================

Course: Data Science - Johns Hopkins University

Author: Sandro Henrique


## Description

Detailed information about the original data can be found at
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Data Set Information

The files in UCI HAR Dataset contain results of experiments with 30
volunteers (subjects),performing six activities (Laying, Standing, Sitting, Walking, Walking
downstairs and upstairs) with a smartphone (Samsung) on the waist.

Using an embedded accelerometer and gyroscope, it were captured 3-axial
linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.

The dataset has been randomly partitioned into two sets, where 70% of
the volunteers was selected for generating the training data and 30% the test data, to
be used in machine learning experiments.

The dataset contains a 561-feature vector with time and frequency domain
variables, an activity label and an identifier of the subject.



## Cleaning Data

Following project instructions, from the original datasets, were used in
this project:

1.  Merged train and test data (10K+ regs), from where were selected
    mean and standard deviations variables.

2.  Their names has been submitted to a simplification to become more
    descriptive, and activity code has been substituted by its name.

3.  The data was grouped by subject and activity name (sorted in
    ascendant order) and the mean values of numeric variables were saved in tidy dataset.

4.  Output file in csv format.

## Additional features (for learning purpose):

1.This program automatically installs needed packages and load them.

2.Files are read without pathname “hardcoded”.

3.Columns header and class from train and test are checked if are the
same, once it is horizontally bind, and should match each other.




