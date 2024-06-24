# ui.R

library(shiny)

fluidPage(
  titlePanel("Consulta de Dados Meteorológicos"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("city_input", "Digite o nome da cidade:", "Brasilia"),
      actionButton("submit_btn", "Obter Dados")
    ),
    
    mainPanel(
      textOutput("weather_output")
    )
  )
)
