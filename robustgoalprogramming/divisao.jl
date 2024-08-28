# Arquivo para divisão entre treino e teste 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024

using DataFrames
using Random 

function dividir_dados(df::DataFrame, proporcao_treino::Float64)
    # dimensões
    (m,n) = size(df);
    m_treino = Int(round(proporcao_treino * m));
    
    # embaralhar os dados
    df_shuffled = df[shuffle(1:m),:];
    
    # dividir entre treino e teste
    df_treino = df_shuffled[1:m_treino, :];
    df_teste = df_shuffled[m_treino+1:end,:];
    
    # selecionar o label 
    y_real = select(df_teste, :COVID)
    
    # selecionar a matriz para o teste
    C_teste = select(df_treino, Not([:Column1,:COVID]))
    
    return df_treino, df_teste, C_teste, y_real 
    
end