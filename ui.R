library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("GENROC"),
  sidebarPanel(
      sliderInput("k", "Disease Prevalence:", 
                      min=0, max=1, value=0.5),
      numericInput("lambda_s", "Sibling recurrence (risk):", 2, min=1),
      sliderInput("h_2_l", "Heritability of liability:", 
                      min=0,   max=1, value=0.5),
      sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)
  ),

  mainPanel(tableOutput("values"),
            tableOutput("results"))
))
