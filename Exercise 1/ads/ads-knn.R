## Owner: Antoine Rougier, 23 Nov. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Internet+Advertisements

# Run in a shell before to remove the spaces: 
#     * sed s/\ //g < ad.data > ad.data.new
#     * mv ad.data.new ad.data

library(class)
library(ggplot2)

## Reading data
# The na.strings replace the non available symbol of the dataset by the R one (NA)
iads.set <- read.csv("./ad.data", na.strings = "?", header = FALSE)
# Get the number of ad. and nonad.
iads.sum <- summary(iads.set[,1559])
iads.n_inst <- length(iads.set$V1)

#########################################################################################
# TODO Training set preparation: 
#	* ~10% of the total data
#	* Take instance without missing value
#     - Learn without missing values
#     - learn with 0 instead of missing values
#     - learn with the mean instead of missing values 

### Learning without missing values in the set
## Prepare a set without missing data
# Remove line(s) with non available data 
iads_nomiss.set <- na.omit(iads.set)

## Build the training set
if (file.exists("./ad.train.data")) {
  # if the training set is already there, load it
  iads_nomiss.train <- read.csv("./ad.train.data")
}
if (!file.exists("./ad.train.data")) {
  # else create it by taking randomly 10% of the dataset and store it in a file
  iads_nomiss.train <- data.frame()
  kk <- 1
  while(kk < (iads_nomiss.n_inst * 20 / 100)) {
    iads_nomiss.train <- rbind(iads_nomiss.train, iads_nomiss.set[as.integer(runif(n = 1, min = 1, max = iads_nomiss.n_inst)),])
    kk <- kk + 1
  }
  write.csv(x = iads_nomiss.train, file = "ad.train.data", row.names = FALSE)
}

# Scaling the training set
#iads_nomiss.train$V1 <- ((iads_nomiss.train$V1 - min(iads_nomiss.train$V1)) / (max(iads_nomiss.train$V1) + min(iads_nomiss.train$V1)))
#iads_nomiss.train$V2 <- ((iads_nomiss.train$V2 - min(iads_nomiss.train$V2)) / (max(iads_nomiss.train$V2) + min(iads_nomiss.train$V2)))
#iads_nomiss.train$V3 <- ((iads_nomiss.train$V3 - min(iads_nomiss.train$V3)) / (max(iads_nomiss.train$V3) + min(iads_nomiss.train$V3)))

## Here we run the k-NN with different values of k, then we store the error results to check out what is 
## the best k to choose in our case
# Here we use the knn with implicit cross validation
# iads_nomiss.knn <- knn.cv(train = iads_nomiss.set[1:1558], cl = iads_nomiss.set$V1559, k = 13, prob = TRUE)

#iads_nomiss.set <- iads_nomiss.set[as.integer(row.names(iads_nomiss.train))*-1,] # Used to eliminate training data

# Scaling
#iads_nomiss.set$V1 <- ((iads_nomiss.set$V1 - min(iads_nomiss.set$V1)) / (max(iads_nomiss.set$V1) + min(iads_nomiss.set$V1)))
#iads_nomiss.set$V2 <- ((iads_nomiss.set$V2 - min(iads_nomiss.set$V2)) / (max(iads_nomiss.set$V2) + min(iads_nomiss.set$V2)))
#iads_nomiss.set$V3 <- ((iads_nomiss.set$V3 - min(iads_nomiss.set$V3)) / (max(iads_nomiss.set$V3) + min(iads_nomiss.set$V3)))

iads_nomiss.sum <- summary(iads_nomiss.set[,1559])
iads_nomiss.n_inst <- length(iads_nomiss.set$V1)

kk <- 1
iads_nomiss.err <- data.frame()
while(kk < 100){
  # iads_nomiss.knn <- knn.cv(train = iads_nomiss.set[1:1558], cl = iads_nomiss.set$V1559, k = kk, prob = TRUE)
  iads_nomiss.knn <- knn(train = iads_nomiss.train[1:1558], test = iads_nomiss.set[1:1558], 
                         cl = iads_nomiss.train$V1559, k = kk, prob = TRUE)
  
  err <- abs(summary(iads_nomiss.knn)[1] - iads_nomiss.sum[1])
  iads_nomiss.err <- rbind(iads_nomiss.err, c(kk, err, (((iads_nomiss.sum[1]-err)+(iads_nomiss.sum[2]-err))/iads_nomiss.n_inst)))
  
  #kk <- kk * 2 + 1
  kk <- kk + 4
}
colnames(iads_nomiss.err) <- c("k", "err", "accuracy")

# To plot the distribution
# Try to plot a distribution curve
# Plot it with the best model found
#b<-cbind(as.character(iads_nomiss.knn), attr(iads_nomiss.knn,"prob"))
#par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
#plot(c(b[b[,1]=="ad.",2],b[b[,1]=="nonad.",2]), col = c("red", "blue"), ylab = "Probability to be")
#legend("topright", inset=c(-0.2,0),c("ad.","nonad."), col = c("red", "blue"), pch = c(1,1))


### Learn with 0 instead of missing values

iads_zero.set <- iads.set
#iads_zero.set <- iads.set[as.integer(row.names(iads_nomiss.train))*-1,] # Used to eliminate training data
iads_zero.n_inst <- length(iads_zero.set$V1)

# Replace all NA by 0
iads_zero.set[is.na(iads_zero.set)] <- 0

# Scaling
#iads_zero.set$V1 <- ((iads_zero.set$V1 - min(iads_zero.set$V1)) / (max(iads_zero.set$V1) + min(iads_zero.set$V1)))
#iads_zero.set$V2 <- ((iads_zero.set$V2 - min(iads_zero.set$V2)) / (max(iads_zero.set$V2) + min(iads_zero.set$V2)))
#iads_zero.set$V3 <- ((iads_zero.set$V3 - min(iads_zero.set$V3)) / (max(iads_zero.set$V3) + min(iads_zero.set$V3)))

# Learn ...
kk <- 1
iads_zero.err <- data.frame()
while(kk < 100){
  iads_zero.knn <- knn(train = iads_nomiss.train[1:1558], test = iads_zero.set[1:1558], 
                         cl = iads_nomiss.train$V1559, k = kk, prob = TRUE)
  
  #iads_zero.err <- rbind(iads_zero.err, c(kk, abs(summary(iads_zero.knn)[1] - iads.sum[1])))
  err <- abs(summary(iads_zero.knn)[1] - iads.sum[1])
  iads_zero.err <- rbind(iads_zero.err, c(kk, err, (((iads.sum[1]-err)+(iads.sum[2]-err))/iads_zero.n_inst)))
  
  kk <- kk + 4
}
colnames(iads_zero.err) <- c("k", "err", "accuracy")


### Learn with the mean (or the dominant feature for the boolean) instead of missing values 
# Thanks to is.na(colSums(iads.set[1:1558]))[is.na(colSums(iads.set[1:1558]))==TRUE],
# we know that only the 4 first columns contain missing values, they will be replaced as follow: 
#   - $V1, $V2: integer part of the mean of each column
#   - $V3: the mean
#   - $V4: 1 because the dominant value is 1 as we can see using: 
#           tmp <- colSums(iads_nomiss.set[4:1558])
#           subset(x = tmp, subset = tmp >= iads_nomiss.n_inst/2)

iads_filled.set <- iads.set
#iads_filled.set <- iads.set[as.integer(row.names(iads_nomiss.train))*-1,] # Used to eliminate training data
iads_filled.n_inst <- length(iads_filled.set$V1)

tmp <- colMeans(x = iads.set[1:2], na.rm = TRUE)
iads_filled.set$V1[is.na(iads_filled.set$V1)] <- as.integer(tmp[1])
iads_filled.set$V2[is.na(iads_filled.set$V2)] <- as.integer(tmp[2])
rm(tmp)
iads_filled.set$V3[is.na(iads_filled.set$V3)] <- mean(x = iads.set$V3, na.rm = TRUE)
iads_filled.set$V4[is.na(iads_filled.set$V4)] <- 1

# Scaling the training set
#iads_filled.set$V1 <- ((iads_filled.set$V1 - min(iads_filled.set$V1)) / (max(iads_filled.set$V1) + min(iads_filled.set$V1)))
#iads_filled.set$V2 <- ((iads_filled.set$V2 - min(iads_filled.set$V2)) / (max(iads_filled.set$V2) + min(iads_filled.set$V2)))
#iads_filled.set$V3 <- ((iads_filled.set$V3 - min(iads_filled.set$V3)) / (max(iads_filled.set$V3) + min(iads_filled.set$V3)))

# Learn ...
kk <- 1
iads_filled.err <- data.frame()
while(kk < 100){
  iads_filled.knn <- knn(train = iads_nomiss.train[1:1558], test = iads_filled.set[1:1558], 
                         cl = iads_nomiss.train$V1559, k = kk, prob = TRUE)
  
  #iads_filled.err <- rbind(iads_filled.err, c(kk, abs(summary(iads_filled.knn)[1] - iads.sum[1])))
  err <- abs(summary(iads_filled.knn)[1] - iads.sum[1])
  iads_filled.err <- rbind(iads_filled.err, c(kk, err, (((iads.sum[1]-err)+(iads.sum[2]-err))/iads_filled.n_inst)))  
  
  kk <- kk + 4
}
colnames(iads_filled.err) <- c("k", "err", "accuracy")


# Plot accuracy
iads.plot <- ggplot(cbind(iads_nomiss.err, iads_filled.err$accuracy, iads_zero.err$accuracy), 
                    aes(x = iads_nomiss.err$k)) +
  #iads.plot <- ggplot(cbind(iads_nomiss.err, iads_filled.err$accuracy, iads_zero.err$accuracy), 
  #                    aes(x = iads_nomiss.err$k)) +
  geom_line(aes(y=iads_nomiss.err$accuracy, color = "Without NA")) +
  geom_line(aes(y=iads_zero.err$accuracy, color = "0 instead of NA")) +
  geom_line(aes(y=iads_filled.err$accuracy, color = "Mean instead of NA")) +
  scale_colour_manual("", 
                      breaks = c("Without NA", "0 instead of NA", "Mean instead of NA"),
                      values = c("red", "green", "blue")) +
  ylab("Accuracy") +
  xlab("Distance k") +
  ggtitle("k-NN - first experiment") +
  #ggtitle("k-NN - second experiment") +
  #ggtitle("k-NN - third experiment") +
  theme_bw() +
  theme(
    plot.title = element_text(family="Times", size = 10),
    axis.text = element_text(size = 11),
    axis.title = element_text(family="Times", size = 11),
    legend.text = element_text(family="Times", size = 11),
    legend.title = element_text(family="Times", size = 12))
iads.plot    


