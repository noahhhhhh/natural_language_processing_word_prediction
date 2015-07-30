##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(tm)
require(stringi)
rm(list = ls())
## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 set the path for reading ##############
pathAll <- file.path("data", "en_US")
listAllFiles <- list.files(pathAll)
listAllFiles

## 0.4 read the files into a corpus ##########
corpusAll <- Corpus(DirSource(pathAll, encoding = "UTF-8")
                    , readerControl = list(reader = readPlain
                                           , language = "en_US"
                                           , load = T
                                           )
                    )

##############################################
## 1. Basic Stats ############################
##############################################

## 1.1 lines #################################
for (i in 1: length(listAllFiles)) {
  # print the lines
  print (paste("No. of lines -",  listAllFiles[i], ":", length(as.character(corpusAll[[i]]))))
}
i <- 1

##############################################
## 2. Preprocessing ##########################
##############################################

## 2.1 translate Latin to ASCII ##############
for (i in 1: length(listAllFiles)) {
  # print the lines
  corpusAll[[i]] <- stri_trans_general(corpusAll[[i]], "Latin-ASCII")
  print(paste("Latin-ASCII -", listAllFiles[i], ": Done"))
}
i <- 1

## 2.2 translate Latin to ASCII ##############
gsub("[^[:digit:]]*[[:digit:]]+[^[:digit:]]*", " ", "123 a1 2b 345 as 456 123 9 09 1 asdf af55a ")
