##############################################
## 0. Read the Processed Files ###############
##############################################

## 0.1 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

#######################
## 0.2 list the files ########################
listFiles <- list.files("data/processed_files/")
list.files("data/processed_files/")

###################
## 0.3 read files ############################
# paste directory and file names
dataDir <- file.path(".", "data", "processed_files/")
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

##############################################
## 1. Sampling ###############################
##############################################
# 1.1 refer to a sampling function
# Cite: http://stackoverflow.com/questions/15532810/reading-40-gb-csv-file-into-r-using-bigmemory
SampleText <- function(fname, n, seed, header = FALSE, ..., reader = readLines, readmode){
    set.seed(seed)
    con <- file(fname, open = readmode)
    buf <- readLines(con, n, skipNul = TRUE)
    n_tot <- length(buf)
    
    repeat{
        txt <- readLines(con, n, skipNul = TRUE)
        if ((n_txt <- length(txt)) == 0L)
            break
        
        n_tot <- n_tot + n_txt
        n_keep <- rbinom(1, n_txt, n_txt / n_tot)
        if (n_keep == 0L)
            next
        
        keep <- sample(n_txt, n_keep)
        drop <- sample(n, n_keep)
        buf[drop] <- txt[keep]
    }
    close(con)
    reader(textConnection(buf, ...))
}

# 1.2 read samples
sampleBlogP <- SampleText(fname = files[1]
                          , n = 20000
                          , seed = 999
                          , readmode = "r")
sampleNewsP <- SampleText(fname = files[2]
                          , n = 20000
                          , seed = 999
                          , readmode = "r")
sampleTwitterP <- SampleText(fname = files[3]
                          , n = 20000
                          , seed = 999
                          , readmode = "r")

# 1.3 save the samples
write.table(sampleBlogP, "data/samples/blog_sample.txt", quote = F, col.names = F, row.names = F)
write.table(sampleNewsP, "data/samples/news_sample.txt", quote = F, col.names = F, row.names = F)
write.table(sampleTwitterP, "data/samples/twitter_sample.txt", quote = F, col.names = F, row.names = F)
