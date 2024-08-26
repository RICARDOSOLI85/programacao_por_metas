# Modelo Robusto para o Problema de Classificação
# Data : 26/Agosto/2024
# Nome: Ricardo Soares Oliveira

using JuMP
using Gurobi

# função para resolver o modelo
function robusto_1(ca,cb,ca_hat,cb_hat,alpa,gama)

    # número das váriaveis 
    n1,m = size(ca)
    n2,m = size(cb)

    # parâmetros

    # variáveis 
    @variable()