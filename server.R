library(shiny)

shinyServer(function(input, output) {

  output$summary <- reactivePrint(function() {
    cat(  "K:",        input$k, "\n",
          "Lambda_s:", input$lambda_s, "\n",
          "H_sqrt:",   input$h_sqrt, "\n",
          "AUC_est:",  input$est_auc)
  })
})