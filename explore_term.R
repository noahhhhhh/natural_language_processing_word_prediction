##############################################
## 0. Read the Processed Files ###############
##############################################

## 0.1 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

#######################
## 0.2 list the files ########################
listFiles <- list.files("data/samples/")
list.files("data/samples/")

###################
## 0.3 read files ############################
# paste directory and file names
dataDir <- file.path(".", "data", "samples/")
files <- paste(dataDir, listFiles)
# trim the space
files <- gsub(" ", "", files)

# read the en_US.blogs.txt file
con <- file(files[1], open = "r")
textBlogP <- readLines(con)
close(con)

# read the en_US.blogs.txt file
con <- file(files[2], open = "r")
textNewsP <- readLines(con)
close(con)

# read the en_US.twitter.txt file
con <- file(files[3], open = "r")
textTwitterP <- readLines(con)
close(con)

# read into a corpus
require(tm)
pathSample <- file.path("data", "samples")
corpusSample <- Corpus(DirSource(pathSample, encoding = "UTF-8"), 
                       readerControl = list(reader = readPlain
                                            , language = "en_US"
                                            , load = T))

# combine them into one data table
require(data.table)
dfSample <- data.frame(text = unlist(sapply(corpusSample, '[',"content")), stringsAsFactors = F)
dtSample <- data.table(dfSample)

##############################################
## 1. Explore ################################
##############################################
# tokenization TODO: NX: too time consuming
# require(RWeka)
# delimToken <- " \\t\\r\\n.!?,;\"()"
# oneToken <- NGramTokenizer(dtSample, Weka_control(min = 1, max = 1))
# biToken <- NGramTokenizer(dtSample, Weka_control(min = 2, max = 2, delimiters = delimToken))
# triToken <- NGramTokenizer(dtSample, Weka_control(min = 3, max = 3, delimiters = delimToken))
# quatrToken <- NGramTokenizer(dtSample, Weka_control(min = 4, max = 4, delimiters = delimToken))

# document-term matrix
require(RWeka)
delimToken <- " \\t\\r\\n.!?,;\"()"
UnigramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 1), paste, collapse = " "), use.names = FALSE)
BigramTokenizer <- function(x)
    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
TrigramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
QuatrgramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), 4), paste, collapse = " "), use.names = FALSE)

# dtm_ngram
dtmUnigram <- DocumentTermMatrix(corpusSample)
dtmBigram <- DocumentTermMatrix(corpusSample, control = list(tokenize = BigramTokenizer))
dtmTrigram <- DocumentTermMatrix(corpusSample, control = list(tokenize = TrigramTokenizer))
dtmQuatrgram <- DocumentTermMatrix(corpusSample, control = list(tokenize = QuatrgramTokenizer))

# save the matrix
mxUnigram <- as.matrix(dtmUnigram)
mxBigram <- as.matrix(dtmBigram)
mxTrigram <- as.matrix(dtmTrigram)
mxQuatrgram <- as.matrix(dtmQuatrgram)

write.csv(mxUnigram, file="data/document_term_matrix/dtmUnigram.csv", quote = F, row.names = F)
write.csv(mxBigram, file="data/document_term_matrix/dtmBigram.csv", quote = F, row.names = F)
write.csv(mxTrigram, file="data/document_term_matrix/dtmTrigram.csv", quote = F, row.names = F)
write.csv(mxQuatrgram, file="data/document_term_matrix/dtmQuatrgram.csv", quote = F, row.names = F)

# frequency
freqUni <- colSums(as.matrix(mxUnigram))
freqBi <- colSums(as.matrix(mxBigram))
freqTri <- colSums(as.matrix(mxTrigram))
freqQuatr <- colSums(as.matrix(mxQuatrgram))

sortUni <- sort(freqUni)
sortBi <- sort(freqBi)
sortTri <- sort(freqTri)
sortQuatr <- sort(freqQuatr)

save(sortUni, file = "data/RData/sortUni.RData")
save(sortBi, file = "data/RData/sortBi.RData")
save(sortTri, file = "data/RData/sortTri.RData")
save(sortQuatr, file = "data/RData/sortQuatr.RData")
load(file = "data/RData/sortUni.RData")
load(file = "data/RData/sortBi.RData")
load(file = "data/RData/sortTri.RData")
load(file = "data/RData/sortQuatr.RData")
# plot a frequency graph
# create a uni gram frequency table (top 15)

dtFreqUni <- data.table("Unigram" = names(tail(sortUni, 15))
                         , "Frequency Unigram" = tail(sortUni, 15)
                         , keep.rownames = F)

dtFreqBi <- data.table("Bigram" = names(tail(sortBi, 15))
                        , "Frequency Bigram" = tail(sortBi, 15)
                        , keep.rownames = F)

dtFreqTri <- data.table("Trigram" = names(tail(sortTri, 15))
                        , "Frequency Trigram" = tail(sortTri, 15)
                        , keep.rownames = F)

dtFreqQuatr <- data.table("Quatrgram" = names(tail(sortQuatr, 15))
                        , "Frequency Quatr" = tail(sortQuatr, 15)
                        , keep.rownames = F)

dtFreq <- cbind(dtFreqUni, dtFreqBi, dtFreqTri, dtFreqQuatr)
write.csv(dtFreq, file = "data/RData/dtFreq.csv", quote = F, row.names = F)
dtFreq <- read.csv("data/RData/dtFreq.csv")


require(reshape)
meltFreq <- melt(dtFreq)
write.csv(meltFreq, file = "data/RData/meltFreq.csv", quote = F, row.names = F)
meltFreq <- read.csv("data/RData/meltFreq.csv")

# plot the Unigram Frequency
require(ggplot2)
require(scales)
gFreqUni <- ggplot(meltFreq[, c("Unigram", "variable", "value")], aes(x = Unigram, y = value))
gFreqUni <- gFreqUni + geom_bar(stat = "identity", fill = "skyblue2")
gFreqUni <- gFreqUni + xlab("Unigram Word")
gFreqUni <- gFreqUni + scale_y_continuous(name = "Frequency", labels = comma)
gFreqUni <- gFreqUni + ggtitle("Stats: Unigram Frequency")
gFreqUni <- gFreqUni + theme_bw()
gFreqUni

gFreqBi <- ggplot(meltFreq[, c("Bigram", "variable", "value")], aes(x = Bigram, y = value))
gFreqBi <- gFreqBi + geom_bar(stat = "identity", fill = "skyblue2")
gFreqBi <- gFreqBi + xlab("Bigram Words")
gFreqBi <- gFreqBi + scale_y_continuous(name = "Frequency", labels = comma)
gFreqBi <- gFreqBi + ggtitle("Stats: Bigram Frequency")
gFreqBi <- gFreqBi + theme_bw()
gFreqBi <- gFreqBi + theme(axis.text.x = element_text(angle = 45, hjust = 1))
gFreqBi

gFreqTri <- ggplot(meltFreq[, c("Trigram", "variable", "value")], aes(x = Trigram, y = value))
gFreqTri <- gFreqTri + geom_bar(stat = "identity", fill = "skyblue2")
gFreqTri <- gFreqTri + xlab("Trigram Words")
gFreqTri <- gFreqTri + scale_y_continuous(name = "Frequency", labels = comma)
gFreqTri <- gFreqTri + ggtitle("Stats: Trigram Frequency")
gFreqTri <- gFreqTri + theme_bw()
gFreqTri <- gFreqTri + theme(axis.text.x = element_text(angle = 45, hjust = 1))
gFreqTri

gFreqQuatr <- ggplot(meltFreq[, c("Quatrgram", "variable", "value")], aes(x = Quatrgram, y = value))
gFreqQuatr <- gFreqQuatr + geom_bar(stat = "identity", fill = "skyblue2")
gFreqQuatr <- gFreqQuatr + xlab("Quatrgram Words")
gFreqQuatr <- gFreqQuatr + scale_y_continuous(name = "Frequency", labels = comma)
gFreqQuatr <- gFreqQuatr + ggtitle("Stats: Quatrgram Frequency")
gFreqQuatr <- gFreqQuatr + theme_bw()
gFreqQuatr <- gFreqQuatr + theme(axis.text.x = element_text(angle = 45, hjust = 1))
gFreqQuatr

# word cloud
require(wordcloud)
require(RColorBrewer)
pal <- brewer.pal(6, "Dark2")
# wordcloud unigram
set.seed(999)
wordcloudUni <- wordcloud(names(tail(sortUni, 30)), tail(sortUni, 30), scale = c(4, 1), colors = pal)
set.seed(999)
wordcloudBi <- wordcloud(names(tail(sortBi, 30)), tail(sortBi, 30), scale = c(3, .5), colors = pal)
set.seed(999)
wordcloudTri <- wordcloud(names(tail(sortTri, 30)), tail(sortTri, 30), scale = c(3, .25), colors = pal)
set.seed(999)
wordcloudQuatr <- wordcloud(names(tail(sortQuatr, 30)), tail(sortQuatr, 30), scale = c(2,.25), colors = pal)

# 