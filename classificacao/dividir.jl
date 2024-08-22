# Arquivo de leitura dos dados de covid 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using DataFrames
using Random

function dividir_dados(df::DataFrame, proporcao_treino::Float64)
    # Definir o tamanho do conjunto de treino 
    (m,n) = size(df)
    m_treino = Int(round(proporcao_treino * m))
    println(m_treino)

    # Embaralhar os dados 
    df_shuffled = exames[shuffle(1:m),:]
    println(df_shuffled)

    # Dividir os dados 
    df_treino = df_shuffled[1:m_treino, :]
    df_teste  = df_shuffled[m_treino+1:end,:]

   
    return df_treino, df_teste
    
end
