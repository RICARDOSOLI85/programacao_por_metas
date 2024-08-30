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

# Implementar:
# Lista de variações
Variacoes = ["A", "B", "C", "D"]

include("GP_1.jl");
include("GP_2.jl");
include("metricas.jl");
include("classes.jl");
# Loop para testar cada variação para o modelo GP1 e GP2
for variacao in variacoes
    println("Testando variação: $variacao")
    
    for x_value in intervalo_x
        println("Testando x no intervalo: $x_value")
        
        # Testar o modelo GP1
        println("Executando GP1 com variação $variacao")
        FO1, xo1, x1, modelo1 = gp_det1(C, ca, cb, alpha, beta, variacao)
        calcular_metricas(modelo1, C, x1, xo1, y_real, beta, variacao)
                
        # Testar o modelo GP2
        println("Executando GP2 com variação $variacao")
        FO2, xo2, x2, modelo2 = gp_det2(C, ca, cb, alpha, beta, variacao)  # Supondo que `gp_det2` é a função para o GP2
        calcular_metricas(modelo2, C, x2, xo2, y_real, beta, variacao)
        calcular_classes(FO2, C, x2, xo2, y_real, beta)
    end
end