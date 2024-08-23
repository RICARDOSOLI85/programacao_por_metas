# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

# Parâmetros (Escolher)
#-----------------------------------
alpha =1.0;
beta = 0.00;
proporcao_treino = 0.7; 
#-------------------------------------

# 1. dados 
include("dados.jl")
arquivo ="exames.csv"
df = ler_csv(arquivo)

# 2. dividir
# 2.1 Agora selecionar y_real do (dividir.jl) é realmente o teste do modelo 
include("dividir.jl")
df_treino, df_teste, y_real_test = dividir_dados(df::DataFrame, proporcao_treino::Float64)


# 3. Categorias
# Os valores de C e y_real estão dentro do treino, então seria validação.
# 3.1 Pegar o y_real do filtro é validação )pois ele vem do df_treino) 
include("filtro.jl") 
C, ca, cb, y_real_vald = dividir_categorias(df_treino::DataFrame)

# Label Y ser Validação ou Teste (Escolha)
#------------------------------------------------ 
y_real = y_real_vald 
y_real = y_real_test 
#------------------------------------------------ 

println("Categoria A (ca):")
println(first(ca,10))
println(size(ca))

println("Categoria B (cb):")
println(first(cb,10))
println(size(cb))

println("Categoria C (C):")
println(first(C,10))
println(size(C))

println("Label :")
println(first(y_real,10))
println(size(y_real))

# 4. Balancear 
include("dados.jl")
C_balanced, ca_balanced,   cb_balanced= balancear_categorias(C,ca,cb)

println("ca_balanced = ", size(ca_balanced))
println("cb_balanced = ", size(cb_balanced))
println("C_balanced = ", size(C_balanced))
println(first(ca_balanced,10))
println(first(cb_balanced,10))
println(last(C_balanced,10))
   

# --------------------------
# Implementar Modelo (1): 
#---------------------------
include("GP_1.jl") 
include("metricas.jl")
# funções 
# Input
# Exemplo
#=
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:];
=# 
modelo, x, xo = gp_det(C,ca,cb,alpha)    
calcular_metricas(modelo, C,x,xo,y_real)


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