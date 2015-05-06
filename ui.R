library(shiny)
library(knitr)
library(markdown)
source("custom_html.R")

shinyUI(pageWithSidebar(customHeaderPanel("genRoc"),
  sidebarPanel(
      h3("Input"),
      wellPanel(

        
        numericInput("k", "Disease Prevalence:", 
                      min=0, max=0.5, value=0.05),
                helpText("Disease prevalence in population. The proportion of a birth cohort that will get disease in their lifetime.")),
      
      
      wellPanel(radioButtons("my_method", h4("Choose one"),
                       list("Sibling recurrence (risk)" = "risk",
                            "Heritability of liability" = "heritability")),
      
      conditionalPanel(
        condition = 'input.my_method == "heritability"',
        sliderInput("h_2_l", "Heritability of liability:", 
                      min=0,   max=1, value=0.5),
        helpText("Heritability of liability. The proportion of variation in phenotypic liability attributed to additive genetic effects.")),
      
      conditionalPanel(
        condition = 'input.my_method == "risk"',
        uiOutput("limit_lambda"),
        helpText("Increased risk of disease in siblings of affected relatives. We assume that this increased risk reflects only shared genetic risk. Max risk constrained to have \\(h^2_L \\leq 1\\). (as per equation 1 in the original publication.)"))),
      
      wellPanel(
      h4("Optional"),
      checkboxInput("provide_auc", "Provide estimated AUC"),
      conditionalPanel(
        condition = "input.provide_auc == true",
        sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)),
      helpText("AUC estimated by user from genetic risk score predicting case-control status. If not provided \\(h^2_{L_{[x]}}\\), \\(\\rho_{\\hat{G}G}\\), \\(\\lambda_{s_{[x]}}\\) and \\(\\frac{ \\lambda_{s_{[x]}} - 1 }{ \\lambda_{s} - 1 }\\) are not calculated."))),

  mainPanel(
    tabsetPanel(
      tabPanel("Main",
            h3("Your Input"),
            wellPanel(tableOutput("values")),
            h3("Result"),
            wellPanel(htmlOutput("results"))),
      tabPanel("ROC", 
            wellPanel(plotOutput("roc", width="50%"))),
      tabPanel("Citation",
      wellPanel(
      p("Wray NR, Yang J, Goddard ME, Visscher PM", a(href="http://www.plosgenetics.org/article/info%3Adoi%2F10.1371%2Fjournal.pgen.1000864", "The Genetic Interpretation of Area under the ROC Curve in Genomic Profiling."), "PLoS Genet 2010")),
      wellPanel(
          HTML('<a href="https://github.com/kn3in/genRoc"><img src="img/GitHub-Mark-120px-plus.png" width=50 /> </a>'))
)))))



