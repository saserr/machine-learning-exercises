## Owner: Antoine Rougier, 4 Dec. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime

library(DAAG)

cc.set <- read.csv("communities.data", na.strings = "?", header = FALSE)

cc.lm <- lm(V128 ~ ., data = cc.set)
