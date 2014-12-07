install.packages("RWeka", dependencies = TRUE)
library(RWeka)

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

# k-nearest neighbour cross-validatory classification

fit <- IBk(moves.to.win ~ .,
           data = krk,
           control = Weka_control(K = 9, X = TRUE))
krk_knn_move_9 <- evaluate_Weka_classifier(fit, numFolds = 5, seed = 5)
