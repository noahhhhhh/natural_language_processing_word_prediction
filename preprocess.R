##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(tm)
require(stringi)
require(SnowballC)
rm(list = ls())
## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 set the path for reading ##############

pathAll <- file.path(".", "data", "en_US")
listAllFiles <- list.files(pathAll, pattern = "txt")
listAllFiles

# paste directory and file names
files <- file.path(pathAll, listAllFiles)

## 0.4 read the files ########################
# read the files into a list
filesList <- list()

i <- 1
for (i in 1:length(listAllFiles)) {
  con <- file(files[i], open = "rb")
  filesList[[i]] <- readLines(con)
  close(con)
  print(paste("Reading file - ", listAllFiles[i], ": Done"))
}
i <- 1

##############################################
## 2. Preprocessing ##########################
##############################################

## 2.1 translate Latin to ASCII ##############
for (i in 1:length(listAllFiles)) {
  filesList[[i]] <- iconv(filesList[[i]], to = "UTF-8")
  filesList[[i]] <- stri_trans_general(filesList[[i]], "Latin-ASCII")
  print(paste("Latin-ASCII -", listAllFiles[i], ": Done"))
}
i <- 1

## 2.2 convert into UTF-8 and remove non_ASCII
## characters ################################
for (i in 1:length(listAllFiles)) {
  filesList[[i]] <-gsub("[^[:alpha:][:digit:][:punct:][:space:]]+", " ", filesList[[i]])
  print(paste("Non ASCII to English -", listAllFiles[i], ": Done"))
}
i <- 1

## 2.3 remove numbers between spaces #########
for (i in 1:length(listAllFiles)) {
  filesList[[i]] <- gsub("\\b[[:digit:]]+\\b", " ", filesList[[i]])
  print(paste("Remove numbers -", listAllFiles[i], ": Done"))
}
i <- 1

## 2.4 save the files for later use ##########
write.table(filesList[[1]], "data/en_US/temp/textBlog.txt", quote = F, row.names = F, col.names = F)
write.table(filesList[[2]], "data/en_US/temp/textNews.txt", quote = F, row.names = F, col.names = F)
write.table(filesList[[3]], "data/en_US/temp/textTwitter.txt", quote = F, row.names = F, col.names = F)

## 2.4 read the files into a corpus ##########
pathTemp <- file.path(".", "data", "en_US", "temp")
corpusAll <- Corpus(DirSource(pathTemp, encoding = "UTF-8")
                    , readerControl = list(reader = readPlain
                                           , language = "en_US"
                                           , load = T
                    )
)

## 2.5 remove punctuations ####################
corpusAll <- tm_map(corpusAll, content_transformer(removePunctuation))
print(paste("Remove Punctuations - All docs: Done"))

## 2.6 tolower ################################
corpusAll <- tm_map(corpusAll, content_transformer(tolower))
print(paste("To lower - All docs: Done"))

## 2.7 strip whitespace #######################
corpusAll <- tm_map(corpusAll, content_transformer(stripWhitespace))
print(paste("Strip whitespaces - All docs: Done"))

## 2.8 remove bad words #######################
pathBadWords <- file.path("data", "badwords_en_US", "badwords.txt")
dfBadWords <- read.table(pathBadWords, sep = "\n") # (NX: this should be done after tokenization)
mxBadWords <- as.matrix(dfBadWords[1])
corpusAll <- tm_map(corpusAll, removeWords, mxBadWords)
print(paste("Remove bad words - All docs: Done"))

## 2.9 stemming ###############################
corpusAll <- tm_map(corpusAll, content_transformer(stemDocument))
print(paste("Stemming - All docs: Done"))

## 2.10 save the files for later use ##########
write.table(as.character(corpusAll[[1]]), "data/en_US/temp/textBlog_preP.txt", quote = F, row.names = F, col.names = F)
write.table(as.character(corpusAll[[2]]), "data/en_US/temp/textNews_preP.txt", quote = F, row.names = F, col.names = F)
write.table(as.character(corpusAll[[3]]), "data/en_US/temp/textTwitter_preP.txt", quote = F, row.names = F, col.names = F)
save(corpusAll, file = "data/RData/corpusAll.RData")
