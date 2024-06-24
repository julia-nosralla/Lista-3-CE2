#-------------PREPARANDO AMBIENTE---------------------
#instale pacotes/bibliotecas basicas para a api
if (!require("pacman")) install.packages("pacman")
pacman::p_load("tidyverse", "httr", "jsonlite")

#----------------------------------------------------
#           API: GEOCODIFICAÇÃO

acess_token_openweather <-"eb1463228c50bfa03dc1d03c23db7e5e"
url_base <- "http://api.openweathermap.org"

city <- "Brasilia"
country <- "BR"

api_geocodin <- paste0(url_base, "/geo/1.0/direct?q=", city,",", country, "&limit=1&appid=", acess_token_openweather)

# Fazendo requisição a API
req_geocodin <- httr::GET(api_geocodin)

# Verificar o status da resposta
if (status_code(req_geocodin) == 200) {
  # Ver o conteúdo da resposta
  content <- content(req_geocodin, "parsed", simplifyVector = TRUE)
  print(content)
}else{
  message("Erro na requisição: ", status_code(req_geocodin))
  }

# TRATAMENTO DOS DADOS RECEBIDOS
dados_geocodin <- httr::content(req_geocodin, as = "text")
str(dados_geocodin)

#convertendo string json para um dataframe 
geocodin_json <- jsonlite::fromJSON(dados_geocodin)
View(geocodin_json$local_names)

#----------------------------------------------------
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#           API: DADOS METEOROLOGICOS ATUAIS
#Dados requisitados: url_base, acess_token_openweather

latitude <- geocodin_json$lat
longitude <- geocodin_json$lon

api_weather <- paste0(url_base, "/data/2.5/weather?lat=", latitude, "&lon=", longitude,"&appid=", acess_token_openweather)

# Fazendo requisição a API
req_weather <- httr::GET(api_weather)

# Verificar o status da resposta
if (status_code(req_weather) == 200) {
  # Ver o conteúdo da resposta
  content <- content(req_weather, "parsed", simplifyVector = TRUE)
  print(content)
}else{
  message("Erro na requisição: ", status_code(req_weather))
}

# TRATAMENTO DOS DADOS RECEBIDOS
dados_weather <- httr::content(req_weather, as = "text")
str(dados_weather)

#convertendo string json para um dataframe 
weather_json <- jsonlite::fromJSON(dados_weather)

#----------------------------------------------------