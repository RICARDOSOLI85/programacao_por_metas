# Arquivo de leitura dos dados de covid 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using CSV
using DataFrames


function dividir_categorias(df_treino::DataFrame)
    # Divisão dos dados de treino 
    # utlizando a função anonima e a função filter 

    ca_treino = filter(:COVID => n -> n == 1.0, df_treino)
    cb_treino = filter(:COVID => n -> n == 0.0, df_treino)


    
    #=
    #ca_treino = df_treino[df_treino[:, :COVID] .== 1, :]
    #cb_treino = df_treino[df_treino[:, :COVID] .== 0, :]
    ca_treino = filter(row -> row[:COVID] > 0, df_treino) # Filtra linhas onde COVID > 0
    cb_treino = filter(row -> row[:COVID] < 1, df_treino) # Filtra linhas onde COVID < 1 
    
    # Remover a coluna COVID de ambos data frames e a coluna inicial 
    #ca = ca_treino[:,2:14]
    #b = cb_treino[:,2:14]
    #C  = c_treino[:,2:14] =#
    ca = ca_treino 
    cb = cb_treino 
    C = df_treino
    return C, ca, cb
    

end