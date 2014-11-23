#R script called run_analysis.R does the following. 
#
#    1.Merges the training and the test sets to create one data set.
#    2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#    3.Uses descriptive activity names to name the activities in the data set
#    4.Appropriately labels the data set with descriptive variable names. 
#    5.From the data set in step 4, creates a second, independent tidy data set with the 
#      average of each variable for each activity and each subject.

  activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep=" ",header=F,colClasses="character")
  features <- read.csv("UCI HAR Dataset/features.txt",sep=" ",header=F,colClasses="character")
  cc <- grep("mean",features$V2)
  cc <- append(cc,grep("std",features$V2))
 
  X_test <- readLines("UCI HAR Dataset/test/X_test.txt")
  tb <- NULL
  start <- seq(1,560*16+1,16)
  stop <- seq(16,561*16,16)
  for (k in 1:length(X_test)) tb <- rbind(tb,as.numeric(substring(X_test[k],start,stop))[cc])

  X_test <- readLines("UCI HAR Dataset/train/X_train.txt")
  for (k in 1:length(X_test)) tb <- rbind(tb,as.numeric(substring(X_test[k],start,stop))[cc])

  tb <- as.data.frame(tb)
  colnames(tb) <- features$V2[cc]

  action1 <- read.csv("UCI HAR Dataset/test/y_test.txt",header=F,colClasses="character")
  action2 <- read.csv("UCI HAR Dataset/train/y_train.txt",header=F,colClasses="character")
  action1 <- action1$V1; action2 <- action2$V1;
  actions <- c(action1,action2)
  actions <- as.numeric(actions)
  actions <- as.factor(actions)
  activities <- factor(actions,labels=activity_labels$V2)
  tb <- cbind(tb,activities)

  subject1 <- read.csv("UCI HAR Dataset/test/subject_test.txt",header=F,colClasses="character")
  subject2 <- read.csv("UCI HAR Dataset/train/subject_train.txt",header=F,colClasses="character")
  subject1 <- subject1$V1; subject2 <- subject2$V1;
  subjects <- c(subject1,subject2)
  subjects <- as.numeric(subjects)
  tb <- cbind(tb,subjects)
  
  ##acc <- readLines("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt",n=2)
  tBodyAcc_mean_X <- tapply(tb[,1],list(tb$subjects,tb$activities),mean)
  tBodyAcc_mean_X <- as.table(tBodyAcc_mean_X)
  xx <- format(tBodyAcc_mean_X,digits=5)
  write.table(xx, file="tBodyAcc_mean_X.txt",row.name=F)