library(shiny)
source("functions.R", local=TRUE)

shinyServer(function(input, output) {
  sliderValues <- reactive(function() {
   data.frame(Name  = c("K", "Lambda_s", "H^2", "AUC_est"),
              Value = as.character(c(input$k, input$lambda_s, input$h_2_l, input$est_auc)))
  })
 
  resultsValues <- reactive(function() {
    final_results(input$k, input$lambda_s, input$h_2_l, input$est_auc)
  })
  
  output$values <- reactiveTable(function() {
    sliderValues()
  })
  
  output$results <- reactiveTable(function() {
    resultsValues()
  })
})