library(httr)
library(jsonlite)
library(tidyverse)

#Utilizaremos uma API para obter o clima de Brasília agora

key <- "338cd4eb8b0a910c8b71a4b53af0544b"

#Usando API para obter a latitude e longitude de Brasília

loc <- httr::GET("https://api.openweathermap.org/geo/1.0/direct?q=Brasília&appid=338cd4eb8b0a910c8b71a4b53af0544b")
loc$status_code

loc_texto <- httr::content(loc, as = "text")

loc_JSON <- jsonlite::fromJSON(loc_texto)

latitude <- loc_JSON$lat
longitude <- loc_JSON$lon

#Esta API retorna as unidades de temperatura em kelvins por default. Para obter o resultado em Celsius, utilizaremos o parâmetro "units=metric"
link <- str_c("https://api.openweathermap.org/data/2.5/weather?lat=", latitude, "&lon=", longitude, "&appid=338cd4eb8b0a910c8b71a4b53af0544b&units=metric")

dados <- httr::GET(link)
dados$status_code

dados$content

conteudo_dados <- httr::content(dados, as = "text")

conteudo_JSON <- jsonlite::fromJSON(conteudo_dados)

View(conteudo_JSON$main)
