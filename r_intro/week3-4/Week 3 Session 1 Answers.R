Title: "Module 2 Introduction to R - Week 3 Session 1 Answers."
Author: "Doogan, C.(2017)."

Date: "June 2017."
library(ggplot2)
library(dplyr)
install.packages("scales")
install.packages("xlsx")
install.packages("reshape2")
install.packages("lubridate")
install.packages("ggthemes")
install.packages("gridExtra")

# We are using the diamonds data set that is inbuilt for R.h
head(diamonds)

# Challenge 1: How many observations are in the data set?
# Answer:
nrow(diamonds)
# [1] 53940

# Challenge 2: How many variables are in the data set?
# Answer:
ncol(diamonds)
[1] 10

# Challenge 3: How many ordered factors are in the set?
# Answer
str(diamonds)
# 3

# Challenge 4: What letter represents the best color for a diamonds?
levels(diamonds$color)
## [1] "D" "E" "F" "G" "H" "I" "J"
help(diamonds)
# D

# Challenge 5: Create a histogram of the price of all the diamonds in the diamond data set.
# Answer: 
ggplot(diamonds, aes(x = price)) + geom_histogram(color = "black", fill = "DarkOrange", binwidth = 500) + theme(axis.text.x = element_text(angle = 90)) + xlab("Price") + ylab("Count")

# challenge 6: Describe the shape and center of the price distribution. 
# Include summary statistics like the mean and median. 
# Answer:
summary(diamonds$price)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     326     950    2400    3930    5320   18800

# Challenge 7: Have a go at explaining the dirstibution and summary stats of the histogram.
# Answer:
# The distribution is right-skewed with small amounts of very large prices driving up the mean, 
# while the median remains a more robust measure of the center of the distribution.

# Challenge 8: How many diamonds cost less than $500?
# Answer:
# * Hint* Use dplyr functions
diamonds %>% filter(price < 500) %>% summarise(n = n())
##      n
## 1 1729

# Challenge 9:How many diamonds cost less than $250?
# Answer:
diamonds %>% filter(price < 250) %>% summarise(n = n())

# Challenge 10: How many diamonds cost more than $15,000?
diamonds %>% filter(price >= 15000) %>% summarise(n = n())
##   n
## 1 0

# Challenge 10:Explore the largest peak in the
# price histogram you created earlier.
# Try limiting the x-axis, altering the bin width,
# and setting different breaks on the x-axis.
# Answer:
ggplot(diamonds, aes(x = price)) +  geom_histogram(color = "black", fill = "DarkOrange", binwidth = 25) + theme(axis.text.x = element_text(angle = 90)) + coord_cartesian(c(0,2000)) +xlab("Price") + ylab("Count")

# Challenge 11:  Break out the histogram of diamond prices by cut.
# You should have five histograms in separate
# panels on your resulting plot.
# * Hint* Use the facet_grid to do this "facet_grid(cut~.)"
# Answer:
ggplot(diamonds, aes(x = price)) +  geom_histogram(color = "black", fill = "DarkOrange", binwidth = 25) + theme(axis.text.x = element_text(angle = 90)) + coord_cartesian(c(0,4000)) +facet_grid(cut~.) + xlab("Price") + ylab("Count")


# Challenge 12: Which cut has the highest priced diamond?
# Premium
# by(diamonds$price, diamonds$cut, max)
# by(diamonds$price, diamonds$cut, min)
# by(diamonds$price, diamonds$cut, median)
# Answer
diamonds %>%group_by(cut) %>% summarise(max_price = max(price),min_price = min(price),median_price = median(price))
## Source: local data frame [5 x 4]
## 
##         cut max_price min_price median_price
## 1      Fair     18574       337         3282
## 2      Good     18788       327         3050
## 3 Very Good     18818       336         2648
## 4   Premium     18823       326         3185
## 5     Ideal     18806       326         1810

# End Session
# Source http://fch808.github.io/Data-Analysis-with-R-Exercises.html