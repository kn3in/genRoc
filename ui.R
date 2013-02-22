library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("GENROC"),
  sidebarPanel(
      sliderInput("k", "Disease Prevalence:", 
                      min=0, max=1, value=0.05),
      
      numericInput("lambda_s", "Sibling recurrence (risk):", 2, min=1),
      
      checkboxInput("use_her", "OR use Heritability of liability instead of risk[NOT IMPLEMENTED YET]"),
      sliderInput("h_2_l", "Heritability of liability:", 
                      min=0,   max=1, value=0.5),
                      h5("Optional"),
      sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)
  ),

  mainPanel(h4("Input"),
            tableOutput("values"),
            h4("Results"),
            tableOutput("results"))
))
