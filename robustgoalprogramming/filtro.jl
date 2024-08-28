# Arquivo para filtrar ps dados para o modelo 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024

using DataFrames

function dividir_categorias(df_treino::DataFrame)
    # dividir os dados entre as categorias A e B 
    # função anonima e filter
    ca_treino = filter(:COVID => n -> n == 1.0, df_treino);
    cb_treino = filter(:COVID => n -> n == 0.0, df_treino);
   
    # remover as colunas Column1 e COVID
    # função select 
    ca_filtro = select(ca_treino, Not([:Column1, :COVID]));
    cb_filtro = select(cb_treino, Not([:Column1, :COVID]));

    println("ca_filtro ", ca_filtro)
    println("cb_filtro ", cb_filtro)

    return ca_filtro, cb_filtro 
    
end