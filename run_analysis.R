#1.Merge

trainset1<-read.table("./train//X_train.txt",header = FALSE)
trainset2<-read.table("./train//y_train.txt",header = FALSE)
trainset3<-read.table("./train//subject_train.txt",header = FALSE)


testset1<-read.table("./test//X_test.txt",header = FALSE)
testset2<-read.table("./test//y_test.txt",header = FALSE)
testset3<-read.table("./test//subject_test.txt",header = FALSE)

mergeset1<-rbind(trainset1,testset1) # contains features info
mergeset2<-rbind(trainset2,testset2) #contains activity info
mergeset3<-rbind(trainset3,testset3) #contains subject info

names(mergeset3)<-c("subject") #change the column name for mergeset 3 which contains subject info
names(mergeset2)<-c("activity") #change the column name for mergeset 2 which contains activity info


featureset<-read.table("./features.txt",header = FALSE)

name<-featureset$V2    #Get all the names of the columns from features.txt
names(mergeset1)<-name #Change all the names of the columns in mergeset1, which contains activity info

combinedset<-cbind(mergeset3,mergeset2)

finaldataset<-cbind(mergeset1,combinedset)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

meanstd <- featureset$V2[grep("(mean|std)\\(\\)",featureset$V2)]

selection<-c(as.character(meanstd), "subject", "activity" )

finaldataset<-subset(finaldataset,select=selection)


# 3. Uses descriptive activity names to name the activities in the data set
activityset<-read.table("./activity_labels.txt",header = FALSE)


#4. Appropriately labels the data set with descriptive variable names. 
names(finaldataset)<-gsub("^t", "time", names(finaldataset))
names(finaldataset)<-gsub("^f", "frequency", names(finaldataset))
names(finaldataset)<-gsub("Acc", "accelerometer", names(finaldataset))
names(finaldataset)<-gsub("Gyro", "gyroscope", names(finaldataset))
names(finaldataset)<-gsub("Mag", "magnitude", names(finaldataset))
names(finaldataset)<-gsub("BodyBody", "body", names(finaldataset))


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr);
tidydataset<-aggregate(finaldataset,by=list(finaldataset$subject,finaldataset$activity),FUN = mean)
tidydataset<-tidydataset[order(tidydataset$subject,tidydataset$activity),]
write.table(tidydataset, file = "tidydata.txt",row.name=FALSE)





