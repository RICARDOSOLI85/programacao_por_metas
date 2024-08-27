# Modelo Robusto para Problema de Robusto de Classificação
# Data: 26/Agosto/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

#.................................
# Parâmetros (Escolher)
#.................................
alpha =1.0;
Beta = [0.50, 1.0];
proporcao_treino = 0.7;
epsilon = 0.10;             # Desvio na Matriz 
#Gama = [1,2,3];             # número de linhas sujeito a incerteza
Gama =[0]; 
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

# --------------------------
# Implementar Modelo (1): 
#---------------------------

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
# Balanceado : com balanceamento   
#ca = ca_bal;
#cb = cb_bal; 
#C = C_teste; 
#----------------------------------------



#--------------------------------------------------
# Implementar o modelo Robusto RGP 
#-------------------------------------------------
# Solicita ao usuário para inserir os valores de gama
println("Insira os valores para o parâmetro gama (separados por espaço):")
input_Gama = readline()

# Converte a entrada do usuário para um vetor de números inteiros
Gama = parse.(Int, split(input_Gama))

println("Valores de gama inseridos: ", Gama)


#alpha = 1
#gama = 5
include("RGP_M1.jl")
include("parametrovetor.jl")
include("matrizesincerteza.jl")


#ca_hat, cb_hat = calcular_desvios(ca,cb,epsilon)
#gama_a, gama_b = criavetor_gama(ca,cb,gama)
#gp_rob_1(C,ca,cb,ca_hat,cb_hat,alpha,gama)



for gama in Gama
    # 4 Matriz de incerteza
    ca_hat, cb_hat = calcular_desvios(ca,cb,epsilon)

    # 5. Parâmetro gama vetorial 
    gama_a, gama_b = criavetor_gama(ca,cb,gama)

    # 6. Implementar o Modelo RGP_1
    gp_rob_1(C,ca,cb,ca_hat,cb_hat,alpha,gama)

    
    # 7. Imprimir resultados. 
end 






# Incluir os arquivos das funções 
include("GP_1A.jl")
include("GP_1B.jl")
include("GP_1C.jl")
include("GP_1D.jl")
include("metricas.jl")

# Lista de Modelos 
Set_Model_1 = ["GP_1A.jl", "GP_1B.jl", "GP_1C.jl", "GP_1D.jl"]

# Função para calcular cada modelo e as métricas 

for model_name in Set_Model_1
    # Remove a extensão do nome do arquivo para comparação
     println("Excecutando $model_name")

    if model_name =="GP_1A.jl"
        modelo, x, xo, = gp_det_1A(C,ca, cb, alpha)
        print(" Imprimir xo ", xo)
        calcular_metricas(modelo, C, x, xo, y_real, model_name)

    elseif model_name =="GP_1B.jl"
        modelo, x, xo, = gp_det_1B(C,ca, cb, alpha)
        calcular_metricas(modelo, C, x, xo, y_real, model_name)

    elseif model_name =="GP_1C.jl"
        modelo, x, xo, = gp_det_1C(C,ca,cb,alpha)
        calcular_metricas(modelo, C, x, xo, y_real, model_name)

    elseif model_name =="GP_1D.jl"
        modelo, x, xo, = gp_det_1D(C,ca, cb, alpha)
        calcular_metricas(modelo, C, x, xo, y_real, model_name)        
    end 
end 

# Incluir os arquivos das funções 
include("GP_2A.jl")
include("GP_2B.jl")
include("GP_2C.jl")
include("GP_2D.jl")
include("classes.jl")

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
=# 