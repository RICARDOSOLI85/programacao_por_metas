# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

# input 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
ca = C[1:5,:]; 
cb = C[6:10,:]; 

# parâmetros 
#alpha =1.0;
#beta = 1.0; 

# implementar 
include("ModeloR.jl")

gp_det(C,ca,cb,alpha,beta)