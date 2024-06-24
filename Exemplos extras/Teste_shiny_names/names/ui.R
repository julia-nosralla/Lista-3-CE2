# ui.R

library(shiny)

fluidPage(
  titlePanel("Ranking de Nomes no Brasil"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("nome_input", "Digite o nome:", ""),
      actionButton("submit_btn", "Buscar Ranking")
    ),
    
    mainPanel(
      verbatimTextOutput("ranking_output")
    )
  )
)
