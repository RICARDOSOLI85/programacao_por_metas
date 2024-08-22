# Arquivo para Balancear 
# Data: 22/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using Random
using DataFrames

function balancear_categorias(C,ca,cb)
    # ca e cb são data frames de duas Categorias
    ca_count = size(ca,1) # numero de elementos de A
    cb_count = size(cb,1) # numero de elementos de Balancear
    
    # determinar o menor tamanho entre 'ca' e 'cb' 
    k = min(ca_count,cb_count)

    # Embaralhar os dados (2° vez) (1° :dividir.jl)
    # e seleciona k elementos para cada um dos data frames
    ca_balanced = ca[shuffle(1:ca_count)[1:k],:]
    cb_balanced = cb[shuffle(1:cb_count)[1:k],:]

    # Concatenar ca_balanced e cb_balanced
    C_balanced = vcat(ca_balanced, cb_balanced)
    return  C_balanced, ca_balanced,   cb_balanced

    
end