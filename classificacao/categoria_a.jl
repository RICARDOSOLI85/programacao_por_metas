function dividir_categorias(df_treino::DataFrame)
    # Divisão dos dados de treino 
    c_treino = df_treino 
    ca_treino = df_treino[df_treino[:, :COVID] .> 0, :]
    cb_treino = df_treino[df_treino[:, :COVID] .< 1, :]

    #CA = filtrer(row -> row[:COVID] == 1, df_treino) # Filtra linhas onde COVID > 0
    #CB = filtrer(row -> row[:COVID] == 0, df_treino) # Filtra linhas onde COVID < 1 
    
    # Remover a coluna COVID de ambos data frames e a coluna inicial 
    ca = ca_treino[:,2:14]
    cb = cb_treino[:,2:14]
    C  = c_treino[:,2:14] 
    return C, ca, cb

end