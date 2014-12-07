install.packages("RWeka", dependencies = TRUE)
library(RWeka)

# read csv file
ads <- read.csv('ads/ad.data', header = TRUE, sep = ',', na.strings = '?')

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

# k-nearest neighbour cross-validatory classification

fit <- IBk(V1559 ~ .,
           data = ads_miss_as_mean,
           control = Weka_control(K = 9, X = TRUE))
ads_knn_mean_9 <- evaluate_Weka_classifier(fit, numFolds = 5, seed = 5)
