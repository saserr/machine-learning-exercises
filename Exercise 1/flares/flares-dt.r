require('rpart')

# read csv file
flares <- read.csv('flares/flares.csv', header = TRUE, sep = ' ')

# cleanup data

# grow and prune the tree
fit <- rpart(c.class ~ code.class + code.largest.spot.size + code.spot.distribution + activity + evolution + code.24h.activity + historically.complex + bacame.historically.complex.now + area + largest.spot.area,
             data = flares,
             method = 'anova',
             control = rpart.control(xval = 5, cp = 0.03))
flares_dt_c_1 <- prune(fit, cp = fit$cptable[which.min(fit$cptable[,'xerror']), 'CP'])

# print information about the tree
printcp(flares_dt_c_1)
summary(fit, c = 0.01)
plotcp(fit)
rsq.rpart(fit)

# plot the  tree
plot(fit, uniform = TRUE, main = 'Classification Tree for Sun Flares')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'flares-tree.ps', title = 'Classification Tree for Sun Flares')

# prediction
p <- predict(fit, newdata = flares[-(1:100),])

# R2
1 - sum(p^2) / sum((flares$c.class - mean(flares$c.class))^2)

# resubstitution error
p <- table(p, flares$c.class)
1 - (sum(diag(p)) / sum(p))
