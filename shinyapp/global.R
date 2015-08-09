##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
library(shiny)
library(tm)
library(wordcloud)
library(memoise)
require(RColorBrewer)

rm(list = ls())
gc()
## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

## 0.3 load the file and prediction function #
source("natural_language_processing_word_prediction/prediction.R")
source("natural_language_processing_word_prediction/shinyapp/RankingChart.R")
##############################################
## 1. Global #################################
##############################################

## 1.1 word cloud ############################
# wordcloud(names(tail(sortUni, 30)), tail(sortUni, 30), scale = c(6, 2), colors = pal)