##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
rm(list = ls())

## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 load the file #########################
load("data/RData/freq.RData")

##############################################
## 1. Ngram table ############################
##############################################

tbBigram <- matrix(nrow = length(freqUni), ncol = length(freqUni))
i <- 1
j <- 1
for (i in 1:length(freqUni)) {
    for (j in 1:length(freqUni)) {
        gram <- paste(names(freqUni[i]), names(freqUni[j]))
        
        freqUp <- freqBi[gram]
        freqDown <- freqUp[j]
        
        if (is.null(freqUp)) {
            freqUp <- 0
        }
        tbBigram[i, j] <-  freqUp / freqDown
    }
}