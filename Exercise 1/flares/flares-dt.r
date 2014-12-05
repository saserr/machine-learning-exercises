require('rpart')

# read csv file
flares <- read.csv('flares/flares.csv', header = TRUE, sep = ' ')

# cleanup data

# grow a tree
fit <- rpart(c.class ~ .,
             data = flares,
             method = 'anova',
             control = rpart.control(xval = 10, minsplit = 100, cp = 0.0001))

# prediction
p <- predict(fit, newdata = flares[-(1:100),])

# R2
1 - sum(p^2) / sum((flares$c.class - mean(flares$c.class))^2)

# resubstitution error
p <- table(p, flares$c.class)
1 - (sum(diag(p)) / sum(p))

# print information about the tree
printcp(fit)
summary(fit, c = 0.01)
plotcp(fit)
rsq.rpart(fit)

# plot the tree
plot(fit, uniform = TRUE, main = 'Classification Tree for Sun Flares')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'flares-tree.ps', title = 'Classification Tree for Sun Flares')

# prune the tree
pfit<- prune(fit, cp = fit$cptable[which.min(fit$cptable[,'xerror']), 'CP'])

# print information about the pruned tree
printcp(pfit)
summary(pfit, c = 0.01)
plotcp(pfit)
rsq.rpart(pfit)

# plot the pruned tree
plot(pfit, uniform = TRUE, main = 'Classification Tree for Sun Flares')
text(pfit, use.n = FALSE, all = TRUE, cex = .8)
post(pfit, use.n = FALSE, file = 'flares-pruned-tree.ps', title = 'Classification Tree for Sun Flares')
