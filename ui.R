library(shiny)

shinyUI(pageWithSidebar(headerPanel("genRoc"),
  sidebarPanel(
      wellPanel(sliderInput("k", "Disease Prevalence:", 
                      min=0, max=1, value=0.05)),
      
      
      wellPanel(radioButtons("my_method", "Choose one:",
                       list("Sibling recurrence (risk)" = "risk",
                            "Heritability of liability" = "heritability")),
      
      conditionalPanel(
        condition = 'input.my_method == "heritability"',
        sliderInput("h_2_l", "Heritability of liability:", 
                      min=0,   max=1, value=0.5)),
      
      conditionalPanel(
        condition = 'input.my_method == "risk"',
        numericInput("lambda_s", "Sibling recurrence:", 2, min=1))),
      
      wellPanel(
      h6("Optional:"),
      checkboxInput("provide_auc", "Provide estimated AUC"),
      conditionalPanel(
        condition = "input.provide_auc == true",
        sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)))),

  mainPanel(
    tabsetPanel(
      tabPanel("Main",
            h4("Input"),
            wellPanel(tableOutput("values")),
            h4("Results"),
            wellPanel(tableOutput("results"))),
      tabPanel("ROC curves", 
            wellPanel(plotOutput("roc", width="50%"))),
      tabPanel("AUC related statistics for complex genetic diseases",
            wellPanel(tableOutput("tab"))),
      tabPanel("About",
      wellPanel(h4("genRoc:"),
      p("Wray NR, Yang J, Goddard ME, Visscher PM (2010)", a(href="http://www.plosgenetics.org/article/info%3Adoi%2F10.1371%2Fjournal.pgen.1000864", "The Genetic Interpretation of Area under the ROC Curve in Genomic Profiling."), "PLoS Genet 6(2): e1000864."),
      p("Written by Konstantin Shakhbazov", a(href="https://github.com/kn3in/genRoc", "Source code at GitHub"))))))
))
