# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi
using DataFrames 

include("GP_1.jl");
include("GP_2.jl");
include("metricas.jl");
include("classes.jl");


# input 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 

# parâmetros 
alpha =1.0;
beta = 1.0; 

# Lista de variações
Variacoes = ["A", "B", "C", "D"]

# Loop para testar cada variação para o modelo GP1 e GP2
for variacao in Variacoes
     println("Testando variação: $variacao")
              
        # Testar o modelo GP1
        println("Executando GP1 com variação $variacao")
        FO, xo, x, modelo = gp_det1(C, ca, cb, alpha, beta, variacao)
        calcular_metricas(modelo, C, x, xo, y_real, beta, variacao)

                
        # Testar o modelo GP2
        println("Executando GP2 com variação $variacao")
        FO, xo, x, modelo = gp_det2(C, ca, cb, alpha, beta, variacao)  
        calcular_classes(FO, C, x, xo, y_real, beta, variacao)
        


end 


# Implementar: 
#=
include("GP_1.jl")
include("GP_2.jl")
#include("metricas.jl")
include("classes.jl")
# Funções 
FO, xo, x, modelo = gp_det(C,ca,cb,alpha,beta)     # Modelo 1
#calcular_metricas(modelo, C,x,xo,y_real,beta) 
calcular_classes(FO, C, x, xo, y_real,beta)
=# 