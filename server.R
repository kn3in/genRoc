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
  
  resultsRoc <- reactive({
    dt <- data.frame(hl_grid = seq(0.01, 1, by=0.01))
    dt$auc_m <- sapply(dt$hl_grid, function(x) final_results(inputValues()$K, NA, x, NA)[1,2])
    print(qplot(x=hl_grid, y=auc_m, data=dt, geom="line") + theme_bw() + xlab(expression(h[L]^2)) + ylab(expression(AUC[max])) + ylim(c(0.5, 1)) + xlim(c(0, 1)))
  })
  
  
  output$values <- renderTable({
    inputValues()
  })
  
  output$results <- renderTable({
    resultsValues()
  })
  
  output$roc <- renderPlot({
    resultsRoc()
  })
})