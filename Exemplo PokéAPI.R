library(jsonlite)
library(httr)

base <- "https://pokeapi.co/api/v2/pokemon/eevee"

pokemon <- httr::GET(base)

pokemon$status_code

#converter o conteúdo para texto no formato json

pokemontexto <- httr::content(pokemon, as = "text")

#converte o texto no formato JSON em um objeto do R

pokemonJSON <- jsonlite::fromJSON(pokemontexto)

View(pokemonJSON)
View(pokemonJSON$abilities)
View(pokemonJSON$stats)
View(pokemonJSON$game_indices)


