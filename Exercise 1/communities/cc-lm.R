## Owner: Antoine Rougier, 4 Dec. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime

library(DAAG)

# read csv file
communities <- read.csv('communities/communities.csv', header = FALSE, sep = ',', na.strings = '?')

# cleanup data
communities <- communities[-c(1:5)]

communities_nomiss <- na.omit(communities)

communities_miss_as_zero <- communities
communities_miss_as_zero[is.na(communities_miss_as_zero)] <- 0

communities_miss_as_mean <- communities
communities_miss_as_mean$V100[is.na(communities_miss_as_mean$V100)] <- as.integer(mean(x = communities$V100, na.rm = TRUE))
communities_miss_as_mean$V101[is.na(communities_miss_as_mean$V101)] <- as.integer(mean(x = communities$V101, na.rm = TRUE))
communities_miss_as_mean$V102[is.na(communities_miss_as_mean$V102)] <- as.integer(mean(x = communities$V102, na.rm = TRUE))
communities_miss_as_mean$V103[is.na(communities_miss_as_mean$V103)] <- as.integer(mean(x = communities$V103, na.rm = TRUE))
communities_miss_as_mean$V104[is.na(communities_miss_as_mean$V104)] <- as.integer(mean(x = communities$V104, na.rm = TRUE))
communities_miss_as_mean$V105[is.na(communities_miss_as_mean$V105)] <- as.integer(mean(x = communities$V105, na.rm = TRUE))
communities_miss_as_mean$V106[is.na(communities_miss_as_mean$V106)] <- as.integer(mean(x = communities$V106, na.rm = TRUE))
communities_miss_as_mean$V107[is.na(communities_miss_as_mean$V107)] <- as.integer(mean(x = communities$V107, na.rm = TRUE))
communities_miss_as_mean$V108[is.na(communities_miss_as_mean$V108)] <- as.integer(mean(x = communities$V108, na.rm = TRUE))
communities_miss_as_mean$V109[is.na(communities_miss_as_mean$V109)] <- as.integer(mean(x = communities$V109, na.rm = TRUE))
communities_miss_as_mean$V110[is.na(communities_miss_as_mean$V110)] <- as.integer(mean(x = communities$V110, na.rm = TRUE))
communities_miss_as_mean$V111[is.na(communities_miss_as_mean$V111)] <- as.integer(mean(x = communities$V111, na.rm = TRUE))
communities_miss_as_mean$V112[is.na(communities_miss_as_mean$V112)] <- as.integer(mean(x = communities$V112, na.rm = TRUE))
communities_miss_as_mean$V113[is.na(communities_miss_as_mean$V113)] <- as.integer(mean(x = communities$V113, na.rm = TRUE))
communities_miss_as_mean$V114[is.na(communities_miss_as_mean$V114)] <- as.integer(mean(x = communities$V114, na.rm = TRUE))
communities_miss_as_mean$V115[is.na(communities_miss_as_mean$V115)] <- as.integer(mean(x = communities$V115, na.rm = TRUE))
communities_miss_as_mean$V116[is.na(communities_miss_as_mean$V116)] <- as.integer(mean(x = communities$V116, na.rm = TRUE))
communities_miss_as_mean$V117[is.na(communities_miss_as_mean$V117)] <- as.integer(mean(x = communities$V117, na.rm = TRUE))
communities_miss_as_mean$V118[is.na(communities_miss_as_mean$V118)] <- as.integer(mean(x = communities$V118, na.rm = TRUE))
communities_miss_as_mean$V119[is.na(communities_miss_as_mean$V119)] <- as.integer(mean(x = communities$V119, na.rm = TRUE))
communities_miss_as_mean$V120[is.na(communities_miss_as_mean$V120)] <- as.integer(mean(x = communities$V120, na.rm = TRUE))
communities_miss_as_mean$V121[is.na(communities_miss_as_mean$V121)] <- as.integer(mean(x = communities$V121, na.rm = TRUE))
communities_miss_as_mean$V122[is.na(communities_miss_as_mean$V122)] <- as.integer(mean(x = communities$V122, na.rm = TRUE))
communities_miss_as_mean$V123[is.na(communities_miss_as_mean$V123)] <- as.integer(mean(x = communities$V123, na.rm = TRUE))
communities_miss_as_mean$V124[is.na(communities_miss_as_mean$V124)] <- as.integer(mean(x = communities$V124, na.rm = TRUE))
communities_miss_as_mean$V125[is.na(communities_miss_as_mean$V125)] <- as.integer(mean(x = communities$V125, na.rm = TRUE))
communities_miss_as_mean$V127[is.na(communities_miss_as_mean$V127)] <- as.integer(mean(x = communities$V127, na.rm = TRUE))
communities_miss_as_mean <- na.omit(communities_miss_as_mean)

# fit linear regression
fit <- lm(V128 ~ .,
          data = communities_miss_as_mean)
communities_lr_mean <- cv.lm(fit,
                             df = communities_miss_as_mean,
                             m = 5,
                             seed = 5)
