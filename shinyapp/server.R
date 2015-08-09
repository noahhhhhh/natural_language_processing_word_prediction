##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
library(shiny)
require(RColorBrewer)
## 0.2 set up the working directory ##########
setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

##############################################
## 1. Server #################################
##############################################
function(input, output, session) {
    terms <- reactive({
        # change when
        withProgress({
            setProgress(message = "predicting ...")
            tbPred <- PredGram(input$input)
#             # Update select input
#             updateSelectizeInput(session = session
#                               , inputId = "selectize"
#                               , choices = paste(input$input, as.matrix(tbPred[, 1]))
#             )
#             # Update radio button
#             updateRadioButtons(session = session
#                                , inputId = "radio"
#                                , choices = paste(input$input, as.matrix(tbPred[, 1]))
#             )
            
            
            tbPred
        })
            
    })
#     # Update text input
#     input$button
#     isolate({
#         updateTextInput(session = session
#                         , inputId = "input"
#                         , value = input$radio
#         )
#     })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$rankgraph <- renderPlot({
        RankingChart(tb = terms())
    })
    
    
    
    output$wordcloud <- renderPlot({
        v <- terms()
        pal <- brewer.pal(8, "Dark2")
        wordcloud_rep(words = v[, 1]
                      , freq = v[, 2]
                      , scale = c(4, .5)
                      , random.order = T
                      , rot.per = .15
                      , colors = pal)
        
        withProgress(
            message = "rendering wordcloud ..."
            , value = .1
            ,  {
                for (i in 1:10) {
                    # Each time through the loop, add another row of data. This a stand-in
                    # for a long-running computation.
                    
                    # Increment the progress bar, and update the detail text.
                    incProgress(amount = .5, detail = paste(i, "in 10 ... Done"))
                    
                    # Pause for 0.1 seconds to simulate a long computation.
                    Sys.sleep(.1)
                }
            }
            
        )
    })
}