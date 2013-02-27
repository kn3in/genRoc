library(shiny)
source("functions.R", local=TRUE)

shinyServer(function(input, output) {
  
  inputValues <- reactive({
    data.frame(       K = input$k,
               lambda_s = ifelse(input$my_method == "risk", input$lambda_s, NA),
                  h_2_l = ifelse(input$my_method == "heritability", input$h_2_l, NA),
                est_auc = ifelse(input$provide_auc, input$est_auc, NA))
  })
  
  resultsValues <- reactive({
    results <- final_results(inputValues()$K, inputValues()$lambda_s, inputValues()$h_2_l, inputValues()$est_auc)
    results$Value <- as.character(round(results$Value, 2))
    results
  })
  
  output$values <- renderTable({
    inputValues()
  })
  
  output$results <- renderTable({
    resultsValues()
  })
})