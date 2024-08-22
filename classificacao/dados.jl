# Arquivo de leitura dos dados de covid 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using CSV
using DataFrames
using MLDataPattern

# Função para leitura do arquivo 
function ler_csv(arquivo::String)::DataFrame
    # Lê o arquivo CSV e retorna um DataFrame
    df = CSV.read(arquivo, DataFrame)
    return exames 
end