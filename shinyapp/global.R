##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(shiny)
require(tm)
require(wordcloud)
require(memoise)
require(RColorBrewer)

rm(list = ls())
gc()
## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 load the file and prediction function #
source("natural_language_processing_word_prediction/prediction.R")
source("natural_language_processing_word_prediction/shinyapp/RankingChart.R")
