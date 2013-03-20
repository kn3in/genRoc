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
  
  resultsValues <- reactive({
    final_results(inputValues()$K, inputValues()$lambda_s, inputValues()$h_2_l, inputValues()$est_auc)
  })
  
  resultsRoc <- reactive({
    print(plotROC(inputValues()$K))
    })
  
  resultTab <- reactive({
    my_dt <- as.data.frame(rbind(dis_table, c("Your input", 100 * inputValues()$K, inputValues()$lambda_s, resultsValues()[1,2])))
    my_dt$auc_m <- round(as.numeric(my_dt$auc_m), 2)
    my_dt
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
  
  output$tab <- renderTable(
    resultTab()
  )
  
})