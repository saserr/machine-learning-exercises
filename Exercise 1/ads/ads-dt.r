require('rpart')

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

# grow and prune the tree
fit <- rpart(V1559 ~ .,
             data = ads_miss_as_mean,
             method = 'class',
             control = rpart.control(xval = 5, cp = 0))
ads_dt_mean_5 <- prune(fit, cp = fit$cptable[which.min(fit$cptable[,'xerror']), 'CP'])

# print information about the tree
printcp(ads_dt_mean_5)
summary(fit, c = 0.01)
plotcp(fit)

# plot the tree
plot(fit, uniform = TRUE, main = 'Classification Tree for Ads')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'ads-tree.ps', title = 'Classification Tree for Ads')
