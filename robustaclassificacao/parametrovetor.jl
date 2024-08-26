# Cronstrói o vetor respectivo gama 
# Data : 26/Agosto/2024
# Nome: Ricardo Soares Oliveira 

function criavetor_gama(ca,cb,gama)
    # criando os vetores 
    gama_A = ones(size(ca,1));
    gama_B = ones(size(cb,1));

    # atribuindo o valor de gama
    # numero de linhas sujeitos a incerteza 
    gama_a = gama*gama_A; 
    gama_b = gama*gama_B; 

    println("dim a ", size(gama_a))
    println(" tipo a : ", typeof(gama_a))
    println("dim b: ", size(gama_b))
    println(" tipo a : ", typeof(gama_b))

    return gama_a, gama_b

        
end