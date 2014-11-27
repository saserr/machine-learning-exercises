# Owner: Antoine Rougier, 23 Nov. 2014
# Dataset: http://archive.ics.uci.edu/ml/datasets/Internet+Advertisements

library(class);

# Reading data
iads <- read.csv("./ad.data", header = FALSE)

# TODO Training set preparation: 
#	* ~10% of the total dataset
#	* Take instance without missing value
#     - Learn without missing values
#     - learn with 0 instead of missing values
#     - learn with the mean instead of missing values 

