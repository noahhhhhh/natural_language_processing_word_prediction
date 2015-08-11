##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(shiny)

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
                ## 1.4.2 predictions and button
                width = 4
                ## 1.4.2.1 #1 guess
                , div(style = "display:inline-block"
                      , textInput(
                          ## 1.4 input text box ####
                          inputId = "outputGuess1"
                          , label = "#1 Guess"
                          )
                      , width = 2)
                , div(style = "display:inline-block"
                      , actionButton(inputId = "button1"
                                     , label = ""
                                     , icon = icon(name = "ok", lib = "glyphicon"))
                      )
                ## 1.4.2.2 #2 guess
                , div(style = "display:inline-block"
                      , textInput(
                          ## 1.4 input text box ####
                          inputId = "outputGuess2"
                          , label = "#2 Guess"
                          )
                      , width = 2)
                , div(style = "display:inline-block"
                      , actionButton(inputId = "button2"
                                     , label = ""
                                     , icon = icon(name = "ok", lib = "glyphicon"))
                )
                
                ## 1.4.2.3 #3 guess
                , div(style = "display:inline-block"
                      , textInput(
                          ## 1.4 input text box ####
                          inputId = "outputGuess3"
                          , label = "#3 Guess"
                          )
                      , width = 2)
                , div(style = "display:inline-block"
                      , actionButton(inputId = "button3"
                                     , label = ""
                                     , icon = icon(name = "ok", lib = "glyphicon"))
                )
                
                ## 1.4.2.4 #4 guess
                , div(style = "display:inline-block"
                      , textInput(
                          ## 1.4 input text box ####
                          inputId = "outputGuess4"
                          , label = "#4 Guess"
                          )
                      , width = 2)
                , div(style = "display:inline-block"
                      , actionButton(inputId = "button4"
                                     , label = ""
                                     , icon = icon(name = "ok", lib = "glyphicon"))
                )
                
                ## 1.4.2.5 #5 guess
                , div(style = "display:inline-block"
                      , textInput(
                          ## 1.4 input text box ####
                          inputId = "outputGuess5"
                          , label = "#5 Guess"
                          )
                      , width = 2)
                , div(style = "display:inline-block"
                      , actionButton(inputId = "button5"
                                     , label = ""
                                     , icon = icon(name = "ok", lib = "glyphicon"))
                )
                )
            
            , column(
                width = 4
                , plotOutput("wordcloud")
                )
            )
        )
    )
