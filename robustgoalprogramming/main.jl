# Arquivo principal do modelo Robusto 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 

# Exemplo 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 

# parâmetros 
alpha =1.0;
beta = 0.50; 
gama = 5.0; 
# Implementar o modelo Robusto de GP
include("RPG_1A.jl")
FO, modelo, tar, sol = robusto_modelo1(C,ca,cb,alpha,gama)
model_name ="Modelo_1A.Robusto(sb)"
# Imprimir os resultados do Modelo Robusto e salvar
include("metricas.jl")
calcular_metricas(C::Matrix,y_real::Vector,FO::Float64,
    modelo::Model,tar::Float64,sol::Vector{Float64},
    model_name::String)

