##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(shiny)
require(shinythemes)
## 0.2 set up the working directory ##########
# setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

##############################################
## 1. UI #####################################
##############################################
shinyUI(
    fluidPage(
        ## 1.1 bootstrap theme ###############
        theme = "button.css"
        
        , fluidRow(
            ## 1.2 navigation bar ############
            navbarPage(
                title = "SwiftKey - Word Prediction"
                , theme = shinytheme("cerulean")
            )
        )
        
        ## 1.3 a line ########################
        , hr()
        
        , fluidRow(
            column(
                width = 4
                , offset = 4
                , textInput(
                    ## 1.4 input text box ####
                    inputId = "input"
                    , label = ""
                    , value = "")
                , tags$head(tags$style(type="text/css", "#input {width: 150%}"))
            )
        )
        
        , fluidRow(
            ## 1.4 the output ################
            column(
                ## 1.4.1 rank graph ######
                width = 4
                , conditionalPanel(
                    condition = "input.input.trim() != ''"
                    , plotOutput("rankgraph")
                )
            )
            
            , column(
                ## 1.4.2 predictions and button
                width = 4
                ## 1.4.2.1 #1 guess
                , conditionalPanel(
                    condition = "input.input.trim() != ''"
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
                                         , icon = icon(name = "check", lib = "font-awesome", class = "fa-lg button"))
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
                                         , icon = icon(name = "check", lib = "font-awesome", class = "fa-lg button"))
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
                                         , icon = icon(name = "check", lib = "font-awesome", class = "fa-lg button"))
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
                                         , icon = icon(name = "check", lib = "font-awesome", class = "fa-lg button"))
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
                                         , icon = icon(name = "check", lib = "font-awesome", class = "fa-lg button"))
                          )
                )
                
            )
            
            , column(
                width = 4
                , conditionalPanel(
                    condition = "input.input.trim() != ''"
                    , plotOutput("wordcloud")
                )
            )
            
        )
        , absolutePanel(
            bottom = "0%"
            , width = "100%"
            , hr()
            , a(class="fa fa-github fa-2x button", style="text-decoration:none;", href = "https://github.com/noahhhhhh/natural_language_processing_word_prediction", target = "_blank")
            , a(class="fa fa-linkedin fa-2x button", style="text-decoration:none;", href = "https://au.linkedin.com/in/mengnoahxiao", target = "_blank")
            , a(class="fa fa-envelope fa-2x button", style="text-decoration:none;", href = "mailto:noah.xm.shaw@gmail.com", target = "_blank")
            , div(helpText("Noah Xiao - BI/Analytics Consultant. Aug. 2015"), style="display: inline-block; text-align: right;")
            , hr()
        )
    )
)
