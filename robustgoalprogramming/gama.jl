# Criação do vetor Gama 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 


function cria_vetor_gama(ca,cb,gama)
    # dimensões
    gamma_a = ones(size(ca,1))
    gamma_b = ones(size(cb,1))

    # atribuindo o número de colunas de cada linha
    # sujeitas a incerteza Γ
    # por padrão iguais em todas as linhas 
    ga = gama*gamma_a
    gb = gama*gamma_b 

    return ga, gb
    
end