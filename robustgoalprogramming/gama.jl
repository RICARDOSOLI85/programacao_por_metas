# Criação do vetor Gama 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 


function cria_vetor_gama(ca::DataFrame,cb::DataFrame,gama::Float64)
    # dimensões
    gamma_a = ones(size(ca,1))
    gamma_b = ones(size(cb,1))

    # atribuindo o número de colunas de cada linha
    # sujeitas a incerteza Γ
    # por padrão iguais em todas as linhas 
    gama_a = gama*gamma_a
    gama_b = gama*gamma_b 

    return gama_a, gama_b
    
end