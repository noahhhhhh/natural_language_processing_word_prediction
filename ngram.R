##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(stringi)
require(data.table)
rm(list = ls())

## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 load the file #########################
load("data/RData/freq.RData")

##############################################
## 1. Ngram table ############################
##############################################

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

## 1.2 create probability gram tables ########
tbUnigram <- NgramTb(freqUni)
tbBigram <- NgramTb(freqBi)
tbTrigram <- NgramTb(freqTri)
tbQuatrgram <- NgramTb(freqQuatr)

setkey(tbUnigram, x)
setkey(tbBigram, x)
setkey(tbTrigram, x)
setkey(tbQuatrgram, x)
## 1.3 save the gram tables ##################
save(tbUnigram, tbBigram, tbTrigram, tbQuatrgram, file = "data/RData/tbGram.RData")

  
  
  
