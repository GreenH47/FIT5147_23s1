Title: "Module 4  Introduction to R - Week 4 Session 1 Answers."
Author: "Doogan, C.(2017)."
Date: "June 2017."

# Today we will be going over clustering. We will only be looking at one type of clustering, K-means clustering. 
# We will use the Pokemon dataset.

# Install or open the packages needed.
install.packages("tidyverse") # data manipulation
install.packages("cluster") # clustering algorithms
install.packages("factoextra") # clustering algoirthms and visulaisations
install.packages("clusterCrit")
library(clusterCrit)
library(devtools)
install_github("kassambara/factoextra")
library(factoextra)
library(ggplot2)    # visualisation
library(tidyverse) 
library(cluster)
# Like most things in the R-universe, there are many packages to do the same job. 
# The above are just some of the clustering packages.
# We have chosen these as they are simple to learn and produce great visualisations. 

### Data Preperation
# Import data
poke<-read.csv("Pokemon.csv", header = T,stringsAsFactors = TRUE)
summary(poke)

# Resolving mismatched variable length.
# Challenge 1: Check the data frame for missmatched column lengths
# Answer:
colnames_check <- colnames(poke) %in% colnames(poke) 
colnames(poke[colnames_check==FALSE])
# There should be no missmatched column lengths.

# Checking for NA's
# Challenge 2: Check that there are no NA's
# Answer:
# training data
poke[!complete.cases(poke),]
# There should be no NA's.

# Reformating the data frame
head(poke)
# There is both numerical and string data in this data frame. This will cause problems in k-means clustering. 
# We need to remove the string data.
poke_df<-poke %>% select( HP, Attack, Defense, Sp..Atk, Sp..Def, Speed)
pok_df<-na.omit(poke_df)
head(poke_df)

# Let's double check the data types
class(poke_df$HP)
class(poke_df$Attack)
class(poke_df$Defense)
class(poke_df$Sp..Atk)
class(poke_df$Sp..Def)
class(poke_df$Speed)
# These are all interger. Later when we need to evaluate out aklgorithsm
# we need to use fucntions that require numeric data so we need to change it to matrix format with numerical data. 
mat_poke<- as.data.frame.matrix(poke_df)
head(mat_poke)

### k means clustering
# First we need to select the initial number of centres. In this example try k= 2.
poke_k1 <- kmeans(mat_poke, centers = 2, nstart = 25)
str(poke_k1)
# centers are the number of nominated centroids you choose, and nstart is the number
# of times the algorithm will iterate before it stops. 
# Don't worry about the read out yet. We will cover this. 

# To get a visiualisation we use the fviz_cluster() function. 
fviz_cluster(poke_k1, data = mat_poke)
# That looks messy. To reduce the text we use geom=c() and specifiy "point"
fviz_cluster(poke_k1, geom = c("point"), data = mat_poke)
# We could have just "text" 
fviz_cluster(poke_k1, geom = c("text"), data = mat_poke)
# But it looks messy. The points can be smothed to ellipses
# using ellipse.type()
fviz_cluster(poke_k1,geom = c("point") ,data = mat_poke, ellipse.type = "norm")
# The transparancy of the ellipse can be changed using ellipse.alpha
fviz_cluster(poke_k1,geom = c("point") ,data = mat_poke, ellipse.type = "norm", ellipse.alpha = 0.60)
# If we did want to show both the point and text and we felt it was too messy, we could use the repel function
fviz_cluster(poke_k1,geom = c("point","text"),data = mat_poke, repel =TRUE, ellipse.type = "norm")
# That still looks messy.
# We should also lable our plot
fviz_cluster(poke_k1,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 2)" )

# Challenge 3: Plot k-means clusters for k = 3 to 8. What do you notice. 
# Answer:
# k = 3
poke_k2 <- kmeans(mat_poke, centers = 3, nstart = 25)
str(poke_k2)
fviz_cluster(poke_k2,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 3)" )
# k = 4
poke_k3 <- kmeans(mat_poke, centers = 4, nstart = 25)
str(poke_k3)
fviz_cluster(poke_k3,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 4)" )
# k = 5
poke_k4 <- kmeans(mat_poke, centers = 5, nstart = 25)
str(poke_k4)
fviz_cluster(poke_k4,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 5)" )
# k = 6
poke_k5 <- kmeans(mat_poke, centers = 6, nstart = 25)
str(poke_k5)
fviz_cluster(poke_k5,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 6)" )
# k = 7
poke_k6 <- kmeans(mat_poke, centers = 7, nstart = 25)
str(poke_k6)
fviz_cluster(poke_k6,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 7)" )
# k = 8
poke_k7 <- kmeans(mat_poke, centers = 8, nstart = 25)
str(poke_k7)
fviz_cluster(poke_k7,geom = c("point") ,data = mat_poke, ellipse.type = "norm",main= "Pokemon K-means plot (k = 8)" )


### Cluster evaluation
# The clusters look as if they are getting messier. If we look at the printout, we can start to determine how they are performing.
# cluster: A vector of integers (from 1:k) indicating the cluster to which each point is allocated.
# centres: A matrix of cluster centres.
# totss: The total sum of squares.
# withinss: Vector of within-cluster sum of squares, one component per cluster.
# tot.withinss: The total within-cluster sum of squares, i.e. sum(withinss).
# betweenss: The between-cluster sum of squares, i.e. $totss-tot.withinss$.
# size: The number of points in each cluster.

## Intrinsic Evaluation Methods
# Total Within Cluster Sum of Squares
# We want the tot.withinss to be as low as possible.
# to.withinss represents the measure of compactness (e.g. goodness) of the cluster,

# Challenge 4: Which k has the smallest tot.withinss?
# Answer: k = 8

# Between cluster sum of squares
# Now we should look at the betweenss (between sum of squares). This should be as large as possible.

# Challenge 5: Which k has the largest betweenss?
# Answer: k = 8

# This problem with this though is that the  tot.withinss and betweeenss will be optimal when k = n.
# This means that the evaluation would report that the k-means algorithm is more accurate when k = the number of data points and this isn't helpful.

# We can look at the Davies-Bouldin index. The smaller the index the better the clusters.
mat_poke[] <- lapply(mat_poke, as.numeric) # We need to reframe the matrix (you won't usually need to do this so ignore this)

# Let's see how k = 8 and K = 7 perfrom using the DB index
# K = 8
intEvaluations.poke_k7= intCriteria(as.matrix(mat_poke), poke_k7$cluster, "all")
intEvaluations.poke_k7$davies_bouldin
# [1] 1.438246

# k = 7
intEvaluations.poke_k6= intCriteria(as.matrix(mat_poke), poke_k6$cluster, "all")
intEvaluations.poke_k6$davies_bouldin
# [1] 1.008183


# challenge 6: Which k returns the lowest DB index?
# Answer:
# K = 2
intEvaluations.poke_k1= intCriteria(as.matrix(mat_poke), poke_k1$cluster, "all")
intEvaluations.poke_k1$davies_bouldin
# [1] 1.304356
# k = 3
intEvaluations.poke_k2= intCriteria(as.matrix(mat_poke), poke_k2$cluster, "all")
intEvaluations.poke_k2$davies_bouldin
# [1] 1.661221
# k = 4
intEvaluations.poke_k3= intCriteria(as.matrix(mat_poke), poke_k3$cluster, "all")
intEvaluations.poke_k3$davies_bouldin
# [1] 1.680767
# k = 5
intEvaluations.poke_k4= intCriteria(as.matrix(mat_poke), poke_k4$cluster, "all")
intEvaluations.poke_k4$davies_bouldin
# [1] 1.237335
# k = 6
intEvaluations.poke_k5= intCriteria(as.matrix(mat_poke), poke_k5$cluster, "all")
intEvaluations.poke_k5$davies_bouldin
# [1] 1.67411
# K = 6 has the lowest DB index


### Determining the optimal number of clusters
# Elbow Method
set.seed(123) 

# function to compute total within-cluster sum of square 
wss <- function(k) {kmeans(mat_poke, k, nstart = 10 )$tot.withinss}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

# An easier way
set.seed(123)

fviz_nbclust(mat_poke, kmeans, method = "wss")

# Challenge 7: WHich of these two codes is best? WHY?
# Answer:
# The second as it indicates the spike in total with sum of squares and has a more definitive 'bend'.

## Silhouette Method
fviz_nbclust(mat_poke, kmeans, method = "silhouette")

# This indicates that the optimal number of clusters in 2 followed by 7. 

## Gap statistic
# compute gap statistic
set.seed(123)
gap_stat <- clusGap(mat_poke, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
# Print the result
print(gap_stat, method = "firstmax")

fviz_gap_stat(gap_stat)
# The gap statistic indicates that the best k = 2


### Final evaluation
# Compute k-means clustering with k = 2
set.seed(123)
final <- kmeans(mat_poke, 2, nstart = 25)
print(final)

# Now we can get some idea about each of the clusters to create two types of Pokemon.
mat_poke %>%
  mutate(Cluster = final$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

# Challenge 8: The is not only two types of Pokemon. Go back and reassess the stats to determine what the best number of clusters is.
# What is the best number of clusters?
# Answer: 7

# Other ways to summarise your clusters are to provide tables of the center means, number of clusters and other aspects of the printout. 


# References: UC Berkley Programming guide, CRAN clustercrit guide