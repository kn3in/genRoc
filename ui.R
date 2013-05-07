library(shiny)
library(knitr)
source("custom_html.R")

shinyUI(pageWithSidebar(customHeaderPanel("genRoc"),
  sidebarPanel(
      wellPanel(numericInput("k", "Disease Prevalence:", 
                      min=0, max=0.5, value=0.05),
                HTML(knit2html(text = "Disease prevalence in population. The proportion of a birth cohort that will get disease in their lifetime."))),
      
      
      wellPanel(radioButtons("my_method", "Choose one:",
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
        HTML(knit2html(text = "Increased risk of disease in siblings of affected relatives. We assume that this increased risk reflects only shared genetic risk. Max risk constrained to have $h^2_L \\leq 1$. (as per equation 1 in the original publication.)")))),
      
      wellPanel(
      h4("Optional:"),
      checkboxInput("provide_auc", "Provide estimated AUC"),
      conditionalPanel(
        condition = "input.provide_auc == true",
        sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)),
      HTML(knit2html(text="AUC estimated by user from genetic risk score predicting case-control status. If not provided $h^2_{L_{[x]}}$, $\\rho_{\\hat{G}G}$, $\\lambda_{s_{[x]}}$ and $\\frac{ \\lambda_{s_{[x]}} - 1 }{ \\lambda_{s} - 1 }$ are not calculated.")))),

  mainPanel(
    tabsetPanel(
      tabPanel("Main",
            h4("Input"),
            wellPanel(tableOutput("values")),
            h4("Results"),
            wellPanel(htmlOutput("results"))),
      tabPanel("ROC curves", 
            wellPanel(plotOutput("roc", width="50%"))),
      tabPanel("Citation",
      wellPanel(h4("genRoc:"),
      p("Wray NR, Yang J, Goddard ME, Visscher PM (2010)", a(href="http://www.plosgenetics.org/article/info%3Adoi%2F10.1371%2Fjournal.pgen.1000864", "The Genetic Interpretation of Area under the ROC Curve in Genomic Profiling."), "PLoS Genet 6(2): e1000864."),
      p("Written by Konstantin Shakhbazov", a(href="https://github.com/kn3in/genRoc", "Source code at GitHub"))))))
))



