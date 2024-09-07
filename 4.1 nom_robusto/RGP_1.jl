# Modelo Programação por Metas Robusto
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

using JuMP
using Gurobi
using DataFrames
"""
function robusto_modelo_1(C_treino::DataFrame,
        ca::DataFrame, cb::DataFrame,alpha::Float64,
        ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
        gama_a::Vector{Float64},gama_b::Vector{Float64}, 
        variacao::String)
""" 

#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function robusto_modelo_1(
    C_treino::Matrix{Int64},
    ca::Matrix{Int64}, 
    cb::Matrix{Int64},
    alpha::Float64,
    ca_desvio::Matrix{Float64},
    cb_desvio::Matrix{Float64},
    gama_a::Vector{Float64},
    gama_b::Vector{Float64}, 
    variacao::String)

    # leitura 
    (n,m) = size(C_treino)
    n1 = size(ca,1)
    n2 = size(cb,1)
      

    # Modelo 
    modelo = JuMP.Model(Gurobi.Optimizer)

    # Variação 
    if variacao == "A"
        @variable(modelo, 0 <= x[j=1:m] <= alpha)
    elseif variacao =="B"
        @variable(modelo, -alpha <= x[j=1:m] <= alpha)
    elseif variacao == "C"
        @variable(modelo, x[j=1:m])
    elseif variacao =="D"
        @variable(modelo, x[j=1:m] <= alpha)
    end 
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
    @constraints(modelo,
    begin
        rest1[i=1:n1], sum(ca[i,j]*x[j] for j in 1:m) + 
        sum(p[i,j] for j in 1:m) + gama_a[i]*z[i] + 
        n_a[i] - p_a[i] == target 
        rest2[i=1:n2], sum(cb[i,j]*x[j] for j in 1:m) + 
        sum(p[i,j] for j in 1:m) + gama_b[i]*z[i] +
        n_b[i] - p_b[i] == target
    end)

    @constraints(modelo,
    begin
        rest3[i in 1:n1, j in 1:m], z[i] + p[i,j] >= ca_desvio[i,j] * x[j]
        rest4[i in 1:n2, j in 1:m], z[i] + p[i,j] >= cb_desvio[i,j] * x[j]
    end)


    if variacao != "B"
    @constraint(modelo, sum(x[j] for j in 1:m) == 1)
    end 

    # resolver o modelo
    optimize!(modelo)

    # Impressão 
    #println(modelo)
    println(".................................................")
    println("   Solução do modelo Robusto 1_($variacao)       ")
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
    Status = termination_status(modelo)
    time = round(solve_time(modelo), digits=4)
    println("Status = ", Status)
    println("Time   = ", time, " s")
    println(".................................................")
    return FO, modelo, tar, sol   
end
