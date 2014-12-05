## Owner: Antoine Rougier, 3 Dec. 2014
library(class)
library(ggplot2)

krk.set <- read.csv('krk.csv', header = TRUE, sep = ',')


# Get the class distribtution
krk.sum <- summary(krk.set[,7])

# Clean up th data
krk.set$white.king.file <- as.numeric(krk.set$white.king.file)
krk.set$white.rook.file <- as.numeric(krk.set$white.rook.file)
krk.set$black.king.file <- as.numeric(krk.set$black.king.file)

# get the number of intances (number of rows)
krk.n_inst <- length(krk.set$white.king.file)

## Here we run the k-NN with different values of k, then we store the error results to check out what is 
## the best k to choose in our case
## We use cross validation version of knn function
kk <- 1
krk.err <- data.frame()

while(kk < 100){
  krk.knn <- knn.cv(train = krk.set[1:6], cl = krk.set$moves.to.win, k = kk, prob = TRUE)
  
  errs <- abs(summary(krk.knn) - krk.sum)
  # This compute the accuracy for each k
  krk.err <- rbind(krk.err, c(kk, (((krk.sum[1]-errs[1])+(krk.sum[2]-errs[2])+
                                            (krk.sum[3]-errs[3])+(krk.sum[4]-errs[4])+
                                            (krk.sum[5]-errs[5])+(krk.sum[6]-errs[6])+
                                            (krk.sum[7]-errs[7])+(krk.sum[8]-errs[8])+
                                            (krk.sum[9]-errs[9])+(krk.sum[10]-errs[10])+
                                            (krk.sum[11]-errs[11])+(krk.sum[12]-errs[12])+
                                            (krk.sum[13]-errs[13])+(krk.sum[14]-errs[14])+
                                            (krk.sum[15]-errs[15])+(krk.sum[16]-errs[16])+
                                            (krk.sum[17]-errs[17])+(krk.sum[18]-errs[18]))/krk.n_inst)))
  #kk <- kk * 2 + 1
  kk <- kk + 4
}
colnames(krk.err) <- c("k", "accuracy")


## Now we build manually a training set
if (file.exists("./krk.train.data")) {
  # if the training set is already there, load it
  krk.train <- read.csv("./krk.train.data")
}
if (!file.exists("./krk.train.data")) {
  # else create it by taking randomly 30% of the dataset and store it in a file
  krk.train <- data.frame()
  kk <- 1
  while(kk < (krk.n_inst * 30 / 100)) {
    krk.train <- rbind(krk.train, krk.set[as.integer(runif(n = 1, min = 1, max = krk.n_inst)) ,])
    kk <- kk + 1
  }
  write.csv(x = krk.train, file = "krk.train.data", row.names = FALSE)
}

## … And we learn
kk <- 1
krk.man.err <- data.frame()

while(kk < 100){
  krk.man.knn <- knn(train = krk.train[1:6], test = krk.set[1:6], cl = krk.train$moves.to.win, k = kk, prob = TRUE)
  
  errs <- abs(summary(krk.man.knn) - krk.sum)
  # This compute the accuracy for each k
  krk.man.err <- rbind(krk.man.err, c(kk, (((krk.sum[1]-errs[1])+(krk.sum[2]-errs[2])+
                                            (krk.sum[3]-errs[3])+(krk.sum[4]-errs[4])+
                                            (krk.sum[5]-errs[5])+(krk.sum[6]-errs[6])+
                                            (krk.sum[7]-errs[7])+(krk.sum[8]-errs[8])+
                                            (krk.sum[9]-errs[9])+(krk.sum[10]-errs[10])+
                                            (krk.sum[11]-errs[11])+(krk.sum[12]-errs[12])+
                                            (krk.sum[13]-errs[13])+(krk.sum[14]-errs[14])+
                                            (krk.sum[15]-errs[15])+(krk.sum[16]-errs[16])+
                                            (krk.sum[17]-errs[17])+(krk.sum[18]-errs[18]))/krk.n_inst)))
  #kk <- kk * 2 + 1
  kk <- kk + 4
}
colnames(krk.man.err) <- c("k", "accuracy")




# maybe use this one: eliminates most of the rows used for training
tmp<-krk.set[as.integer(row.names(krk.train))*-1,]
kk <- 1
tmp.err <- data.frame()
tmp.sum = summary(tmp$moves.to.win)
while(kk < 100){
  tmp.knn <- knn(train = krk.train[1:6], test = tmp[1:6], cl = krk.train$moves.to.win, k = kk, prob = TRUE)
  
  errs <- abs(summary(tmp.knn) - tmp.sum)
  # This compute the accuracy for each k
  tmp.err <- rbind(tmp.err, c(kk, (((tmp.sum[1]-errs[1])+(tmp.sum[2]-errs[2])+
                                            (tmp.sum[3]-errs[3])+(tmp.sum[4]-errs[4])+
                                            (tmp.sum[5]-errs[5])+(tmp.sum[6]-errs[6])+
                                            (tmp.sum[7]-errs[7])+(tmp.sum[8]-errs[8])+
                                            (tmp.sum[9]-errs[9])+(tmp.sum[10]-errs[10])+
                                            (tmp.sum[11]-errs[11])+(tmp.sum[12]-errs[12])+
                                            (tmp.sum[13]-errs[13])+(tmp.sum[14]-errs[14])+
                                            (tmp.sum[15]-errs[15])+(tmp.sum[16]-errs[16])+
                                            (tmp.sum[17]-errs[17])+(tmp.sum[18]-errs[18]))/krk.n_inst)))
  #kk <- kk * 2 + 1
  kk <- kk + 4
}
colnames(tmp.err) <- c("k", "accuracy")

# Plot accuracy
krk.plot <- ggplot(cbind(tmp.err, krk.man.err$accuracy, krk.err$accuracy), aes(x = tmp.err$k)) +
  geom_line(aes(y=tmp.err$accuracy, color = "Test set without training values")) +
  geom_line(aes(y=krk.man.err$accuracy, color = "Test set with training values")) +
  geom_line(aes(y=krk.err$accuracy, color = "knn + cross-validation")) +
  scale_colour_manual("", 
                      breaks = c("Test set without training values", "Test set with training values",
                                 "knn + cross-validation"),
                      values = c("red", "green", "blue")) +
  ylab("Accuracy") +
  xlab("Distance k")+
  ggtitle("k-NN - King-Rook vs. King") +
  theme_bw() +
  theme(
    plot.title = element_text(family="Times", size = 10),
    axis.text = element_text(size = 11),
    axis.title = element_text(family="Times", size = 11),
    legend.text = element_text(family="Times", size = 11),
    legend.title = element_text(family="Times", size = 12))
krk.plot    

