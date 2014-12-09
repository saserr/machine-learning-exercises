## Owner: Antoine Rougier, 5 Dec. 2014
## Dataset: http://archive.ics.uci.edu/ml/datasets/Solar+Flare
## Docs: http://www.statmethods.net/stats/regression.html
##       http://www.montefiore.ulg.ac.be/~kvansteen/GBIO0009-1/ac20092010/Class8/Using%20R%20for%20linear%20regression.pdf

library(ggplot2)
library(DAAG)

flares <- read.csv('flares/flares.csv', header = TRUE, sep = ' ')

# fit linear regression
fit <- lm(x.class ~ code.class + code.largest.spot.size + code.spot.distribution + activity + evolution + code.24h.activity + historically.complex + bacame.historically.complex.now + area + largest.spot.area,
          data = flares)
flares_lr_x <- cv.lm(fit,
                     df = flares,
                     m = 5,
                     seed = 5)