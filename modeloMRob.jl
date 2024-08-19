# Modelo Robusto  para Problema da demanda
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi


# Função para resolver o modelo 

function linear_robusto(A,b,c,m)
    # criar o modelo
    modelo = Model(Gurobi.Optimizer)
    
    # numero de variaveis
    n = length(c); 
    m,n = size(A); 

    # parametros 
    
    # variaveis
    @variable(modelo, x[1:n]>=0)
    @variable(modelo, pos[1:m]>=0)
    @variable(modelo, neg[1:m]>=0)
    @variable(modelo, p[1:m,1:n]>=0)
    @variable(modelo, z[1:m]>=0)
    
   

    # função Objetivo
    @objective(modelo,Min, sum(c[i]*pos[i] for i in 1:m))

    # restrições
    @constraint(modelo, rest1[i in 1:m], 
    sum(A[i,j]*x[j] for j in 1:n)+ 
    sum(p[i,j] for j in 1:n)- 
    pos[i] + 
    neg[i] + 
    gama[i]*z[i]
    ==b[i])

    @constraint(modelo, rest2[i in 1:m,  j in 1:n],
    z[i] + p[i,j] >= 
    a[i,j]*x[j])
 
    
 
    # resolver 
    optimize!(modelo)

     # Verificar a solução

    if termination_status(modelo) == MOI.OPTIMAL
        println("Solução ótima encontrada")
        println("Status = ", termination_status(modelo))
        println("Objetivo = ", objective_value(modelo))
        

        println("")
        
        for i in 1:n
            println("x[$i] = ", value(x[i]))
        end
        
        for j in 1:m
            println("pos[$j] = ", value(pos[j]))
            println("neg[$j] = ", value(neg[j]))
        end
        return modelo 
        #return value.(x), value.(pos), value.(neg), objective_value(modelo)
    else
        println("Solução não ótima ou erro")
        return nothing, nothing, nothing, nothing
    end

 

end 
