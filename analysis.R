##############################################
## 0. Set up #################################
##############################################

############################
## 0.0 clean up the memory ###################
require(stringr)
require(data.table)
require(ggplot2)
require(reshape)
require(scales)
require(tm)
require(SnowballC)
require(RWeka)
require(wordcloud)
require(RColorBrewer)
rm(list=ls(all = T))
#####################################
## 0.1 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

#######################
## 0.2 list the files ########################
listFiles <- list.files("data/en_US/")
list.files("data/en_US/")

###################
## 0.3 read files ############################
# paste directory and file names
dataDir <- file.path(".", "data", "en_US/")
files <- paste(dataDir, listFiles)
# trim the space
files <- gsub(" ", "", files)

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
## 1. Preprocess #############################
##############################################
require(stringr)
## 1.1 replace punctuations and numbers ######
##############################################
textBlog <- gsub("[[:punct:][:digit:]]", " ", textBlog)
textNews <- gsub("[[:punct:][:digit:]]", " ", textNews)
textTwitter <- gsub("[[:punct:][:digit:]]", " ", textTwitter)

## 1.2 merge multiple space into one #########
##############################################
textBlog <- gsub("\\s+", " ", textBlog)
textNews <- gsub("\\s+", " ", textNews)
textTwitter <- gsub("\\s+", " ", textTwitter)

## 1.3 remove leading and trailing spaces ####
##############################################
textBlog <- str_trim(textBlog)
textNews <- str_trim(textNews)
textTwitter <- str_trim(textTwitter)

## 1.4 Remove non Latin characters ###########
##############################################
# 1.4.1 number of non Latin words
# create a function to filter specified words
FilterWords <- function(txt, re = "[^a-zA-Z]"){
    # note: filter specified words
    # Args: txt (character): a text file
    # Return: txt (character): a text file which has been filtered out the specified words
    txtTemp <- gsub(re, " ", txt)
    txtTemp <- str_trim(gsub("\\s+", " ", txtTemp))
    txtTemp
}
# create a function to count the number of words
CountWords <- function(txt){
    # note: count the number of words
    # Args: txt (character): a text file
    # Return: num (numeric): number of words in txt
    num <- sum(length(unlist(str_split(txt, " "))))
    num
}

countWordsNonLatinBlog <- CountWords(FilterWords(textBlog, re = "[a-zA-Z]")) # 907,021
countWordsNonLatinNews <- CountWords(FilterWords(textNews, re = "[a-zA-Z]")) # 1,027,325
countWordsNonLatinTwitter <- CountWords(FilterWords(textTwitter, re = "[a-zA-Z]")) # 2,361,559
vectorWordsNonLatin <- c(countWordsNonLatinBlog, countWordsNonLatinNews, countWordsNonLatinTwitter)

# 1.4.2 number of Latin words
# filtered files
textBlog <- FilterWords(textBlog, re = "[^a-zA-Z]")
textNews <- FilterWords(textNews, re = "[^a-zA-Z]")
textTwitter <- FilterWords(textTwitter, re = "[^a-zA-Z]")

# number of Latin words in the filtered files
countWordsLatinBlog <- CountWords(textBlog) # 37,881,240
countWordsLatinNews <- CountWords(textNews) # 34,617,304
countWordsLatinTwitter <- CountWords(textTwitter) # 30,557,099
vectorWordsLatin <- c(countWordsLatinBlog, countWordsLatinNews, countWordsLatinTwitter)

##############################################
## 2. Explore ################################
##############################################

## 2.1 Initial Snapshot ######################
##############################################
# 2.1.1 number of lines
countLinesBlog <- length(textBlog) # 899,288
countLinesNews <- length(textNews) # 1,010,242
countLinesTwitter <- length(textTwitter) # 2,360,148
vectorInitCountLines <- c(countLinesBlog, countLinesNews, countLinesTwitter)

# 2.1.2 number of words
# covered by 1.4.1 and 1.4.2

# 2.1.3 create a summary table
require(data.table)
dtInitSnap <- data.table("Text" = c("Blog", "News", "Twitter")
                         , "Lines" = vectorInitCountLines
                         , "LatinWords" = vectorWordsLatin
                         , "NonLatinWords" = vectorWordsNonLatin
                         , "WordsPerLine" = round(vectorWordsLatin / vectorInitCountLines)
                         , keep.rownames = F)
dtInitSnap
save(dtInitSnap, file = "data/RData/dtInitSnap.RData")
write.csv(dtInitSnap, file = "data/RData/dtInitSnap.csv", quote = F, row.names = F)

dtInitSnap <- read.csv("data/RData/dtInitSnap.csv")

# 2.1.4 melt the summary table
require(reshape)
meltInitSnap <- melt(dtInitSnap)
meltInitSnap

# 2.1.5 plot the summary table
require(ggplot2)
require(scales)
# number of Lines
gInitPlotLines <- ggplot(subset(meltInitSnap, variable == "Lines"), aes(x = Text, y = value))
gInitPlotLines <- gInitPlotLines + geom_bar(stat = "identity", fill = "skyblue2")
gInitPlotLines <- gInitPlotLines + xlab("File Name")
gInitPlotLines <- gInitPlotLines + scale_y_continuous(name = "Number of Lines", labels = comma)
gInitPlotLines <- gInitPlotLines + ggtitle("Stats: Lines")
gInitPlotLines <- gInitPlotLines + theme_bw()
gInitPlotLines

# number of Latin Words
gInitPlotLatinWords <- ggplot(subset(meltInitSnap, variable == "LatinWords"), aes(x = Text, y = value))
gInitPlotLatinWords <- gInitPlotLatinWords + geom_bar(stat = "identity", fill = "skyblue2")
gInitPlotLatinWords <- gInitPlotLatinWords + xlab("File Name")
gInitPlotLatinWords <- gInitPlotLatinWords + scale_y_continuous(name = "Number of Latin Words", labels = comma)
gInitPlotLatinWords <- gInitPlotLatinWords + ggtitle("Stats: Latin Words")
gInitPlotLatinWords <- gInitPlotLatinWords + theme_bw()
gInitPlotLatinWords

# number of Latin Words
gInitPlotNonLatinWords <- ggplot(subset(meltInitSnap, variable == "NonLatinWords"), aes(x = Text, y = value))
gInitPlotNonLatinWords <- gInitPlotNonLatinWords + geom_bar(stat = "identity", fill = "skyblue2")
gInitPlotNonLatinWords <- gInitPlotNonLatinWords + xlab("File Name")
gInitPlotNonLatinWords <- gInitPlotNonLatinWords + scale_y_continuous(name = "Number of Non Latin Words", labels = comma)
gInitPlotNonLatinWords <- gInitPlotNonLatinWords + ggtitle("Stats: Non Latin Words")
gInitPlotNonLatinWords <- gInitPlotNonLatinWords + theme_bw()
gInitPlotNonLatinWords

# number of Words per Line
gInitPlotWpL <- ggplot(subset(meltInitSnap, variable == "WordsPerLine"), aes(x = Text, y = value))
gInitPlotWpL <- gInitPlotWpL + geom_bar(stat = "identity", fill = "skyblue2")
gInitPlotWpL <- gInitPlotWpL + xlab("File Name")
gInitPlotWpL <- gInitPlotWpL + scale_y_continuous(name = "Number of Words per Line", labels = comma)
gInitPlotWpL <- gInitPlotWpL + ggtitle("Stats: Words per Lines")
gInitPlotWpL <- gInitPlotWpL + theme_bw()
gInitPlotWpL

## 2.2 Term Frequency ########################
##############################################
require(tm)
# 2.2.1 read the corpus
path <- file.path("data", "en_US")
corpusRaw <- Corpus(DirSource(path, encoding = "UTF-8"), 
                    readerControl = list(reader = readPlain
                                         , language = "en_US"
                                         , load = T))

# 2.2.2 preprocess
# to lower
corpusRaw <- tm_map(corpusRaw, content_transformer(tolower))

# remove numbers # TODO: NX: this should be done after tokenization
corpusRaw <- tm_map(corpusRaw, content_transformer(removeNumbers))

# remove punctuations # TODO: NX: this should be done after tokenization
corpusRaw <- tm_map(corpusRaw, content_transformer(removePunctuation))

# # remove bad words # TODO: NX: this should be done after tokenization
# pathBadWords <- file.path("data", "badwords_en_US", "badwords.txt")
# # dfBadWords <- read.table(pathBadWords, sep = "\n") (NX: this should be done after tokenization)
# vectorBadWords <- c(dfBadWords[1])
# corpusRaw <- tm_map(corpusRaw, removeWords, vectorBadWords)

# stemming TODO: NX: this step might need to be removed when building n-gram model
require(SnowballC)
corpusRawStem <- tm_map(corpusRaw, content_transformer(stemDocument))

# # replace /|@|\\| and Punctuations with space
# ToSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
# corpusRaw <- tm_map(corpusRawStem, ToSpace, "/|@|\\|||[[:punct:]]", lazy = T)

# # merge multiple space into one
# corpusRaw <- tm_map(corpusRaw, ToSpace, "\\s+", lazy = T)
# strip space
corpusRaw <- tm_map(corpusRawStem, content_transformer(stripWhitespace))
# save it for later use
writeCorpus(corpusRaw[1], path = "data/processed_files/", file = paste("blog_processsed.txt"))
writeCorpus(corpusRaw[2], path = "data/processed_files/", file = paste("news_processsed.txt"))
writeCorpus(corpusRaw[3], path = "data/processed_files/", file = paste("twitter_processsed.txt"))
save(corpusRaw, file = paste("data/processsed.RData"))

