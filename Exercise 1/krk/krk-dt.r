require('rpart')

# read csv file
krk <- read.csv('krk.csv', header = TRUE, sep = ',')

# cleanup data
krk$moves.to.win <- as.numeric(ordered(krk$moves.to.win,
                                       levels = c('draw', 'zero', 'one', 'two',
                                                  'three', 'four', 'five',
                                                  'six', 'seven', 'eight',
                                                  'nine', 'ten', 'eleven',
                                                  'twelve', 'thirteen', 'fourteen',
                                                  'fifteen', 'sixteen'))) - 2

krk$wins <- factor(as.numeric(krk$moves.to.win >= 0), labels = c('no', 'yes'))
krk$differences.kings.file = abs(as.numeric(krk$white.king.file) - as.numeric(krk$black.king.file))
krk$differences.kings.rank = abs(krk$white.king.rank - krk$black.king.rank)
krk$differences.kings = krk$differences.kings.file + krk$differences.kings.rank
krk$differences.rook.file = abs(as.numeric(krk$white.rook.file) - as.numeric(krk$black.king.file))
krk$differences.rook.rank = abs(krk$white.rook.rank - krk$black.king.rank)
krk$differences.rook = krk$differences.rook.file + krk$differences.rook.rank

# grow a tree
fit <- rpart(moves.to.win ~ white.king.file + white.king.rank + white.rook.file + white.rook.rank + black.king.file + black.king.rank,
             data = krk,
             method = 'class',
             control = rpart.control(xval = 10, minsplit = 1, cp = 0.0001))

# print information about the tree
printcp(fit)
summary(fit, c = 0.01)
plotcp(fit)

# plot the tree
plot(fit, uniform = TRUE, main = 'Classification Tree for KRK Chess Endgame')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'krk-tree.ps', title = 'Classification Tree for KRK Chess Endgame')

# prune the tree
pfit<- prune(fit, cp = fit$cptable[which.min(fit$cptable[,'xerror']), 'CP'])

# print information about the pruned tree
printcp(pfit)
summary(pfit, c = 0.01)
plotcp(pfit)

# plot the pruned tree
plot(fit, uniform = TRUE, main = 'Classification Tree for KRK Chess Endgame')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'krk-pruned-tree.ps', title = 'Classification Tree for KRK Chess Endgame')
