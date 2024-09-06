# Arquivo para divisão entre treino e teste 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024

using DataFrames
using Random 

function dividir_dados(data::DataFrame, proporcao_treino::Float64)
    # definir a semente para gerar o mesmo embaralhamento
    #Random.seed!(2357)

    # dimensões
    (m,n) = size(data);
    m_treino = Int(round(proporcao_treino * m));
    
    # embaralhar os dados
    df_shuffled = data[shuffle(1:m),:];
    
    # dividir entre treino e teste
    df_treino = df_shuffled[1:m_treino, :];
    df_teste = df_shuffled[m_treino+1:end,:];
    
    # selecionar o label 
    y_real = select(df_teste, :COVID);
    
    # selecionar a matriz para o teste
    C_teste = select(df_teste, Not([:Column1,:COVID]));
    
    return C_teste, df_treino, df_teste, y_real 
    
end