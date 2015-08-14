##############################################
## 0. Set up #################################
##############################################

## 0.1 load the required libraries and clean #
## up the memory #############################
require(shiny)
## 0.2 set up the working directory ##########
# setwd("/Volumes/Data Science/Google Drive/learning_data_science/Coursera/capstone/")

##############################################
## 1. Server #################################
##############################################
function(input, output, session) {
    terms <- reactive({
        if (gsub("\\s", "", input$input) != ""){
            withProgress({
                setProgress(message = "initializing ...")
                tbPred <- PredGram(input$input)
                
                tbPred
            })
        }
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$rankgraph <- renderPlot({
        if (gsub("\\s", "", input$input) != ""){
            RankingChart(tb = terms())
        }
    })
    
    output$wordcloud <- renderPlot({
        if (gsub("\\s", "", input$input) != ""){
            v <- terms()
            pal <- brewer.pal(8, "Dark2")
            wordcloud_rep(words = v[, 1]
                          , freq = v[, 2]
                          , scale = c(7.5, 1)
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
        }
    })
    
    observe({
        if (gsub("\\s", "", input$input) != ""){
            v <- terms()
            updateTextInput(session = session
                            , inputId = "outputGuess1"
                            , value = v[, 1][1]
            )
            updateTextInput(session = session
                            , inputId = "outputGuess2"
                            , value = v[, 1][2]
            )
            updateTextInput(session = session
                            , inputId = "outputGuess3"
                            , value = v[, 1][3]
            )
            updateTextInput(session = session
                            , inputId = "outputGuess4"
                            , value = v[, 1][4]
            )
            updateTextInput(session = session
                            , inputId = "outputGuess5"
                            , value = v[, 1][5]
            )
        }
    })
    
    observe({
        input$button1
        isolate({
            updateTextInput(session = session
                            , inputId = "input"
                            , value = gsub("\\s+", " ", paste(input$input, input$outputGuess1))
            )
        })
    })
    
    observe({
        input$button2
        isolate({
            updateTextInput(session = session
                            , inputId = "input"
                            , value = gsub("\\s+", " ", paste(input$input, input$outputGuess2))
            )
        })
    })
    
    observe({
        input$button3
        isolate({
            updateTextInput(session = session
                            , inputId = "input"
                            , value = gsub("\\s+", " ", paste(input$input, input$outputGuess3))
            )
        })
    })
    
    observe({
        input$button4
        isolate({
            updateTextInput(session = session
                            , inputId = "input"
                            , value = gsub("\\s+", " ", paste(input$input, input$outputGuess4))
            )
        })
    })
    
    observe({
        input$button5
        isolate({
            updateTextInput(session = session
                            , inputId = "input"
                            , value = gsub("\\s+", " ", paste(input$input, input$outputGuess5))
            )
        })
    })
}
