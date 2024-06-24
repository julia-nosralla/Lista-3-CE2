# Carregar pacotes necessários
library(shiny)
library(httr)
library(jsonlite)
library(ggplot2)
library(dplyr)


# Função para obter ranking de nomes do IBGE
obter_ranking_nomes <- function(nome) {
  endereco_base <- "https://servicodados.ibge.gov.br/api/v2/censos/nomes"
  
  # Montar a URL da API com o nome fornecido
  api_ibge <- paste0(endereco_base, "/", URLencode(nome))
  
  # Fazer requisição à API
  dados_nomes <- httr::GET(api_ibge)
  
  # Verificar o status da resposta
  if (status_code(dados_nomes) == 200) {
    ranking <- httr::content(dados_nomes, as = "text")
    banco_nomes <- jsonlite::fromJSON(ranking)
    return(banco_nomes)
  } else {
    stop(paste("Erro ao obter ranking de nomes:", status_code(dados_nomes), "-", content(dados_nomes, "text")))
  }
}

# Definir a função do servidor Shiny
shinyServer(function(input, output, session) {
  
  # Evento para obter ranking de nomes quando o botão for clicado
  observeEvent(input$submit_btn, {
    nome <- input$nome_input
    
    # Obter ranking de nomes usando o nome inserido
    banco_nomes <- obter_ranking_nomes(nome)
    
    # Exibir o resultado na interface do usuário
    output$ranking_output <- renderPrint({
      if (!is.null(banco_nomes)) {
        banco_nomes$rest
        str(banco_nomes$nome)
        str(banco_nomes$localidade)
        banco_nomes <- jsonlite::fromJSON(dados)
        
        period_freq <- banco_nomes$res[[1]]
        
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
        str(datas)
        
        # Plotar o gráfico
        # Renderizar o gráfico no output
        output$ranking_plot <- renderPlot({
        ggplot(period_freq, aes(x = periodo, y = frequencia)) +
          geom_bar(stat = "identity", fill = "steelblue") +
          theme_minimal() +
          labs(title = paste("Frequência do Nome", nome, "ao Longo dos Períodos"),
               x = "Período",
               y = "Frequência") +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        })
      } else {
        "Nome não encontrado no ranking."
      }
    })
  })
})
