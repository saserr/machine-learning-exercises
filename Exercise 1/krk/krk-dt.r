require('rpart')

# read csv file
krk <- read.csv('krk/krk.csv', header = TRUE, sep = ',')

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

# grow and prune the tree
fit <- rpart(moves.to.win ~ .,
             data = krk,
             method = 'class',
             control = rpart.control(xval = 5, cp = 0))
krk_dt_move_5 <- prune(fit, cp = fit$cptable[which.min(fit$cptable[,'xerror']), 'CP'])

# print information about the tree
printcp(krk_dt_move_5)
summary(fit, c = 0.01)
plotcp(fit)

# plot the tree
plot(fit, uniform = TRUE, main = 'Classification Tree for KRK Chess Endgame')
text(fit, use.n = FALSE, all = TRUE, cex = .8)
post(fit, use.n = FALSE, file = 'krk-tree.ps', title = 'Classification Tree for KRK Chess Endgame')
