##############################################
## 0. Set up #################################
##############################################
require(stringi)
require(data.table)
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

## below is too slow
# tbBigram <- matrix(nrow = length(freqUni), ncol = length(freqUni))
# i <- 1
# j <- 1
# for (i in 1:length(freqUni)) {
#     for (j in 1:length(freqUni)) {
#         gram <- paste(names(freqUni[i]), names(freqUni[j]))
#         
#         freqUp <- freqBi[gram]
#         freqDown <- freqUp[j]
#         
#         if (is.null(freqUp)) {
#             freqUp <- 0
#         }
#         tbBigram[i, j] <-  freqUp / freqDown
#     }
# }

## 1.1 create a function to extract elements #
## in a gram #################################
NgramTb <- function (mxFreq) {
  ## Use: return a ngram probability table
  ## Args: mxFreq: a ngram frequency matrix
  ## Return: a ngram probability table
  
  ## determins the n of the ngram
  n <- length(unlist(gregexpr(" ", names(mxFreq)[1]))) + 1
  ## substring the grams into 2 parts, last word and the rest words
  listWords <- stri_split_fixed(names(mxFreq), " ")
  vecLastWord <- sapply(listWords, function (x) unlist(x)[n])
  vecRestWowrds <- sapply(listWords, function (x) paste(unlist(x)[-n], collapse = " "))
  ## build a data table
  tbGram <- data.table("ngram" = names(mxFreq)
                       , "freq" = mxFreq
                       , "x" = vecRestWowrds
                       , "y" = vecLastWord)
  
  return(tbGram)
}
tbUnigram <- NgramTb(freqUni)
tbBigram <- NgramTb(freqBi)
tbTrigram <- NgramTb(freqTri)
tbQuatrgram <- NgramTb(freqQuatr)



  
  
  
