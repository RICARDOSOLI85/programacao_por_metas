# Modelo Programação por Metas Robusto
# Nome: Ricardo Soares Oliveira
# Data 27/Agosto/2024

using JuMP
using Gurobi

"""
    robusto_modelo1(C,ca,cb,alpha,gama)

TBW
"""
function robusto_modelo1(C,ca,cb,alpha,ca_hat,cb_hat,ga,gb)

    # leitura 
    (n,m) = size(C)
    n1 = size(ca,1)
    n2 = size(cb,1)
    

    # Modelo 
    modelo = JuMP.Model(Gurobi.Optimizer)

    # variáveis
    @variable(modelo, 0 <= x[j=1:m] <= alpha)
    @variable(modelo, target)
    @variables(modelo,
    begin
        n_a[1:n1] >= 0
        n_b[1:n2] >= 0
        p_a[1:n1] >= 0
        p_b[1:n2] >= 0
    end)
    # alteração:a
    @variables(modelo,
    begin
        p[i=1:n,j=1:m] >= 0
        z[i=1:n]       >=0
    end)

    # função objetivo
    @objective(modelo, Min, sum(n_a[i] for i=1:n1) + sum(p_b[i] for i=1:n2))

    # restrições 
    # alteração:b 
    #=
    @constraints(modelo,
    begin
        rest1[i=1:n1], sum(ca[i,j]*x[j] for j in 1:m) + n_a[i] - p_a[i] == target 
        rest2[i=1:n2], sum(cb[i,j]*x[j] for j in 1:m) + n_b[i] - p_b[i] == target
    end)
    =#
    @constraints(modelo,
    begin
        rest1[i=1:n1], sum(ca[i,j]*x[j] for j in 1:m) + 
        sum(p[i,j] for j in 1:m) + ga[i]*z[i] + 
        n_a[i] - p_a[i] == target 
        rest2[i=1:n2], sum(cb[i,j]*x[j] for j in 1:m) + 
        sum(p[i,j] for j in 1:m) + gb[i]*z[i] +
        n_b[i] - p_b[i] == target
    end)

    @constraints(modelo,
    begin
        rest3[i in 1:n1, j in 1:m], z[i] + p[i,j] >= ca_hat[i,j] * x[j]
        rest4[i in 1:n2, j in 1:m], z[i] + p[i,j] >= cb_hat[i,j] * x[j]
    end)


    @constraint(modelo, sum(x[j] for j in 1:m) == 1)

    # resolver o modelo
    optimize!(modelo)

    # Impressão 
    #println(modelo)
    println(".................................................")
    println("   Imprimindo a solução do modelo Robusto 1 A ")
    println(".................................................")
    FO     = JuMP.objective_value(modelo)
    tar = JuMP.value(target)
    sol = JuMP.value.(x)
    NV= num_variables(modelo)
    println("Função Objetivo (FO) = ", FO)
    println("Target (t)           = ", tar)
    println("Solução x[j]         = ", sol)
    println("N. variáveis         = ", NV)
    for j=1:m 
        println("x[$j] = ", JuMP.value.(x[j]))
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
    Status = termination_status(modelo)
    time = round(solve_time(modelo), digits=4)
    println("Status = ", Status)
    println("Time   = ", time, " s")
    println(".................................................")
    return FO, modelo, tar, sol   
end

