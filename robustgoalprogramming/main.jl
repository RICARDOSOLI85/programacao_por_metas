# Arquivo principal do modelo Robusto 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 

#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha =1.0;
beta = 0.50; 
epsilon = 0.10; 
Gammas = [0.0, 1.0, 2.0, 5.0, 7.0, 10.0]; 
proporcao_treino = 0.70; 
#----------------------------------------------------------
#     Leitura e Processamento dos dados 
#----------------------------------------------------------
arquivo="exames.csv" 
include("dados.jl")
include("divisao.jl")
include("filtro.jl")
include("balanco.jl")

# leitura dos dados 
df = ler_arquivo(arquivo::String)

# divisão entre treino e teste 
df_treino, df_teste, C_teste, y_real = dividir_dados(df::DataFrame, proporcao_treino::Float64)

# delecionar categorias A e B 
ca_filtro, cb_filtro = dividir_categorias(df_treino::DataFrame)

# balancear as categorias A = B 
ca_balanceado, cb_balanceado= balancear_categorias(ca_filtro::DataFrame, cb_filtro::DataFrame)

#----------------------------------------------------------
#     Implementar o Modelos e imprimir as soluções  
#----------------------------------------------------------
# Modelo com Filtro 
ca = ca_filtro; 
cb = cb_filtro; 
# Modelo balanceado 
# ca = ca_balanceado; 
# cb = cb_balanceado; 
C = C_teste; 


#------------------------------
include("matrizes.jl")
include("gama.jl")
include("RPG_1A.jl")
include("metricas.jl")

    

# Implementar o modelo com as variações de Γ (Gamma)
for gama in Gammas
    println(" Testando o modelo para gama = $gama")

    # Criar as matrizes dos desvios 
    global  ca_desvio, cb_desvio = calcular_desvios(ca,cb,epsilon)

    # Criar os vetores Γ (Gamma) sujeitas a incerteza em cada linha
    global  ga, gb = cria_vetor_gama(ca,cb,gama)

    # Implementar o modelo Robusto de Goal Programming 
    global  FO, modelo, tar, sol = robusto_modelo1(C::DataFrame,ca::DataFrame,
    cb::DataFrame,alpha::Float64,
    ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
    ga::Vector{Float64},gb::Vector{Float64})

    # Imprimir os resultados do Modelo Robusto e salvar
    calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
    modelo::Model,tar::Float64,sol::Vector{Float64},
    model_name::String)  

    println("Resultado para gama = $gama: Função Objetivo = $FO\n")

end




#=
# Exemplo 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 
=#