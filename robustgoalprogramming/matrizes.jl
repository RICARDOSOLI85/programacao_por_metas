# Cria as Matrizes com os desvios 
# Data: 27/Agosto/2024
# Nome: Ricardo Soares Oliveira

function calcular_desvios(ca,cb,epsilon)
    # dimensões
    (n1,m) = size(ca);
    (n2,m) = size(cb);

    ca_hat = zeros(n1,m);
    cb_hat = zeros(n2,m);

    # Dados binários 
    #=
    # Processamento da Matriz ca 
    for i in 1:n1
        for j in 1:m 
            if ca[i,j] == 0
                ca_hat[i,j] = epsilon;
            elseif ca[i,j] == 1
                ca_hat = - epsilon; 
            end 
        end
    end 
    # Processamento da Matriz cb 
    for i in 1:n1
        for j in 1:m 
            if cb[i,j] == 0
                cb_hat[i,j] = epsilon;
            elseif cb[i,j] == 1
                cb_hat = - epsilon; 
            end 
        end
    end 
    =#
    # Dados não binários
    for i in 1:n1
        for j in 1:m
            ca_hat[i,j] = ca[i,j] * epsilon;           
        end
    end 
    for i in 1:n2
        for j in 1:m
            cb_hat[i,j] = cb[i,j] * epsilon;           
        end
    end 
    ca_hat
    cb_hat

    return ca_hat, cb_hat
    
end