## Owner: Antoine Rougier, 5 Dec. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Solar+Flare
## Docs: http://www.statmethods.net/stats/regression.html
##       http://www.montefiore.ulg.ac.be/~kvansteen/GBIO0009-1/ac20092010/Class8/Using%20R%20for%20linear%20regression.pdf

library(ggplot2)
library(DAAG)

flares.set <- read.csv('./flares.csv', header = TRUE, sep = ' ')

# Fit linear regression, let's take the full model
flares.lm <- lm(c.class ~ ., data = flares.set)

# sum up
summary(flares.lm)
confint(flares.lm, level=0.95) # Confidence interval

# diagnostic plots
layout(matrix(c(1,2,3,4),2,2))
plot(flares.lm)

# K fold cross-validation (k >1)
cv.lm(df = flares.set, flares.lm, m = 3) 


# Prediction
# Shortcoming because of sigularities, coefficients are not set
p <- predict(flares.lm, flares[-(1:100),]) 
1 - sum(p^2) / sum((flares.set$c.class - mean(flares.set$c.class))^2)
