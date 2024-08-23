# Arquivo de para filtrar 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using CSV
using DataFrames


function dividir_categorias(df_treino::DataFrame)
    # Divisão dos dados de treino 
    # utlizando a função anonima e a função filter 

    ca_treino = filter(:COVID => n -> n == 1.0, df_treino);
    cb_treino = filter(:COVID => n -> n == 0.0, df_treino);

    # Remover a coluna COVID de ambos data frames e a coluna inicial 
    # usando a função select do DataFrames 
    ca = select(ca_treino, Not([:Column1, :COVID]));
    cb = select(cb_treino, Not([:Column1, :COVID]));
    C = select(df_treino, Not([:Column1, :COVID]));
    y_real = select(df_treino, :COVID);
    #y_real = eachcol(y_real);
     
    return C, ca, cb, y_real 
    

end