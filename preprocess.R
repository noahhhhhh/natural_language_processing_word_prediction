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

# paste directory and file names
dataDir <- file.path(".", "data", "en_US/")
files <- paste(dataDir, listAllFiles)
# trim the space
files <- gsub(" ", "", files)

## 0.4 read the files ########################
# read the en_US.blogs.txt file
con <- file(files[1], open = "r")
textBlog <- readLines(con)
close(con)

# read the en_US.blogs.txt file
con <- file(files[2], open = "r")
textNews <- readLines(con)
close(con)

# read the en_US.twitter.txt file
con <- file(files[3], open = "r")
textTwitter <- readLines(con)
close(con)

##############################################
## 2. Preprocessing ##########################
##############################################

## 2.1 translate Latin to ASCII ##############
textBlog <- stri_trans_general(textBlog, "Latin-ASCII")
print(paste("Latin-ASCII -", "textBlog", ": Done"))
textNews <- stri_trans_general(textNews, "Latin-ASCII")
print(paste("Latin-ASCII -", "textNews", ": Done"))
textTwitter <- stri_trans_general(textTwitter, "Latin-ASCII")
print(paste("Latin-ASCII -", "textTwitter", ": Done"))

## 2.2 remove non-ASCII characters ###########
textBlog <- gsub("[^\\x00-\\x7F]+", " ", textBlog)
print(paste("Non ASCII to English -", "textBlog", ": Done"))
textNews <- gsub("[^\\x00-\\x7F]+", " ", textNews)
print(paste("Non ASCII to English -", "textNews", ": Done"))
textTwitter <- gsub("[^\\x00-\\x7F]+", " ", textTwitter)
print(paste("Non ASCII to English -", "textTwitter", ": Done"))

## 2.3 remove numbers between spaces #########
textBlog <- gsub("\\b[[:digit:]]+\\b", " ", textBlog)
print(paste("Remove numbers -", "textBlog", ": Done"))
textNews <- gsub("\\b[[:digit:]]+\\b", " ", textNews)
print(paste("Remove numbers -", "textNews", ": Done"))
textTwitter <- gsub("\\b[[:digit:]]+\\b", " ", textTwitter)
print(paste("Remove numbers -", "textTwitter", ": Done"))

## 2.4 save the files for later use ##########
write.table(textBlog, "data/en_US/temp/textBlog.txt", quote = F, row.names = F, col.names = F)
write.table(textNews, "data/en_US/temp/textNews.txt", quote = F, row.names = F, col.names = F)
write.table(textTwitter, "data/en_US/temp/textTwitter.txt", quote = F, row.names = F, col.names = F)

## 2.4 read the files into a corpus ##########
pathTemp <- file.path(".", "data", "en_US", "temp")
corpusAll <- Corpus(DirSource(pathTemp, encoding = "UTF-8")
                    , readerControl = list(reader = readPlain
                                           , language = "en_US"
                                           , load = T
                    )
)

## 2.5 tolower ###############################
corpusAll <- tm_map(corpusAll, content_transformer(tolower))
print(paste("To lower - All docs: Done"))

## 2.6 remove punctuations ####################
corpusAll <- tm_map(corpusAll, content_transformer(removePunctuation))
print(paste("Remove Punctuations - All docs: Done"))

## 2.7 strip whitespace #######################
corpusAll <- tm_map(corpusAll, content_transformer(stripWhitespace))
print(paste("Strip whitespaces - All docs: Done"))

