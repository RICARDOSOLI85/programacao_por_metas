# Modelo Robusto  para Problema de Classificação
# Data: 23/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 


#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function gp_det_1B(C,ca,cb,alpha)
    # leitura 
    (m,n) = size(C);
    n1 = size(ca,1);
    n2 = size(cb,1); 

    println("---------Impressão dados de Entrada--------")
    println("Alpha = ", alpha)
    println("Conj. treino (n)  = ", n)
    println("Dados de Teste    = ", n1+n2)
    println("Positivos CA (n1) = ", n1)
    println("Negativos CB (n2) = ", n2)
    println("------------------------------------------------")

    # modelo
    modelo = JuMP.Model(Gurobi.Optimizer)

    #Variáveis 
    @variable(modelo, -1 <= x[j=1:n] <= 1)     #B
    @variable(modelo, xo) 
    @variables(modelo,
    begin 
    n_a[1:n1] >= 0
    n_b[1:n2] >= 0 
    p_a[1:n1] >= 0
    p_b[1:n2] >= 0
    end 
    )

    # função Objetivo 
    @objective(modelo, Min, sum(n_a[i] for i=1:n1) + sum(p_b[i] for i=1:n2))

    # restrições
    @constraints(modelo,
    begin 
    ca[i=1:n1], sum(ca[i,j]*x[j] for j in 1:n) + n_a[i] - p_a[i] == xo 
    cb[i=1:n2], sum(cb[i,j]*x[j] for j in 1:n) + n_b[i] - p_b[i] == xo 
    end
    )
    

    # solve modelo
    optimize!(modelo)

    # print modelo 

    num = num_variables(modelo)
    println("numero variáveis = ", num)
    FO = JuMP.objective_value(modelo);
    xo_vals = JuMP.value(xo); # Alterado para evitar sobrescrita
    x_vals  = JuMP.value.(x); # Alterado para evitar sobrescrita
    println("-------------Imprimindo a Solução do Modelo---------")
    println("F[O] = ",  FO)
    println("x[0] = ",  xo_vals)
    for i=1:n 
     println("x[$i] = ", JuMP.value.(x[i]));
    end
    status = termination_status(modelo)
    time = round(solve_time(modelo),digits=4)
    println("Status = ", status )
    println("Time  =  ", time )
   
    return modelo, x_vals, xo_vals  

end 