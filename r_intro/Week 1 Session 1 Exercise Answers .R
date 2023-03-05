Title: "Module 1  Introduction to R -  Week 1."
Author: "Doogan,C & Gao,C.(2017)."
Date: "June 2017."


### Introduction to Rstudio - Week 1 Session 1 

#   RStudio is a free, open source R integrated development environment.
#   It provides a built-in editor, works on all platforms (including on servers) 
#   and provides many advantages such as integration with version control and project management.

### Basic layout

# RStudio include four panels:
# 1. The interactive R console in the lower left (entire left when you first opened it)
# 2. Editor panel in the upper left
# 3. Environment/History tabbed in upper right
# 4. Files/Plots/Packages/Help/Viewer tabbed in lower right


###  Work flow 

# There are many ways one can work within RStudio. The easy way would
# be to start writing in a .R file and use  RStudio's command/shortcut to push the
# current line or selected lines to the interactive R console.
# This is an excellent way to start as all your code is saved for later.

# To run the **current line** code from the editor window you can:
# 1. click on the Run button above the editor panel, or 
# 2. select 'Run Lines' from the 'Code' menu, or 
# 3. hit Ctrl-Enter in Windows or Linux or Command-Enter on OS X. 

# To run a block of code, select it and then Run. 


### Working directory

# Unlike Jupyter notebook, R/RStudio does not set the working directory to the folder
# where your script locates. The default working directory is normally the user's home directory.
# There are a few ways to setup current working directories: 

# Use the setwd() R function
# Use the Tools | Change Working Dir... menu (Session | Set Working Directory on a Mac).
# This will also change directory location of the Files pane.
# From within the Files pane, use the More | Set as Working Directory menu.
# (Navigation within the Files pane alone will not change the working directory.)

# To check your current working directory you can use the getwd() function.

getwd()


### Project 

# A better way for managing your data and script files is to create a project.
# You should create a new project now for these peer-based sessions.

# Challenge 1: Practice making a project directory. 
# Give the project file an appropriate name such as 'R_pbl_Winter2017'.


# (type your code here)


# If you haven't already installed R and RStudio, please follow the instructions
# under Unit Information -> Resources:

# 1.  Click the 'File' menu button, then 'New Project'.
# 2.  Click 'New Directory'.
# 3.  Click 'Empty Project'.
# 4.  Type in the name of the directory to store your project
# 5.  Click the 'Create Project' button.


### Basic arithmetics and operators

# R arithmetic

# From highest to lowest precedence:
# Parentheses: (, )
# Exponents: ^ or **
# Divide: /
# Multiply: *
# Add: +
# Subtract: -

# Also 

# Remainder: %%    
# Integer Division: %/%    


### Mathematical functions

# R has many built-in mathematical functions.
# To call a function, we simply type its name, followed by open and closing parentheses.
# Anything we type inside the parentheses is called the function's arguments:

log(1) # 0
exp(1) # 2.718282


### Comparing things

# We can also do comparison in R:
# Equality: ==
# Inequality: !=
# Greater than: >
# Greater than or equal to: >=
# Smaller than: <
# Smaller than or equal to: <=

# ** Note** Don't use == to compare two numbers unless they are integers
# (a data type which can specifically represent only whole numbers). 


### Variables and Assignments

# Variables are stored using the assignment operator <-, :

a<- 1
b<- 2
c<- a+b
c # 3

# Please do no use the '=' sign to assign values to variables.
# It is considered bad practice by the R community. 

# Assignment values can contain the variable being assigned to:

a<-1
b<-a+1
b # 2


# Challenge 2: What will be the value of age after you run the following program?

mass <- 40
age <- mass + 10
mass <- mass * 2

age # 50


### Working with R 

# Adding comments

# You can start a 'comment' after the hash symbol #.
# Everything after # is ignored by R when it executes code.


### Managing your environment

# There are a few useful commands you can use to interact with the R session.
# You can use rm to delete objects you no longer need:

rm(x)

# If you have lots of things in your environment and want to delete all of them,
# you can pass the results of ls to the rm function:

rm(list = ls())

# Delete things as you go, or you may end up with an error denoted by '+',
# a memory error, in your console when you try to execute your code.

# Challenge 3: Clean up your working environment by deleting the mass and age variables.


rm(age,mass)


### R Packages

# It is possible to add functions to R by writing a package,
# or by obtaining a package written by someone else. 
# There are over 7,000 packages available on CRAN (the comprehensive R archive network).
# R and RStudio have functionality for managing packages:

# You can see what packages are installed by typing installed.packages()
# You can install packages by typing install.packages("packagename")
# You can update installed packages by typing update.packages()
# You can remove a package with remove.packages("packagename")
# You can make a package available for use with library(packagename)

# Challenge 4:  Install packages: ggplot2, plyr

install.packages("ggplot2")
install.packages("dplyr")

### How to Get help 

# R and every package, provide help files for functions.
# To search for help on a function from a specific function that is in a package 
# loaded into your namespace (your interactive R session):

?vector()
help(vector)

# Challenge 5: What should you do when you do not remember the function name exactly?


??log


### Data Types and data structures 

# To make the best of the R language, you'll need a strong understanding of the basic data types
# and data structures and how to operate on those.

# Everything in R is an object.

# R has six atomic (data of a single type) vector types.

# character: "a", "swc"
# numeric: 2, 15.5
# integer: 2
# logical: TRUE, FALSE
# complex: 1+4i (complex numbers with real and imaginary parts)

# *Note* For most MDS subjects you will only use character, numeric and logical types*

# R has many data structures. These include:
# atomic vector
# list
# matrix
# data frame
# factors

# R has some built in functions, for example: 
# class() - what kind of object is it (high-level)?
# typeof() - what is the object's data type (low-level)?
# length() - how long is it? What about two dimensional objects?
# attributes() - does it have any metadata?

# Example
x <- "dataset"
y <- 555.55
z <- as.integer(y)

# Challenge 6: For objects x, y, z find out the type of objects,
# data type of objects and whether they have any attributes.


typeof(x) # character
typeof(y) # double
typeof(z) # integer

attributes(x) # NULL
attributes(y) # NULL
attributes(z) # NULL

### Vectors

# A vector is a collection of elements that are most commonly of mode character,
# logical, integer or numeric.


### Creating vectors

# You can create an empty vector with vector().
# By default the mode is logical. You can be more explicit as shown in the examples below.
# It is more common to use direct constructors such as character(), numeric(), etc.

vector() # an empty 'logical' (the default) vector
vector("character", length = 5) # a vector of mode 'character' with 5 elements

# Using TRUE and FALSE will create a vector of mode logical 
# and using quoted text will create a vector of mode character.

poke <- c("Squirtle", "Charmander", "Bulbasaur") 


### Examining Vectors

# The functions typeof(), length(), class() and str() 
# provide useful information about your vectors and R objects in general.

typeof(poke) # character
length(poke) # 3
class(poke)  # character


### Adding Elements

# The function c() (for combine) can also be used to add elements to a vector. 

# Challenge 7: Add name "Pikachu" to vector z. Print the vector.


poke<-c(poke, "Pikachu")
poke # "Squirtle"   "Charmander" "Bulbasaur"  "Pikachu" 


### Vectors from a sequence of numbers

# You can create vectors as a series of numbers.

series <- 1:10
series #  1  2  3  4  5  6  7  8  9 10
seq(10) # 1  2  3  4  5  6  7  8  9 10
seq(from = 1, to = 10, by = 0.1)
#  [1]  1.0  1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9  2.0  2.1  2.2  2.3  2.4  2.5  2.6  2.7  2.8
# [20]  2.9  3.0  3.1  3.2  3.3  3.4  3.5  3.6  3.7  3.8  3.9  4.0  4.1  4.2  4.3  4.4  4.5  4.6  4.7
# [39]  4.8  4.9  5.0  5.1  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9  6.0  6.1  6.2  6.3  6.4  6.5  6.6
# [58]  6.7  6.8  6.9  7.0  7.1  7.2  7.3  7.4  7.5  7.6  7.7  7.8  7.9  8.0  8.1  8.2  8.3  8.4  8.5
# [77]  8.6  8.7  8.8  8.9  9.0  9.1  9.2  9.3  9.4  9.5  9.6  9.7  9.8  9.9 10.0


### Naming a vector 

# The elements of a vector can be given names using, names()

temperature <- c(30, 29, 20, 15, 40)
names(temperature) <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")


### Vector index 

# The values in a vector can be extracted via declaring
# an index inside a single square bracket "[]" operator.
# For example: 

temperature[1] # The first value in the temperature vector.
# Monday
# 30

# ** Note ** Unlike Python, R index starts from 1 rather than 0.
# Also the square bracket operator returns another vector rather than just
# individual members. temperature[1] returned a vector slice containing a single member.

# Challenge: Retrieve first three values in vector "temperature".
# Extract values for Wednesday using vector name.


temperature[1:3] #  Monday   Tuesday Wednesday 
# 30        29        20 

temperature["Wednesday"] # Wednesday 20 


# Discussion: What would you do if you are interested
# in extracting two values using vector names?

temperature[c("Wednesday","Friday")] # Wednesday 20 Friday 40


# Challenge 8: Find out what would happen if an index is out-of-range.


temperature[11] # <NA> NA


# Challenge 9: Create a vector for average temperature in Melbourne for each month.
# Jan    Feb    Mar    Apr    May    Jun    Jul    Aug    Sep    Oct    Nov    Dec
# °C    21    21    19    17    14    11    10    11    13    15    17    19


temp_month<-c(21, 21, 19, 17, 14, 11, 10, 11, 13, 15, 17, 19)
names(temp_month)<-month.abb
temp_month


# Challenge 10: Find out which month has the maximum temperature.


temp_month[which.max(temp_month)] # Jan 21



#Challenge 11: Find out the temperature difference between the month with maximum 
# temperature and the month with minimum temperature.



temp_month[[which.max(temp_month)]]- temp_month[[which.min(temp_month)]] # 11


# End session.



