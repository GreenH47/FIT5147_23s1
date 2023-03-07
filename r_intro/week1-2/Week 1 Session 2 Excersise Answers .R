Title: "Module 1  Introduction to R -  Week 1."
Author: "Doogan,C & Gao,C.(2017)."
Date: "June 2017."


### Introduction to Rstudio - Week 1 Session 2 Answers.

# Here we will continue to learn data structures.
# The materials used are developed based on the Software Carpentry workshop "R for Reproducible Scientific Analysis",
# idre UCLA R learning modules and other online resources. 

### Data Types and data structures (continued from session 1)

### Factors

# Another important data structure is called a factor
# Factors usually look like character data, but are typically used to represent categorical information.
# For example, let's create a factor variable ses:

# create ses variable
ses <- c("low", "middle", "low", "high", "low", "low", "low", "middle", "low", "middle", "middle", "middle", "middle", "middle")
ses.f<-factor(ses)

# Check levels
levels(ses.f) # "high"   "low"    "middle"

# The problem is that the levels are ordered according to the alphabetical order
# of the categories of ses. Thus, "high" is the lowest level of ses.f, "low" is the middle level and 
# "middle" is the highest level. To fix the ordering we need to use the levels argument 
# to indicate the correct ordering of the categories. Let's create ses.f with the correct order of categories.

ses.f <- factor(ses, levels = c("low", "middle", "high")) # "high"   "low"    "middle"

# We can also generate factor variable from numeric data by specifying labels using the labels argument. 

# Challenge 1: Create a factor variable for type as type.f and label 0 as "private" and one as "public".

# from a numaric vector
type<-c(1,0,0,0,1,1,0,1)

type.f<-factor(type, levels = c ("1","0"), labels = c("private", "public"))
type.f 

# [1] private public  public  public  private private public  private
# Levels: private public

# However, you have to be careful with converting numeric variables to factor variables.
# For example: 

type.f<-factor(type, levels=c("1","0"), labels=c("private", "public"))
type.f

# [1] private public  public  public  private private public  private
# Levels: private public

# The levels argument determines the categories of the factor variable,
# and the default is the sorted list of all the distinct values of the data vector.
# This is particularly useful as the order of levels is quite important in many analyses such 
# as linear regression and generalised linear models (which you will use in FIT5157).
# The lowest level will be automatically set as the reference category.
# The labels argument states a vector of values that will be the labels of the
# categories in the levels argument.
# You have to remember that the levels argument and labels argument should be matching.

# **Ordered** factor variables can be created by using the function 'ordered'.
# This function has the same arguments as the factor function.
# To create an ordered factor variable called ses.order based on the variable ses.

ses.order <- ordered(ses, levels = c("low", "middle", "high"))

# Discussion: What is the difference between ordered factor variables and factor variables?

# Ordered factor variables are just that, ordered in the indicated way by the ordered() function. 

### Adding and dropping levels 

# Below we will add an element from a new level ("very.high") to ses.f our existing factor variable, ses.f.
# The number in the square brackets ( [21] ) indicates the number of the element whose label we wish to change.

ses.f[15] <- "very.high"

# The problem is that instead of changing from "high" to "very.high", the label was changed from "high" to <NA>. 

# Challenge 2: Complete this task correctly.
# *Hint* you need to first add the new level, "very.high", to the factor variable ses.f)

ses.f <- factor(ses.f, levels = c(levels(ses.f), "very.high"))
ses.f[15] <- "very.high"
ses.f
#  [1] low    middle low    high   low    low    low    middle low    middle middle middle middle middle <NA>  
# Levels: high low middle


# Dropping a level of a factor variable is a little easier.
# The simplest way is to first remove all the elements within the level 
# to be removed and then to re-declare the variable to be a factor variable.
# This might be a bit tricky.  Let's illustrate this by removing the level of "very.high" from the ses.f variable.

ses.f.new <- ses.f[ses.f != "very.high"]
ses.f.new
# [1] low    middle low    high   low    low    low    middle low    middle middle middle middle middle <NA>  
# Levels: high low middle
ses.f.new <- factor(ses.f.new)
ses.f.new
# [1] low    middle low    high   low    low    low    middle low    middle middle middle middle middle <NA>  
# Levels: high low middle

### Matrix

# In R matrices are an extension of the numeric or character vectors.
# They are not a separate type of object but merely an atomic vector with dimensions;
# the number of rows and columns.

m <- matrix(1:6, nrow = 2, ncol = 2)
m
# [,1] [,2]
# [1,]    1    3
# [2,]    2    4
dim(m) # 22
typeof(m) # integer
class(m) # matrix


# Matrices in R are filled column-wise.You can also fill data by row with argument byrow.
# Another way is to bind vectors using cbind() and rbind(). 

# Discussion: What do you think will be the result of length(matrix_example)? 
# Try it. Were you right? Why / why not?

matrix_example <- matrix(0, ncol=6, nrow=3)
length(matrix_example) # 18

# Challenge 4: Consider the R output of the matrix below:

# [,1] [,2]
# [1,]    4    1
# [2,]    9    5
# [3,]   10    7

# What was the correct command used to write this matrix? 
# Examine each command and try to figure out the correct one before typing them.
# Think about what matrices the other commands will produce.

# 1. matrix(c(4, 1, 9, 5, 10, 7), nrow = 3)
# 2. matrix(c(4, 9, 10, 1, 5, 7), ncol = 2, byrow = TRUE)
# 3. matrix(c(4, 9, 10, 1, 5, 7), nrow = 3)
# 4. matrix(c(4, 1, 9, 5, 10, 7), ncol = 2, byrow = TRUE)
matrix(c(4, 1, 9, 5, 10, 7), nrow = 3)
matrix(c(4, 9, 10, 1, 5, 7), ncol = 2, byrow = TRUE)
matrix(c(4, 9, 10, 1, 5, 7), nrow = 3)
matrix(c(4, 1, 9, 5, 10, 7), ncol = 2, byrow = TRUE)

matrix(c(4, 1, 9, 5, 10, 7), ncol = 2, byrow = TRUE)
# [,1] [,2]
# [1,]    4    1
# [2,]    9    5
# [3,]   10    7


# Discussion: What is the difference between cbind() and rbind().

x <- 1:3
y <- 10:12

cbind(x,y)
#   x  y
# [1,] 1 10
# [2,] 2 11
# [3,] 3 12
# Binds by column
rbind(x,y)
# [,1] [,2] [,3]
# x    1    2    3
# y   10   11   12
# Binds by row

### List

# In R lists act as containers. Unlike atomic vectors, the contents of a list are not restricted to a single mode
# and can encompass any mixture of data types. Lists are sometimes called generic vectors,
# because the elements of a list can by of any R object, even lists containing further lists.
# This property makes them fundamentally different from atomic vectors.

# A list is a special type of vector. Each element can be a different type.

# Create lists using list() or coerce other objects using as.list(). 

x <- list(1, "a", TRUE, 1+4i)
x
# [[1]]
# [1] 1

# [[2]]
# [1] "a"

# [[3]]
# [1] TRUE

# [[4]]
# [1] 1+4i

x <- 1:10
x <- as.list(x)
x
# [[1]]
# [1] 1

# [[2]]
# [1] 2

# [[3]]
# [1] 3

# [[4]]
# [1] 4

# [[5]]
# [1] 5

# [[6]]
# [1] 6

# [[7]]
# [1] 7

# [[8]]
# [1] 8

# [[9]]
# [1] 9

# [[10]]
# [1] 10

# Elements of lists can have names. 

xlist <- list(a = "Karthik Ram", b = 1:10, data = head(iris))
xlist
# $a
# [1] "Karthik Ram"

# $b
# [1]  1  2  3  4  5  6  7  8  9 10

# $data
# Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa

# Discussion:  What is the length of this object? What about its structure?

length(xlist) # 3
str(xlist)
# List of 3
# $ a   : chr "Karthik Ram"
# $ b   : int [1:10] 1 2 3 4 5 6 7 8 9 10
# $ data:'data.frame':    6 obs. of  5 variables:
#   ..$ Sepal.Length: num [1:6] 5.1 4.9 4.7 4.6 5 5.4
# ..$ Sepal.Width : num [1:6] 3.5 3 3.2 3.1 3.6 3.9
# ..$ Petal.Length: num [1:6] 1.4 1.4 1.3 1.5 1.4 1.7
# ..$ Petal.Width : num [1:6] 0.2 0.2 0.2 0.2 0.2 0.4
# ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1

# You can extract an element of a list using $ operator with the element's name.

xlist$b #  [1]  1  2  3  4  5  6  7  8  9 10


# Challenge 5: What is the class of xlist[2]? What about xlist[[2]] and xlist$b ?

class(xlist[2])# list
class(xlist[[2]]) # integer
class(xlist$b) # integer

# The [ operator always returns an object of the same class as the original. It can be used to
# select multiple elements of an object
# The [[ operator is used to extract elements of a list or a data frame. It can only be used to
# extract a single element, and the class of the returned object will not necessarily be a list or data frame.
# The $ operator is used to extract elements of a list or data frame by literal name. It's semantics
# are similar to that of [[.


### Data Frame
# A data frame is a very important data type in R. It'’'s pretty much the de facto data structure for
# most tabular data and what we use for statistics.
# Data frames can have additional attributes such as rownames(), 
# which can be useful for annotating data, like subject_id or sample_id. 
# But most of the time they are not used.
# Some additional information on data frames:
# * Can convert to a matrix with data.matrix() (preferred) or as.matrix()
# * Coercion will be forced and not always what you expect.
# * Can also create with data.frame() function.
# * Find the number of rows and columns with nrow(dat) and ncol(dat), respectively.
# * Rownames are usually 1, 2,...

# To create data frames by hand (Important for FIT5197 & FIT49):
dat <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
dat
# id  x  y
# 1   a  1 11
# 2   b  2 12
# 3   c  3 13
# 4   d  4 14
# 5   e  5 15
# 6   f  6 16
# 7   g  7 17
# 8   h  8 18
# 9   i  9 19
# 10  j 10 20

# Useful Data Frame Functions
# * head() - shown first 6 rows
# * tail() - show last 6 rows
# * dim() - returns the dimensions
# * nrow() - number of rows
# * ncol() - number of columns
# * str() - structure of each column
# * names() - shows the names attribute for a data frame, which gives the column names.

# Challenge 6: What is the class and type of iris data?


class(iris) # data frame
typeof(iris) # list


### Data frame index
# A data frame, much like a matrix, has two dimensions, rows and columns.
# To index a data frame (or a matrix),
# we use brackets in R next to the object,like so, iris[i, j], where i denotes the rows that you want,
# and j is the columns. 

# Challenge 7: Extract the first ten rows of the iris dataset. 

iris[1:10,]
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1           5.1         3.5          1.4         0.2  setosa
## 2           4.9         3.0          1.4         0.2  setosa
## 3           4.7         3.2          1.3         0.2  setosa
## 4           4.6         3.1          1.5         0.2  setosa
## 5           5.0         3.6          1.4         0.2  setosa
## 6           5.4         3.9          1.7         0.4  setosa
## 7           4.6         3.4          1.4         0.3  setosa
## 8           5.0         3.4          1.5         0.2  setosa
## 9           4.4         2.9          1.4         0.2  setosa
## 10          4.9         3.1          1.5         0.1  setosa

# Discussion** Is iris[1:10] going to work? If it works, is it because it is a list?

iris[1:10] # Error in `[.data.frame`(iris, 1:10) : undefined columns selected

# We can also extract individual columns of a data frame with the $ operator using column name. 

iris$Species

# Challenge 8: Find out how many rows of data in iris dataset where Species is setosa.


nrow(iris[iris$Species=="setosa",]) # 50


###Adding columns and rows in data frame

# We learned that the columns in a data frame were vectors, 
# so that our data are consistent in type throughout the column. 
# As such, if we want to add a new column, we need to start by making a new vector:

new1<-c(1:3)
new2<-1 
cars[1:2]
cars<-rbind(cars,new1)
cars<-rbind(cars,new2)

# Challenge 9: Why did this code work? Will similar condition work for cbind?

color<-c(1,1,1)
cars<-cbind(cars,color)


## Optional practice 
# You can continue to practice R by complete the following sections on swirl()
# Missing Values
# Subsetting Vectors
# Matrices and Data Frames 


