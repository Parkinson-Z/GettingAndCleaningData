======================
run_analysis.R read the 16 bytes fixed length dataset from training/test sections, and
merge into a table called 'tb'. Using tapply to a list of activities and subjects to 
create a table of interested paramters to write to a file.
ie. to get average value of 'tBodyAcc-mean()-X' use column 1 of the table 'tb'
 tapply(tb[,1],list(tb$activities,tb$subjects),mean)
for other type of value please check the column name of interest and change '1' 
in the 'tb[,1]' command
