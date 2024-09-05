# Arquivo para balancear os dados
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024

using Random 

function balancear_categorias(ca_filtro::DataFrame, cb_filtro::DataFrame)
    # definir a semente para gerar o mesmo embaralhamento
    #Random.seed!(2357)

    # dimensao 
    ca_count = size(ca_filtro,1);
    cb_count = size(cb_filtro,1); 
    #println(" dim ca ", ca_count)
    #println(" dim cb  ", cb_count)
    # menor dimensão 
    k = min(ca_count, cb_count);
    #println(" k : ", k)

    # embaralhar novamente e igualar os tamanhos das categorias
    ca_balanceado = ca_filtro[shuffle(1:ca_count)[1:k],:];
    cb_balanceado = cb_filtro[shuffle(1:cb_count)[1:k],:];
    #println(" ca_balanceado = ", ca_balanceado)
    #println("cb_balanceado ", cb_balanceado)

    return ca_balanceado, cb_balanceado

    
    
end