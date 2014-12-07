install.packages('randomForest')
library('randomForest')

# read csv file
ads <- read.csv('ads/ad.data', header = TRUE, sep = ',')

# cleanup data
ads$V1559 <- factor(as.numeric(ads$V1559 == 'ad.'), labels = c('no', 'yes'))

ads_nomiss <- na.omit(ads)

ads_miss_as_zero <- ads
ads_miss_as_zero[is.na(ads_miss_as_zero)] <- 0

ads_miss_as_mean <- ads
ads_miss_as_mean$V1[is.na(ads_miss_as_mean$V1)] <- as.integer(mean(x = ads$V1, na.rm = TRUE))
ads_miss_as_mean$V2[is.na(ads_miss_as_mean$V2)] <- as.integer(mean(x = ads$V2, na.rm = TRUE))
ads_miss_as_mean$V3[is.na(ads_miss_as_mean$V3)] <- mean(x = ads$V3, na.rm = TRUE)
ads_miss_as_mean$V4[is.na(ads_miss_as_mean$V4)] <- 1

# grow a random forest
ads_rf_mean_10 <- rfcv(trainx = ads_miss_as_mean[1:1558],
                       trainy = ads_miss_as_mean$V1559,
                       cv.fold = 5,
                       oob.prox = TRUE,
                       ntree = 10)

# print information about the tree
ads_rf_mean_10$error.cv
