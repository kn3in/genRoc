library(shiny)
library(knitr)

shinyUI(pageWithSidebar(headerPanel("genRoc"),
  sidebarPanel(
      wellPanel(numericInput("k", "Disease Prevalence:", 
                      min=0, max=0.5, value=0.05),
                helpText("Disease prevalence in population. The proportion of a birth cohort that will get disease in their lifetime.")),
      
      
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
        helpText("Increased risk of disease in siblings of affected relatives. We assume that this increased risk reflects only shared genetic risk."))),
      
      wellPanel(
      h4("Optional:"),
      checkboxInput("provide_auc", "Provide estimated AUC"),
      conditionalPanel(
        condition = "input.provide_auc == true",
        sliderInput("est_auc", "Estimated AUC:", 
                      min=0.5, max=1, value=0.75)),
      helpText("AUC estimated by user from genetic risk score predicting case-control status. If not provided H^2_lx, Rho_gg, Lambda_sx and Prop_risk_exp are not calculated."),
      HTML(knit2html(text="$$h^2_{L_{[x]}}$$")))),

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



# $$AUC_{max}$$ $$h^2_{L_{[x]}}$$ $$\\rho_{\\hat{G}G}$$