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
    
    ## determines the positions of space in grams
    vecPos <- unlist(gregexpr(" ", names(mxFreq)[1])[1])
    
    ## length of the positions of space
    len <- length(vecPos)
    
    ## determinss the n of the ngram
    if (len == 1) {
        if (vecPos == -1) {
            n <- 1 ## Unigram
        } else {
            n <- 2 ## Bigram
        }
    } else {
        n <- len + 1 ## others
    }
    
    
    ## substring the grams into 2 parts, last word and the rest words
    listWords <- stri_split_fixed(names(mxFreq), " ")
    vecLastWord <- sapply(listWords, function (x) unlist(x)[n])
    if (n == 1) {
        vecRestWowrds <- sapply(listWords, function (x) paste(unlist(x)[n], collapse = " "))
    } else {
        vecRestWowrds <- sapply(listWords, function (x) paste(unlist(x)[-n], collapse = " "))
    }
    
    ## build a data table
    tbGram <- data.table("gram" = names(mxFreq)
                         , "prob" = mxFreq
                         , "x" = vecRestWowrds
                         , "y" = vecLastWord)
    
    return(tbGram)
}

## 1.2 create probability gram tables ########
tbUnigram <- NgramTb(freqUni)
tbBigram <- NgramTb(freqBi)
tbTrigram <- NgramTb(freqTri)
tbQuatrgram <- NgramTb(freqQuatr)

setnames(tbUnigram, "gram", "unigram")
setnames(tbBigram, "gram", "bigram")
setnames(tbTrigram, "gram", "trigram")
setnames(tbQuatrgram, "gram", "quatrgram")

## 1.3 update the prob using something like ##
## p(i am a) = count(i am a) / count(i am) ###
## - the numerator is the existing prob ######
## - the denumerator is from the prob of a ###
## lower gram model ##########################

## quatrgram
tbQuatrgram <- cbind(tbQuatrgram[, !"prob", with = F]
                     , data.table(
                         merge(x = as.data.frame(tbQuatrgram)
                               , y = tbTrigram
                               , by.x = "x"
                               , by.y = "trigram")
                     )[, prob := prob.x / prob.y][, "prob", with = F])

## trigram
tbTrigram <- cbind(tbTrigram[, !"prob", with = F]
                   , data.table(
                       merge(x = as.data.frame(tbTrigram)
                             , y = tbBigram
                             , by.x = "x"
                             , by.y = "bigram")
                   )[, prob := prob.x / prob.y][, "prob", with = F])

## bigram
tbBigram <- cbind(tbBigram[, !"prob", with = F]
                  , data.table(
                      merge(x = as.data.frame(tbBigram)
                            , y = tbUnigram
                            , by.x = "x"
                            , by.y = "unigram")
                  )[, prob := prob.x / prob.y][, "prob", with = F])

## unigram
## total number of words (unigram)
nWords <- sum(tbUnigram[, "prob", with = F])
tbUnigram <- tbUnigram[, "prob" := prob / nWords]

## 1.4 save the gram tables ##################
save(tbUnigram, tbBigram, tbTrigram, tbQuatrgram, file = "data/RData/tbGram.RData")

