# Cria as matrizes com os possíveis desvios
# Data : 26/Agosto/2024
# Nome: Ricardo Soares Oliveira 

# Função para criar as matrizes com os possíveis desvios 

function calcular_desvios(ca,cb,epsilon)
    (n1,m) = size(ca);
    (n2,m) = size(cb);
    ca_hat = zeros(size(ca));
    cb_hat = zeros(size(cb));

    # Processamento da matriz 'ca' 

    for i in 1:n1
        for j in 1:m
            if ca[i,j] == 0
                ca_hat[i,j] = epsilon;               
            elseif ca[i,j] == 1
                ca_hat[i,j] = ca[i,j] * (1 - epsilon);                
            end 
            
        end 
    end 

    # Processamento da matriz 'cb' 
    
    for i in 1:n2
        for j in 1:m
            if cb[i,j] == 0
                cb_hat[i,j] = epsilon;
            elseif cb[i,j] == 1
                cb_hat[i,j] = cb[i,j] * (1 - epsilon);
            end
        end
    end
    
    #println("ca_hat = ", ca_hat)
    #println("cb_hat = ", cb_hat)
    return ca_hat,cb_hat  


       
end