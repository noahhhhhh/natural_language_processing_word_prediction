##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
library(shiny)

## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

##############################################
## 1. UI #####################################
##############################################
shinyUI(
    fluidPage(
        ## 1.1 bootstrap theme ###############
        theme = "bootstrap.css"
        
        , fluidRow(
            ## 1.2 navigation bar ############
            navbarPage(
                title = "SwiftKey - Word Prediction"
                , tabPanel("Demo")
                , tabPanel("Document")
            )
        )
        
        ## 1.3 a line ########################
        , hr()
        
        , fluidRow(
            ## 1.3 the main content ##########
            column(
                width = 4
                , textInput(
                    ## 1.4 input text box ####
                    inputId = "input"
                    , label = ""
                    , value = "How are")
                , tags$head(tags$style(type="text/css", "#input {width: 450px}"))
                , offset = 4
            )
        )
        
        , fluidRow(
            ## 1.4 the output ################
            column(
                ## 1.4.1 rank graph ######
                width = 4
                , plotOutput("rankgraph")
                )
            
            , column(
                ## 1.4.2 select and button
                width = 4
                , selectizeInput(inputId = "selectize"
                                     , label = ""
                                     , choices = c("How are")
                                     , selected = "How are"
                                     )
                
                , radioButtons(inputId = "radio"
                               , label = ""
                               , choices = c("How are")
                               )
                
                , actionButton(inputId = "button"
                               , label = ""
                               , icon = icon(name = "ok", lib = "glyphicon")
                               )
                )
            
            , column(
                width = 4
                , plotOutput("wordcloud")
                )
            )
        )
    )
