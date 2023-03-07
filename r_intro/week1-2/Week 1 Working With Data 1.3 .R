Title: "Module 1  Introduction to R -  Week 1 Working with Data 1.3."
Author: "Doogan, C.(2017)."
Date: "June 2017."

# We have dealt with the cabin data. Now we need to continue cleaning.We are going to use a new package, 'dplyr'.

### Install package
install.packages("dplyr")
library(dplyr)

# In this code we are only working on the training data. It will be your take home task to follow the code and clean
# the test data.

### Read data
ti_train<- read.csv("titanic_train_week1.csv", header = TRUE, sep = ",", na.strings=c("NA","NaN", ""))

### Addressing the 'Cabin' variable
# Last time we made new data frames which did not have the 'Cabin' variable in them using the following code:
#train_sml<-data.frame(ti_train$PassengerId, ti_train$Survived, ti_train$Pclass, ti_train$Name, ti_train$Sex, ti_train$Age, ti_train$SibSp, ti_train$Ticket, ti_train$Fare, ti_train$Embarked)
#test_sml<-data.frame(ti_test$PassengerId, ti_test$Pclass, ti_test$Name, ti_test$Sex, ti_test$Age, ti_test$SibSp, ti_test$SibSp, ti_test$Parch, ti_test$Ticket, ti_test$Fare, ti_test$Embarked)

# There are much quicker methods to tell R to take 'cabin' out and leave the rest. 

# Option 1: Use the subset() function to tell R to drop the variable named 'Cabin'. 
# You do not need to specify the variable name in quotes
# or list it as part of the ti_train dataset by typing 'ti_train$Cabin'. 
train_sml = subset(ti_train, select = -c(Cabin) )
head(train_sml)
# Before trying more options. Clear your list of variable names to save you having
# to think of more names which are appropriate(eventually you will run out or lose track of them all).
rm(train_sml)

# Option 2: Create a vector (the drop vector) which contains the 'Cabin' variable data. Then tell R to create a new data frame
# and put all the variables in ti_train into it but not the variables that are also in our new drop vector.
# The names() function will return all the column names (without having to state 'ti_train$Cabin', 'ti_train_Age', etc).
# Use the '!' sign to indicate 'NOT'.
drop_cab <- c("Cabin")
train_sml = ti_train[,!(names(ti_train) %in% drop_cab)]
head(train_sml)
rm(train_sml)

#Option 3: using 'dplyr'. This is the prefered option and will be used from now on.
ti_train<- select(ti_train, -Cabin)
head(ti_train)
# This was easier, AND it saves you having to think of new temporary file names. 

### Addressing the rest of the missing data

# We now need to see how many other NA's we have to fix up. 
ti_train[!complete.cases(ti_train),]
# We need to deal with the 'Age' and 'Embark' data. 

### Addressing the 'Age' variable missing data

# We are going to use the 'dyplr 'dplyr' filter() function instead of complete cases.
# Here we are asking R to show us all of the data which has a missing 'Age' variable. 
dplyr::filter(ti_train, is.na(Age))
# There are 87 rows that have a missing Age variable. 

# We do not want to get rid of these rows as discussed. 
# So the best way is to impute values. 
# A good method is to take the mean of all the 'Age' data, and replace the missing NA's with this value.
mean_age <- mean(ti_train$Age, na.rm = TRUE) 

# Then we replace the missing values with mean_age.
ti_train$Age <- replace(ti_train$Age, which(is.na(ti_train$Age)), mean_age)
# We can check how many NA's are in the 'Age' variable column using sum() instead of filter() or complete.cases()
sum(is.na(ti_train$Age))

### Compact code

# Neatness and efficiency of code are often marking criteria. Once you get comfortable with R, you can start
# compacting your code. For now, it is ok to have longer scripts while you are learning and these examples have 
# purposely been written to be longer for you. For example, the previous code could have been written as:
ti_train$Age[is.na(ti_train$Age)] <- mean(ti_train$Age, na.rm = TRUE)
# We can check using filter() as well. 
dplyr::filter(ti_train, is.na(Age))

### Addressing the 'Embarked' variable missing data

# We need to fix the embarked NA's.
# Using filter() to inspect these.
dplyr::filter(ti_train, is.na(Embarked))
# the codes for the 'Embarked' variable are: C = Cherbourg, Q = Queenstown, S = Southampton.

# Get an idea of the proportions that came from each city. 
#We can use prop.table() function to make a table of these proprtions.
prop.table(table(ti_train$Embarked))
# ~19% from Cherbourg, ~0.9% from Queenstown and ~72% from Southampton.
# We will replace the NA's with 'S' then. Why would we do this? 

# Code can be written so many different ways. To illustrate, we can replace with S with:

# Option 1: 
ti_train$Embarked[is.na(ti_train$Embarked)] <- 'S'
dplyr::filter(ti_train, is.na(Embarked))

# Option 2: 
ti_train$Embarked <- replace(ti_train$Embarked, which(is.na(ti_train$Embarked)), 'S')
sum(is.na(ti_train$Embarked))

# The data in ti_train is now fairly clean for our purposes.

### Your task is to clean up the 'ti_test' data
# *Hint* There will be a third variable that we did not cover in the training data set. 
# We have covered how to resolve this issue.