# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 

# 1. dados 
include("dados.jl")
arquivo ="exames.csv"
df = ler_csv(arquivo)

# 2. dividir
# 2.1 Agora selecionar y_real do (dividir.jl) é realmente o teste do modelo 
include("dividir.jl")
df_treino, df_teste, C_test, y_real_test = dividir_dados(df::DataFrame, proporcao_treino::Float64)


# 3. Categorias
# Os valores de C e y_real estão dentro do treino, então seria validação.
# 3.1 Pegar o y_real do filtro é validação )pois ele vem do df_treino) 
include("filtro.jl") 
C_vald, ca, cb, y_real_vald = dividir_categorias(df_treino::DataFrame)

# 4. Label Y ser Validação ou Teste (Escolha)
#------------------------------------------------
# (i) Validação 
#y_real = y_real_vald
#C = C_vald

# (ii) Teste
y_real = y_real_test
C = C_test 
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

println("Matriz :")
println(first(C,10))
println(size(C))

# 5. Balancear 
include("balancear.jl")
C_balanced, ca_balanced,   cb_balanced= balancear_categorias(C,ca,cb)
ca = ca_balanced ;
cb = cb_balanced ; 

println("ca_balanced = ", size(ca))
println("cb_balanced = ", size(cb))
println("C_balanced = ", size(C))
println(first(ca_balanced,10))
println(first(cb_balanced,10))
println(last(C_balanced,10))
   

# --------------------------
# Implementar Modelo (1): 
#---------------------------
# input 
include("GP_1.jl") 
include("metricas.jl")
# funções 
modelo, x, xo = gp_det(C,ca,cb,alpha)    
calcular_metricas(modelo, C ,x,xo,y_real,model_name)


#++++++++++++++++++++++++++++++++++++
# Parâmetros (Escolher)
#++++++++++++++++++++++++++++++++++++++
alpha =1.0;
beta = 0.50;
proporcao_treino = 0.7; 
#-------------------------------------

# --------------------------
# Implementar Modelo (1)
# * Automatizar *   
# 
#---------------------------

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
        modelo, x, xo, = gp_det_1B(C,ca, cb, alpha)
        calcular_metricas(modelo, C, x, xo, y_real, model_name)

    elseif model_name =="GP_1D.jl"
        modelo, x, xo, = gp_det_1B(C,ca, cb, alpha)
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
Set_Model_1 = ["GP_2A.jl", "GP_2B.jl", "GP_2C.jl", "GP_2D.jl"]

# Função para calcular cada modelo e as métricas 

for model_name in Set_Model_1
    # Remove a extensão do nome do arquivo para comparação
     println("Excecutando $model_name")

    if model_name =="GP_2A.jl"
        modelo, x, xo, = gp_det_2A(C,ca, cb, alpha,beta)
        calcular_classes(FO, C, x, xo, y_real,beta, model_name)
        
    elseif model_name =="GP_2B.jl"
        modelo, x, xo, = gp_det2B(C,ca, cb, alpha,beta)
        calcular_classes(FO, C, x, xo, y_real,beta, model_name)

    elseif model_name =="GP_2C.jl"
        modelo, x, xo, = gp_det2C(C,ca, cb, alpha,beta)
        calcular_classes(FO, C, x, xo, y_real,beta, model_name)

    elseif model_name =="GP_2D.jl"
        modelo, x, xo, = gp_det2D(C,ca, cb, alpha,beta)
        calcular_classes(FO, C, x, xo, y_real,beta, model_name)  
    end 
end 







# Implementar Modelo (2): 
xinclude("GP_2.jl")
include("classes.jl")
# funções 
FO, xo, x, modelo = gp_det(C,ca,cb,alpha,beta)
model_name =="GP_2.jl"
calcular_classes(FO, C, x, xo, y_real,beta)


# Exemplo
#=
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:];
=# 