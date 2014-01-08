library(shiny)
library(ggplot2)
library(knitr)
library(xtable)
source("functions.R", local=TRUE)
options(stringsAsFactors = FALSE)

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
  
   
  your_input <- reactive({
    mydf <- as.data.frame(cbind(t(inputValues()), c("Disease Prevalence", "Sibling recurrence (risk)", "Heritability of liability", "AUC estimated by user from genetic risk score predicting case-control status")))
    mydf$V1 <- as.numeric(mydf$V1)
    mydf
    })

  output$values <- renderTable(
    your_input(), digits = 2, include.rownames = FALSE, include.colnames = FALSE
  )
  
  output$results <- renderText(
    paste(print(xtable(annotateResults(resultsValues())), include.rownames = FALSE, include.colnames = FALSE, type = "html", html.table.attributes = c("class=table-condensed"), print.results = FALSE),
    tags$script("MathJax.Hub.Queue([\"Typeset\",MathJax.Hub]);"))
  )
  
  output$roc <- renderPlot(
    resultsRoc()
  )

})