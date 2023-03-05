Title: "Module 1  Introduction to R -  Week 1 Working with Data 1.1."
Author: "Doogan, C.(2017)."
Date: "June 2017."

# Now we are going to be doing some cleaning. Cleaning is one of the most essential elements of data exploration.

### We need to see how much data is missing. There are so many ways to do this and to deal with missing data.
# For now, we will do some basic methods to deal with this, then learn how to use dplyr for this later. 

### Read data
# na.strings converts all missing data to na. 
ti_train<- read.csv("titanic_train_week1.csv",na.strings=c("NA","NaN", ""), header = TRUE, sep=",")
ti_test<- read.csv("titanic_test_week1.csv",na.strings=c("NA","NaN", ""), header = TRUE, sep = ",")

### How much missing data are we dealing with?
# Using the column sums and the is.na() function, we get the amount of NAs we have in for each variable. 

colSums(is.na(ti_train))
# There are 177 missing 'Age' observations, 687 missing 'Cabin' observations and 2 missing 'Embarked' observations. 
colSums(is.na(ti_test))
# There is 1 missing 'Fair' observation, 327 missing 'Cabin' observations.

### NA or NAN?
# Knowing what you are dealing with is important. NA means 'not available' and NAN means 'not a number'.
# When we imported the data, we made all of this uniform. 

# Now we need to decide what to do about these na's. They cannot stay there. 
# Discussion: What would happen if the na's were still there when we start building models?

# It would prevent us from conducting any statistics.For example:
mean(ti_train$Age) # NA 

### Option 1 : Remove all the rows with missing data 
# We can use the complete.cases function. This will return a vector that has no missing values
ti_train[!complete.cases(ti_train),]
# To create a new data set with no missing data we use na.omit()
ti_train_full<-na.omit(ti_train)
# Have a look to see if there are an na's
ti_train_full[!complete.cases(ti_train_full),] # there are no rows with na's.

# Do the same with the test data.
ti_test[!complete.cases(ti_test),]
ti_test_full<-na.omit(ti_test)
ti_test_full[!complete.cases(ti_test_full),] # there are no rows with na's.

# However, there is a big problem with using this method. By omitting all na's we drastically reduced the amount 
# of data we can work with.
dim(ti_train) #891 observations
dim(ti_train_full) # 183 observations
dim(ti_test) # 418 observations
dim(ti_test_full) # 87 observations

# This is very likely due to the cabin data which is largly missing. 
ti_train[!complete.cases(ti_train$Cabin),]# 604 missing out of 891; and the Age data;
ti_train[!complete.cases(ti_train$Age),] # 94 rows out of 891.
# the ti_test is not much better. 237 rows omitted out of 418. 
ti_test[!complete.cases(ti_test$Cabin),] 

### Option 2: Remove the variables with missing data.
# We could choose to explude the variables with the most amount of missing data. Then we would move forward
# more sophisticated methods. Since ~68% of the Cabin data is missing. It is a good idea at this level to exclude it.
# We simple make a new dataframe excluding the cabin data.
train_sml<-data.frame(ti_train$PassengerId, ti_train$Survived, ti_train$Pclass, ti_train$Name, ti_train$Sex, ti_train$Age, ti_train$SibSp, ti_train$Ticket, ti_train$Fare, ti_train$Embarked)
test_sml<-data.frame(ti_test$PassengerId, ti_test$Pclass, ti_test$Name, ti_test$Sex, ti_test$Age, ti_test$SibSp, ti_test$SibSp, ti_test$Parch, ti_test$Ticket, ti_test$Fare, ti_test$Embarked)
