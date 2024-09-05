# Modelo Programa Principal 
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha = 1.0;
beta =  1.00; 
Epsilons = [0.01, 0.05, 0.10, 0.20, 0.50];  
Gammas =   [1.0 , 3.0, 5.0, 7.0, 10.0]; 
proporcao_treino = 0.70; 

#----------------------------------------------------------
#     Leitura e Processamento dos dados 
#----------------------------------------------------------

# 1. dados
include("dados.jl")
arquivo="exames.csv"  
df = ler_arquivo(arquivo::String)

# 2. dividir
include("divisao.jl") 
C_teste, df_treino, df_teste, y_real = dividir_dados(df::DataFrame, proporcao_treino::Float64)

# 3. categorias 
include("filtro.jl")
C_treino, ca_filtro, cb_filtro = dividir_categorias(df_treino::DataFrame)

# balancear 
include("balanco.jl")
ca_balanceado, cb_balanceado= balancear_categorias(ca_filtro::DataFrame, cb_filtro::DataFrame)