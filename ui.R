library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("GENROC"),
  sidebarPanel(
      sliderInput("k", "Disease Prevalence:", 
                      min=0, max=1, value=0.5),
      numericInput("lambda_s", "Sibling recurrence of risk:", .1),
      sliderInput("h_sqrt", "Heritability of liability:", 
                      min=0,   max=1, value=0.5),
      sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)
  ),

  mainPanel(verbatimTextOutput("summary"))
))
