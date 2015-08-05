##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(tm)
require(RWeka)
require(data.table)
rm(list = ls())

## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 load the file #########################
# full data
load("data/RData/corpusAll.RData") 
pathAll <- file.path(".", "data", "en_US", "temp")
corpusAll <- Corpus(DirSource(pathAll, encoding = "UTF-8")
                        , readerControl = list(reader = readPlain
                                               , language = "en_US"
                                               , load = T
                        )
)

# sample data
pathSample <- file.path(".", "data", "samples")
corpusSamples <- Corpus(DirSource(pathSample, encoding = "UTF-8")
                    , readerControl = list(reader = readPlain
                                           , language = "en_US"
                                           , load = T
                    )
)

##############################################
## 1. Tokenization ###########################
##############################################

## 1.1 create functions for tokenization ####
delimToken <- " \\t\\r\\n.!?,;\"()"
UnigramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 1), paste, collapse = " "), use.names = FALSE)
BigramTokenizer <- function(x)
    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
TrigramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
QuatrgramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 4), paste, collapse = " "), use.names = FALSE)

## 1.2 tokenize #############################
dtmUnigram <- DocumentTermMatrix(corpusSamples)
dtmBigram <- DocumentTermMatrix(corpusSamples, control = list(tokenize = BigramTokenizer))
dtmTrigram <- DocumentTermMatrix(corpusSamples, control = list(tokenize = TrigramTokenizer))
dtmQuatrgram <- DocumentTermMatrix(corpusSamples, control = list(tokenize = QuatrgramTokenizer))

## 1.3 save the matrix ######################
mxUnigram <- as.matrix(dtmUnigram)
mxBigram <- as.matrix(dtmBigram)
mxTrigram <- as.matrix(dtmTrigram)
mxQuatrgram <- as.matrix(dtmQuatrgram)

## 1.4 remove the number-letter combination #
mxUnigram <- mxUnigram[, -grep("[[:digit:]]+", colnames(mxUnigram))]
mxBigram <- mxBigram[, -grep("[[:digit:]]+", colnames(mxBigram))]
mxTrigram <- mxTrigram[, -grep("[[:digit:]]+", colnames(mxTrigram))]
mxQuatrgram <- mxQuatrgram[, -grep("[[:digit:]]+", colnames(mxQuatrgram))]

## 1.5 frequncy table #######################
freqUni <- colSums(mxUnigram)
freqBi <- colSums(mxBigram)
freqTri <- colSums(mxTrigram)
freqQuatr <- colSums(mxQuatrgram)

## 1.6 coverage chart #######################
# create a running total vector
sortUni <- sort(freqUni, decreasing = T)
cumUni <- cumsum(sortUni)
plot(x = cumUni, y = sortUni, type = "line")

sortBi <- sort(freqBi, decreasing = T)
cumBi <- cumsum(sortBi)
plot(x = cumBi, y = sortBi, type = "line")

sortTri <- sort(freqTri, decreasing = T)
cumTri <- cumsum(sortTri)
plot(x = cumTri, y = sortTri, type = "line")

sortQuatr <- sort(freqQuatr, decreasing = T)
cumQuatr <- cumsum(sortQuatr)
plot(x = cumQuatr, y = sortQuatr, type = "line")

## 1.7 remove rare events ###################
# freqUni <- freqUni[which(freqUni > 1)]
# freqBi <- freqBi[which(freqBi > 1)]
# freqTri <- freqTri[which(freqTri > 1)]
# freqQuatr <- freqQuatr[which(freqQuatr > 1)]

save(freqUni, freqBi, freqTri, freqQuatr, file = "data/RData/freq.RData")
