library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("genRoc"),
  sidebarPanel(
      sliderInput("k", "Disease Prevalence:", 
                      min=0, max=1, value=0.05),
      
      
      radioButtons("my_method", "Choose:",
                       list("Sibling recurrence (risk)" = "risk",
                            "Heritability of liability" = "heritability")),
      
      conditionalPanel(
        condition = 'input.my_method == "heritability"',
        sliderInput("h_2_l", "Heritability of liability:", 
                      min=0,   max=1, value=0.5)),
      
      conditionalPanel(
        condition = 'input.my_method == "risk"',
        numericInput("lambda_s", "Sibling recurrence:", 2, min=1)),
      
      h6("Optional:"),
      checkboxInput("provide_auc", "Provide estimated AUC"),
      conditionalPanel(
        condition = "input.provide_auc == true",
        sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75))),

  mainPanel(h4("Input"),
            tableOutput("values"),
            h4("Results"),
            tableOutput("results"))
))
