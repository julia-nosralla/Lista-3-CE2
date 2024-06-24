#-------------PREPARANDO AMBIENTE---------------------

#instale pacotes/bibliotecas basicas para a api
if (!require("pacman")) install.packages("pacman")
pacman::p_load("tidyverse", "httr", "jsonlite", "stringr")

#----------------------------------------------------
#           API: IBGE

endereco_base <-"https://servicodados.ibge.gov.br/api"

nome <- "ana"
api_ibge <- paste0(endereco_base, "/v2/censos/nomes/", nome)

#Metodo GET
dados_nomes <- httr::GET(api_ibge)

dados <- httr::content(dados_nomes, as = "text")
str(dados)

banco_nomes1 <- jsonlite::fromJSON(dados)
banco_nomes1$nome
banco_nomes1$localidade
period_freq <- banco_nomes1$res[[1]]

#arrumar as datas
datas <- period_freq$periodo

# Função para arrumar as datas
arrumar_datas <- function(data) {
  # Remover colchetes iniciais e finais
  data <- gsub("\\[", "", data)
  data <- gsub("\\]", "", data)
  # Substituir a vírgula por um hífen
  data <- gsub(",", "-", data)
  return(data)
}

# Aplicar a função em todas as datas
datas <- sapply(datas, arrumar_datas)

# Aplicar a função em todas as datas
datas_arrumadas <- sapply(datas, arrumar_datas)

#plotando grafico simples
ggplot(period_freq, aes(x = periodo, y = frequencia)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = paste("Frequência do Nome", nome, "ao Longo dos Períodos"),
       x = "Período",
       y = "Frequência") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

