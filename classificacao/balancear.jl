# Arquivo para Balancear 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using Random
using DataFrames

function balancear_categorias(C_treino_a::DataFrame, ca_fil::DataFrame, cb_fil::DataFrame)
    # ca e cb são data frames de duas Categorias
    ca_count = size(ca_fil,1) # numero de elementos de A
    cb_count = size(cb_fil,1) # numero de elementos de Balancear
    
    # determinar o menor tamanho entre 'ca' e 'cb' 
    k = min(ca_count,cb_count)

    # Embaralhar os dados (2° vez) (1° :dividir.jl)
    # e seleciona k elementos para cada um dos data frames
    ca_bal = ca_fil[shuffle(1:ca_count)[1:k],:]
    cb_bal = cb_fil[shuffle(1:cb_count)[1:k],:]

    # Concatenar ca_balanced e cb_balanced
    C_treino_b = vcat(ca_bal, cb_bal)
    return  C_treino_b, ca_bal,   cb_bal

    
end