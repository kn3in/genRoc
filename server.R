library(shiny)
library(ggplot2)
library(knitr)
source("functions.R", local=TRUE)

shinyServer(function(input, output) {
  
  inputValues <- reactive(
    data.frame(       K = input$k,
               lambda_s = ifelse(input$my_method == "risk", input$lambda_s, NA),
                  h_2_l = ifelse(input$my_method == "heritability", input$h_2_l, NA),
                est_auc = ifelse(input$provide_auc, input$est_auc, NA))
  )
  
  resultsValues <- reactive({
    final_results(inputValues()$K, inputValues()$lambda_s, inputValues()$h_2_l, inputValues()$est_auc)
  })
  
  resultsRoc <- reactive({
    print(plotROC(inputValues()$K, resultsValues()[9,2], resultsValues()[1,2]))
  })

#--------------------------------------------------------
# Render output
#--------------------------------------------------------
  
  output$limit_lambda <- renderUI({
    xmin <- 1.01
    xmax <- lambda_sup(input$k)
    middle <- (xmax + xmin) / 2
    sliderInput("lambda_s", "Sibling recurrence:", value=middle, min=xmin, max=xmax)
  })
  
  output$values <- renderTable(
    inputValues()
  )
  
  output$results <- renderTable(
    resultsValues()
  )
  
  output$roc <- renderPlot(
    resultsRoc()
  )

})