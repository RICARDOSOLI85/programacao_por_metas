# Modelo Robusto  para Problema de Classificação
# Data: 21/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 


#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function gp_dete(C,ca,cb,alpha,beta)
    # leitura 
    (m,n) = size(C);
    n1 = size(ca,1);
    n2 = size(cb,1); 

    # modelo
    modelo = JuMP.Model(Gurobi.Optimizer)

    #Variáveis 
    @variable(modelo, 0 <= x[j=1:n] <= 1)     #A
    #@variable(modelo, -1 <= x[j=1:n] <= 1)     #B
    #@variable(modelo,x[j=1:n])                #C
    #@variable(modelo,9<=x[j=1:n]<= 9)            #D
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
    ca[i=1:n1], sum(ca[i,j]*x[j] for j in 1:n) + n_a[i] - p_a[i] == xo + beta 
    cb[i=1:n2], sum(cb[i,j]*x[j] for j in 1:n) + n_b[i] - p_b[i] == xo - beta 
    end
    )
    @constraint(modelo, sum(x[j] for j in 1:n) ==1)

    # solve modelo
    optimize!(modelo)

   print(modelo) 

   JuMP.all_variables(modelo)
   num_variables(modelo)
   #println(modelo)
   FO = JuMP.objective_value(modelo)
   xo = JuMP.value(xo)
   x  = JuMP.value.(x)
   println("-------------Imprimindo a Solução do Modelo---------")
   println("F[O] = ",  FO)
   println("x[0] = ",  xo)
   for i=1:n 
   println("x[$i] = ", JuMP.value.(x[i]))
   end
   
   return FO, xo, x, modelo 

end 