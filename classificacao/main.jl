# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

# Parâmetros (Escolher)
#-----------------------------------
alpha =1.0;
beta = 0.50;
proporcao_treino = 0.3 
#-------------------------------------

# include 
include("dados.jl")
include("dataframe.jl")
include("filtro.jl")


# dados 
arquivo ="exames.csv"
df = ler_csv(arquivo)
df_treino, df_teste = dividir_dados(df::DataFrame, proporcao_treino::Float64)


println("Dados de treino (30%):")
println(first(df_treino, 5))
println(size(df_treino))

println("Dados de teste (70%):")
println(first(df_teste, 5))
println(size(df_teste))

# dividir 
C, ca, cb = dividir_categorias(df_treino::DataFrame)

println("Categoria A (ca):")
println(first(ca,10))
println(size(ca))

println("Categoria B (cb):")
println(first(cb,10))
println(size(cb))

println("Categoria C (C):")
println(first(C,10))
println(size(C))


# Implementar Modelo (1): 
include("GP_1.jl") 
include("metricas.jl")
# funções 
FO, xo, x, modelo = gp_det(C,ca,cb,alpha,beta)    
calcular_metricas(modelo, C,x,xo,y_real,beta)


# Implementar Modelo (2): 
include("GP_2.jl")
include("classes.jl")
# funções 
FO, xo, x, modelo = gp_det(C,ca,cb,alpha,beta)
#calcular_classes(FO, C, x, xo, y_real,beta)


#=
#C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
#y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
#ca = C[1:5,:]; 
#cb = C[6:10,:]; 
=# 