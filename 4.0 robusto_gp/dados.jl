# Arquivo para leitura de dados 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 

using CSV
using DataFrames

function ler_arquivo(arquivo::String)
    df = CSV.read(arquivo, DataFrame)
    return df     
end