customHeaderPanel <- function(title, windowTitle = title) {
    tagList(
       tags$head(
          tags$title(windowTitle),
          tags$script(src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML")
       ),
       div(class = "span12", style = "padding: 10px 0px;", h1(title))
    )
}