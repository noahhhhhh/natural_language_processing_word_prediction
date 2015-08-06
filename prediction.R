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
load("data/RData/tbGram.RData")

##############################################
## 1. Prediction #############################
##############################################

## 1.1 create a input cleansing function #####
InputClean <- function(input) {
    ## Use: return a cleansed string
    ## Args: input: a string
    ## Return: a string (with only alpha words and single spaces)
    
    ## input cleansing ##
    ## remove non-alpha words (includes numebers and puntuations)
    input <- gsub("[^a-zA-Z\n\']", " ", input)
    ## merge multiple spaces into one
    input <- gsub("\\s+", " ", input)
    ## to lower
    input <- tolower(input)
    ## trim leading and trailing spaces
    input <- stri_trim(input)
    
    return (input)
}

## 1.2 create a input split function #########
InputSplit <- function(input) {
    ## Use: always return 3 grams
    ## Args: input: a cleansed string
    ## Return: a vector of grams
    
    ## split the input
    vecSplit <- unlist(stri_split_fixed(input, " "))
    
    ## number of grams
    n <- length(vecSplit)
    
    ## return 3 grams
    if (n >= 3) {
        vecGrams <- vecSplit[c(n - 2, n - 1, n)]
    } else if (n == 2) {
        vecGrams <- c(" ", vecSplit)
    } else if (n == 1 & input != "") {
        vecGrams <- c(" ", " ", vecSplit)
    } else {
        vecGrams <- c(" ", " ", " ")
    }
    
    return(vecGrams)
}

## 1.3 create a backoff function #############
PredGram <- function(input) {
    ## Use: return a list of predicted words
    ## Args: input: a string
    ## Return: a sorted vector of predicted words (sorted by probability)
    
    ## set key of the grams
    setkey(tbUnigram, x)
    setkey(tbBigram, x)
    setkey(tbTrigram, x)
    setkey(tbQuatrgram, x)
    
    ## clean the input
    inputCleaned <- InputClean(input)
    ## split and get 3 grams
    inputGrams <- InputSplit(inputCleaned)
    
    ## paste the all the grams together
    inputStr3 <- paste(inputGrams, collapse = " ")
    
    ## search in the Quatrgram table
    tbResult3 <- tbQuatrgram[inputStr3][, c("y", "freq"), with = F]
    
    ## if nothing was found, go to Trigram table
    if (nrow(tbResult3) == 1 & is.na(as.vector(tbResult3[, "y", with = F][1])) == T) {
        ## paste the last 2 grams together
        inputStr2 <- paste(inputGrams[c(2, 3)], collapse = " ")
        
        ## search in the Trigram table
        tbResult2 <- tbTrigram[inputStr2][, c("y", "freq"), with = F]
        
        ## if nothing was found, go the Bigram table
        if (nrow(tbResult2) == 1 & is.na(as.vector(tbResult2[, "y", with = F][1])) == T) {
            ## paste the last gram together
            inputStr1 <- paste(inputGrams[3], collapse = " ")
            
            ## search in the Trigram table
            tbResult1 <- tbBigram[inputStr1][, c("y", "freq"), with = F]
            
            ## if nothing was found, go the Unigram table
            if (nrow(tbResult1) == 1 & is.na(as.vector(tbResult1[, "y", with = F][1])) == T) {
                ## sort the result
                tbSortedResult0 <- tbUnigram[, c("y", "freq"), with = F][order(-rank(freq), y)]
                
                return(tbSortedResult0) ## return Unigram result ##
            } else {
                ## sort the result
                tbSortedResult1 <- tbResult1[order(-rank(freq), y)]
                
                return(tbSortedResult1) ## return Bigram result ##
            }
        } else {
            ## sort the result
            tbSortedResult2 <- tbResult2[order(-rank(freq), y)]
            
            return(tbSortedResult2) ## return Trigram result ##
        }
    } else {
        ## sort the result
        tbSortedResult3 <- tbResult3[order(-rank(freq), y)]
        
        return(tbSortedResult3) ## return Quatrgram result ##
    }
    
}

PredGram("what are you")
