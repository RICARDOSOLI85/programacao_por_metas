# Modelo Robusto  para Problema Saúde 
# Data: 26/Agosto/2024 
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi


#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function gp_rob_1(C,ca,cb,ca_hat,cb_hat,alpha,gama)
       
    # numero de variáveis
    (n,m) = size(C); 
    n1 = size(ca,1);
    n2 = size(cb,1);
    n = max(n1,n2) 

    # parametros 
    gama_a = gama*ones(size(ca,1));
    gama_b = gama*ones(size(cb,1));

    # criar o modelo
    modelo = JuMP.Model(Gurobi.Optimizer)
    
    # Variaveis
    @variable(modelo, 0 <= x[j=1:m] <= alpha)  
    @variable(modelo, xo_target)              
    @variables(modelo,                
    begin
        pos_a[1:n1] >= 0 
        pos_b[1:n2] >= 0
        neg_a[1:n1] >= 0 
        neg_b[1:n2] >= 0
    end)
    # variáveis do modelo Robusto
    #=
    @variables(modelo, 
    begin
        p_a[1:n1,1:m] >= 0 
        p_b[1:n2,1:m] >= 0 
        z_a[1:n1]     >= 0
        z_b[1:n2]     >= 0
    end)
    =#
    @variable(modelo, p[1:n,1:m]>=0)
    @variable(modelo, z[1:n]>=0)
   

    # função Objetivo
    @objective(modelo,Min, sum(neg_a[i] for i=1:n1) + sum(pos_b[i] for i=1:n2))

    # restrições 
    #=
    @constraints(modelo, 
    begin
    rest1[i=1:n1], 
    sum(ca[i,j]*x[j] for j in 1:m) + 
    sum(p_a[i,j] for j in 1:m) + 
    neg_a[i] - pos_a[i] + 
    gama_a[i] * z_a[i] == xo_target
    rest2[i=1:n2], 
    sum(cb[i,j]*x[j] for j in 1:m)+
    sum(p_b[i,j] for j in 1:m) +
    neg_b[i] - pos_b[i] + 
    gama_b[i] * z_b[i] == xo_target  
    end
    )

    @constraints(modelo, 
    begin
        rest3[i in 1:n1, j in 1:m], z_a[i] + p_a[i,j] >= ca_hat[i,j] * x[j]
        rest4[i in 1:n2, j in 1:m], z_b[i] + p_b[i,j] >= cb_hat[i,j] * x[j]
    end)
    =#
    @constraint(modelo, rest1[i=1:n1], 
    sum(ca[i,j]*x[j] for j in 1:m) + 
    sum(p[i,j] for j in 1:m) + 
    neg_a[i] - pos_a[i] + 
    gama_a[i] * z[i] == xo_target)

    @constraint(modelo, rest2[i=1:n2], 
    sum(cb[i,j]*x[j] for j in 1:m)+
    sum(p[i,j] for j in 1:m) +
    neg_b[i] - pos_b[i] + 
    gama_b[i] * z[i] == xo_target  
    )
    @constraints(modelo, 
    begin
        rest3[i in 1:n1, j in 1:m], z[i] + p[i,j] >= ca_hat[i,j] * x[j]
        rest4[i in 1:n2, j in 1:m], z[i] + p[i,j] >= cb_hat[i,j] * x[j]
    end)
    
    @constraint(modelo, rest5[1:m], sum(x[j] for j in 1:m) ==1)
   
    # resolver 
    optimize!(modelo)
    #print(modelo)
    JuMP.all_variables(modelo)
   num_variables(modelo)
   #println(modelo)
   FO = JuMP.objective_value(modelo);
   xo_target = JuMP.value(xo_target);
   x  = JuMP.value.(x);
   println("-------------Imprimindo a Solução do Modelo---------")
   println("F[O] = ",  FO)
   println("x[0]:target  = ",  xo_target)
   for i=1:m
   println("x[$i] = ", JuMP.value.(x[i]));
   end
   #=
   for i in 1:n1
    if value(pos_a[i]) > 0
        println("pos_a[$i] = ", value(pos_a[i]))
    end 
    if value(neg_a[i]) > 0
        println("neg_a[$i] = ", value(neg_a[i]))
    end 
end
    for i in 1:n2
        if value(pos_b[i]) > 0
            println("pos_b[$i] = ", value(pos_b[i]))
        end 
        if value(neg_b[i]) > 0
            println("neg_b[$i] = ", value(neg_b[i]))
        end 
    end
    =#
    for i in 1:n1
        if value(z[i]) > 0
              println("z[$i]:n1 = ", value(z[i]))
        end
    end 
    for i in 1:n2
        if value(z[i]) > 0
            println("z[$i]:n2 = ", value(z[i]))
        end
    end 
    for j in 1:m
        for i in 1:n1
            if value(p[i,j]) > 0
                println("p[($i,$j)]:n1 = ", value(p[i,j]))
            end
        end
    end 
    for j in 1:m
        for i in 1:n2
            if value(p[i,j]) > 0
                println("p[($i,$j)]:n2 = ", value(p[i,j]))
            end
        end
    end
   
    
   status = termination_status(modelo)
   time = round(solve_time(modelo),digits=4)
   println("Status = ", status )
   println("Time  =  ", time )

   println("F[O] = ",  FO)
   println("x[0] = ",  xo_target)
   
   return modelo, x, xo_target  
end 