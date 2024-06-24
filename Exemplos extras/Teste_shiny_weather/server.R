# server.R

# Carregar os pacotes necessários
library(httr)
library(jsonlite)
library(shiny)

# Definir funções para obter coordenadas e dados meteorológicos
obter_coordenadas <- function(cidade, pais) {
  acess_token_openweather <- "eb1463228c50bfa03dc1d03c23db7e5e"
  url_base <- "http://api.openweathermap.org"
  
  # Montar a URL da API de geocodificação
  api_geocodin <- paste0(url_base, "/geo/1.0/direct?q=", cidade, ",", pais, "&limit=1&appid=", acess_token_openweather)
  
  # Fazer requisição à API de geocodificação
  req_geocodin <- httr::GET(api_geocodin)
  
  # Verificar o status da resposta
  if (status_code(req_geocodin) == 200) {
    geocodin_json <- content(req_geocodin, "parsed")
    return(geocodin_json)
  } else {
    stop("Erro ao obter dados de geocodificação: ", status_code(req_geocodin))
  }
}

obter_dados_meteorologicos <- function(latitude, longitude) {
  acess_token_openweather <- "YOUR KEY HERE"
  url_base <- "http://api.openweathermap.org"
  
  # Montar a URL da API de dados meteorológicos atuais
  api_weather <- paste0(url_base, "/data/2.5/weather?lat=", latitude, "&lon=", longitude, "&appid=", acess_token_openweather)
  
  # Fazer requisição à API de dados meteorológicos atuais
  req_weather <- httr::GET(api_weather)
  
  # Verificar o status da resposta
  if (status_code(req_weather) == 200) {
    weather_data <- content(req_weather, "parsed")
    return(weather_data)
  } else {
    stop("Erro ao obter dados meteorológicos: ", status_code(req_weather))
  }
}

# Definir a função do servidor Shiny
shinyServer(function(input, output, session) {
  
  # Evento para obter dados do clima quando o botão for clicado
  observeEvent(input$submit_btn, {
    cidade <- input$city_input
    pais <- "BR"  # Exemplo: Brasil, pode ser dinâmico conforme sua necessidade
    
    # Obter coordenadas da cidade
    coordenadas <- obter_coordenadas(cidade, pais)
    latitude <- coordenadas$lat
    longitude <- coordenadas$lon
    
    # Obter dados meteorológicos atuais
    dados_clima <- obter_dados_meteorologicos(latitude, longitude)
    
    # Exibir os dados do clima na interface do usuário
    output$weather_output <- renderText({
      if (!is.null(dados_clima)) {
        paste("Clima em", cidade, ":",
              "\nTemperatura:", dados_clima$main$temp - 273.15, "°C",
              "\nCondição:", dados_clima$weather[[1]]$description,
              "\nUmidade:", dados_clima$main$humidity, "%")
      } else {
        "Não foi possível obter os dados do clima."
      }
    })
  })
  
})
