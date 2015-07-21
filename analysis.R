# set up the working directory
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

# list the files
listFiles <- list.files("data/en_US/")
list.files("data/en_US/")

# read files
dataDir <- "data/en_US/"
# paste directory and file names
files <- paste(dataDir, listFiles)
# trim the space
files <- gsub(" ", "", files)
con <- file(files[1], open = "r")
line <- readLines(con)
close(con)

require(tm)
fileDir <- file.path(".", "data", "test")
docs <- Corpus(DirSource(fileDir))
writeLines(as.character(docs[[1]]))
dtm <- DocumentTermMatrix(docs)
docs <- tm_map(docs, removePunctuation)


