#R script called run_analysis.R does the following. 
#
#    1.Merges the training and the test sets to create one data set.
#    2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#    3.Uses descriptive activity names to name the activities in the data set
#    4.Appropriately labels the data set with descriptive variable names. 
#    5.From the data set in step 4, creates a second, independent tidy data set with the 
#      average of each variable for each activity and each subject.

  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
  features <- read.csv("UCI HAR Dataset/features.txt",header=F,sep=" ",colClasses="character")
  cc <- sort(c(grep("mean",features[,2]),grep("std",features[,2])))

 
  X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
  X_test <- X_test[,cc]	#only mean and std

  X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
  X_train <- X_train[,cc]

  X_data <- rbind(X_train,X_test)
  colnames(X_data) <- features[cc,2]


  y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
  y_test <- y_test$V1; y_train <- y_train$V1;
  actions <- c(y_test,y_train)
  actions <- as.numeric(actions)
  actions <- as.factor(actions)
  activities <- factor(actions,labels=activity_labels[,2])

  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
  subject_test <- subject_test$V1; subject_train <- subject_train$V1;
  subjects <- c(subject_test,subject_train)
  subjects <- as.numeric(subjects)
  tb <- cbind(subjects,activities,X_data)
  
  tidy <- split(tb[, -(1:2)], list(tb$subjects, tb$activities));
  tidy <- sapply(tidy, apply, 2, mean);
  tidy <- t(tidy);
  write.table(tidy, file="tidy_data.txt",row.name=F)