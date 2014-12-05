## Owner: Antoine Rougier, 4 Dec. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Communities+and+Crime


cc.set <- read.csv("communities.data", na.strings = "?", header = FALSE)

## Create a formula for a model with a large number of variables:
cc.vars<- names(cc.set[1:127])
cc.formula <- as.formula(paste("V128 ~ ", paste(cc.vars, collapse= "+")))

cc.lm <- lm(formula = cc.formula, data = cc.set)
