# Modelo Programa Principal 
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha = 1.0;
beta =  1.00; 
proporcao_treino = 0.70;

# porcentagem de incerteza 
Epsilons = [0.01] # 0.05 , 0.10, 0.20, 0.50];

# número de colunas em cada linha sujeito a incerteza   
Gamas =   [1.0] # ,3.0, 5.0, 7.0, 10.0]; 
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

#----------------------------------------------------------
#    Implementar os modelos e suas variações  
#----------------------------------------------------------
include("RGP_1.jl")
include("RGP_2.jl")
include("gama.jl")
include("matrizes.jl")
include("metricas.jl")
include("classes.jl")



# conjuntos de testes 
Modelos =["RGP_1.jl","RGP_2.jl"]
Variacoes = ["A","B","C","D"]
Tipos = [(ca_filtro,cb_filtro,"sb"),(ca_balanceado,cb_balanceado,"cb")]

for model in Modelos
    println("Tetes para modelo:$model") 
    for variacao in Variacoes
        println("Variação do modelo:$variacao")
        for (ca,cb, tipo) in Tipos
            println("Com a configuração $tipo") 
            for gama in Gamas
                println("Para Gama Γ=$gama")
                for epsilon in Epsilons
                    println("Para Epsilon ϵ =$epsilon")
                    println(" ")
                    #println("Rodar modelo:$modelo.$variacao($tipo).Par Γ=$gama ϵ=$epsilon")
                    # Calcular as matrizes A de desvio 
                    ca_desvio, cb_desvio = calcular_desvios(ca::DataFrame,cb::DataFrame,epsilon::Float64)

                    # cria vetor gama 
                    gama_a, gama_b = cria_vetor_gama(ca::DataFrame,cb::DataFrame,gama::Float64)

                    println("Implementando o modelo $model.$variacao($tipo)")
                    # Modelo 1 
                    if model == "RGP_1.jl"
                        FO, modelo, tar, sol =robusto_modelo_1(C_treino::DataFrame,
                        ca::DataFrame, cb::DataFrame,alpha::Float64,
                        ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                        gama_a::Vector{Float64},gama_b::Vector{Float64}, 
                        variacao::String)
                        # metricas do modelo 1
                        println("Calculando as métricas do $modelo.$variacao($tipo)")
                        calcular_metricas(modelo::Model, C_teste::DataFrame,
                        sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                        model::String,variacao::String, 
                        tipo::String,gama::Float64,epsilon::Float64)
                    
                    # Modelo 2 
                    elseif model == "RGP_2.jl"
                        FO, modelo, tar, sol = robusto_modelo_2(C_treino::DataFrame,
                        ca::DataFrame,cb::DataFrame,
                        alpha::Float64,beta::Float64,
                        ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                        gama_a::Vector{Float64},gama_b::Vector{Float64},
                        variacao::String)
                        # metricas do modelo 2 
                        calcular_classes(modelo::Model,C_teste::DataFrame,
                        sol::Vector{Float64},tar::Float64,y_real::DataFrame,
                        model::String,variacao::String,
                        tipo::String,gama::Float64,epsilon::Float64,
                        beta::Float64)

                    end
                end
            end
        end
    end
end  