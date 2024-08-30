# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

# input 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 

# parâmetros 
alpha =1.0;
beta = 0.50; 

# Implementar: 

#include("GP_1.jl")
include("GP_2.jl")
#include("metricas.jl")
include("classes.jl")
# Funções 
FO, xo, x, modelo = gp_det(C,ca,cb,alpha,beta)     # Modelo 1
#calcular_metricas(modelo, C,x,xo,y_real,beta) 
calcular_classes(FO, C, x, xo, y_real,beta)
