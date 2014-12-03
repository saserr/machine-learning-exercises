install.packages('randomForest')
library('randomForest')

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

# grow a random forest
fit <- randomForest(x = krk[1:6],
                    y = krk$moves.to.win,
                    sampsize = ceiling(.632*nrow(krk)),
                    oob.prox = TRUE,
                    ntree = 10)

# print information about the tree
print(fit)
importance(fit)
