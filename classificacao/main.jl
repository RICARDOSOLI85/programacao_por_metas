# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Versão atualizada 25/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

#.................................
# Parâmetros (Escolher)
#.................................
alpha =1.0;
beta = 1.0;
proporcao_treino = 0.7; 
#.................................

# 1. dados 
include("dados.jl")
arquivo ="exames.csv"
df = ler_csv(arquivo)

# 2. dividir
include("dividir.jl")
df_treino, df_teste, C_teste, y_real = dividir_dados(df::DataFrame, proporcao_treino::Float64)


# 3. Categorias
include("filtro.jl") 
C_treino_a, ca_fil, cb_fil = dividir_categorias(df_treino::DataFrame)

include("balancear.jl")
balancear_categorias(C_treino_a::DataFrame, ca_fil::DataFrame, cb_fil::DataFrame)
C_treino_b, ca_bal, cb_bal = balancear_categorias(C_treino_a::DataFrame, ca_fil::DataFrame, cb_fil::DataFrame)

#------------------------------------------------ 
#=
println("Categoria A (filtro):")
println(first(ca_fil,10))
println(size(ca_fil))

println("Categoria B (filtro):")
println(first(cb_fil,10))
println(size(cb_fil))

println(" Matrix C (filtro):")
println(first(C_treino_a,10))
println(size(C_treino_a))

println("Categoria A (balanceado):")
println(first(ca_bal,10))
println(size(ca_bal))

println("Categoria B (balanceado):")
println(first(cb_bal,10))
println(size(cb_bal))

println(" Matrix C (balanceado):")
println(first(C_treino_b,10))
println(size(C_treino_b))

println(" Matrix C * Teste *:")
println(first(C_teste,10))
println(size(C_teste))


println("Label :")
println(first(y_real,10))
println(size(y_real))

println("Matriz :")
println(first(C_teste,10))
println(size(C_teste))


# --------------------------
# Implementar Modelo (1): 
#---------------------------


=#


# -------------------------=-----------
# Implementar Modelo (1) : A, B, C e D
# Implementar Modelo (2) : A, B, C e D
#--------------------------------------
# Filtro: Sem balanceamento   
ca = ca_fil;
cb = cb_fil; 
C = C_teste; 
#--------------------------------------
#--------------------------------------
# Balanceado balanceamento   
#ca = ca_bal;
#cb = cb_bal; 
#C = C_teste; 
#----------------------------------------

# Incluir os arquivos das funções 
include("GP_1A.jl")
include("GP_1B.jl")
include("GP_1C.jl")
include("GP_1D.jl")
#include("metricas.jl")
include("Metricas.jl")


# Lista de Modelos 
Set_Model_1 = ["GP_1A.jl", "GP_1B.jl", "GP_1C.jl", "GP_1D.jl"]

# Função para calcular cada modelo e as métricas 

for model_name in Set_Model_1
    # Remove a extensão do nome do arquivo para comparação
     println("Excecutando $model_name")

    if model_name =="GP_1A.jl"
        modelo, x_vals, xo_vals  = gp_det_1A(C,ca, cb, alpha)
        calcular_metricas(modelo, C ,x_vals,xo_vals,y_real,model_name)

    elseif model_name =="GP_1B.jl"
        modelo, x_vals, xo_vals  = gp_det_1B(C,ca, cb, alpha)
        calcular_metricas(modelo, C ,x_vals,xo_vals,y_real,model_name)

    elseif model_name =="GP_1C.jl"
        modelo, x_vals, xo_vals  = gp_det_1C(C,ca,cb,alpha)
        calcular_metricas(modelo, C ,x_vals,xo_vals,y_real,model_name)

    elseif model_name =="GP_1D.jl"
        modelo, x_vals, xo_vals  = gp_det_1D(C,ca, cb, alpha)
        calcular_metricas(modelo, C ,x_vals,xo_vals,y_real,model_name)       
    end 
end 

# Incluir os arquivos das funções 
include("GP_2A.jl")
include("GP_2B.jl")
include("GP_2C.jl")
include("GP_2D.jl")
#include("classes.jl")
include("Classes.jl")

# Lista de Modelos 
Set_Model_2 = ["GP_2A.jl", "GP_2B.jl", "GP_2C.jl", "GP_2D.jl"]

# Função para calcular cada modelo e as métricas 

for model_name in Set_Model_2
    # Remove a extensão do nome do arquivo para comparação
     println("Excecutando $model_name")

    if model_name =="GP_2A.jl"
        FO, modelo, x_vals, xo_val = gp_det2A(C,ca, cb, alpha,beta)
        calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name) 
        
    elseif model_name =="GP_2B.jl"
        FO, modelo, x_vals, xo_val = gp_det2B(C,ca, cb, alpha,beta)
        calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name) 

    elseif model_name =="GP_2C.jl"
        FO, modelo, x_vals, xo_val = gp_det2C(C,ca, cb, alpha,beta)
        calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name)

    elseif model_name =="GP_2D.jl"
        FO, modelo, x_vals, xo_val = gp_det2D(C,ca, cb, alpha,beta)
        calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name) 
    end 
end 






#=
# Implementar Modelo (1): 
include("GP_1.jl") 
include("metricas.jl")
# funções 
modelo, x, xo = gp_det(C,ca,cb,alpha)    
calcular_metricas(modelo, C ,x,xo,y_real,model_name)
# Implementar Modelo (2): 
include("GP_2A.jl")
FO, modelo, x_vals, xo_val  = gp_det(C,ca,cb,alpha,beta)
model_name =[" "] 
model_name =="GP_2.jl"
include("classes.jl")
calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name)
# Exemplo
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:];
=#