library(shiny)
library(ggplot2)
library(knitr)
source("functions.R", local=TRUE)

dis_table <- read.csv("Table.csv")
dis_table$auc_m <- apply(dis_table[ ,-1], 1, function(x) final_results(x[1]/100, x[2], NA, NA)[1,2])




shinyServer(function(input, output) {
  
  inputValues <- reactive(
    data.frame(       K = input$k,
               lambda_s = ifelse(input$my_method == "risk", input$lambda_s, NA),
                  h_2_l = ifelse(input$my_method == "heritability", input$h_2_l, NA),
                est_auc = ifelse(input$provide_auc, input$est_auc, NA))
  )
  
    
  output$limit_lambda <- renderUI({
    xmin <- 1
    xmax <- 1 / (2 * input$k)
    middle <- (xmax + xmin) / 2
    sliderInput("lambda_s", "Sibling recurrence:", value=middle, min=xmin, max=xmax)
  })
  
  resultsValues <- reactive({
    final_results(inputValues()$K, inputValues()$lambda_s, inputValues()$h_2_l, inputValues()$est_auc)
  })
  
  resultsRoc <- reactive({
    dt <- data.frame(hl_grid = seq(0.01, 1, by=0.01))
    dt$auc_m <- sapply(dt$hl_grid, function(x) final_results(inputValues()$K, NA, x, NA)[1,2])
    print(qplot(x=hl_grid, y=auc_m, data=dt, geom="line") + theme_bw() + xlab(expression(h[L]^2)) + ylab(expression(AUC[max])) + ylim(c(0.5, 1)) + xlim(c(0, 1)))
  })
  
  resultTab <- reactive({
    my_dt <- as.data.frame(rbind(dis_table, c("Your input", 100 * inputValues()$K, inputValues()$lambda_s, resultsValues()[1,2])))
    my_dt$auc_m <- round(as.numeric(my_dt$auc_m), 2)
    my_dt
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
  
  output$tab <- renderTable(
    resultTab()
  )
  
})