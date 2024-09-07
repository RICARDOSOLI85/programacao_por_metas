# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi
using DataFrames 
using CSV

include("RGP_1.jl");
include("RGP_2.jl");
include("matrizes.jl")
include("gama.jl")
include("metricas.jl");
include("classes.jl");


# input 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 

# parâmetros 
alpha =1.0;
beta = 1.0; 

# Lista de Modelso e  variações
Modelos =["RGP_1.jl","RGP_2.jl"]
Variacoes = ["A", "B", "C", "D"]

# dados 
C_treino = C 
ca = ca
C_teste = C
# Calcular desvio 
epsilon = 0.1; 
Gama = [0.0, 1.0, 2.0, 3.0, 4.0] 
tipo = "sb"
#gama = 2.0
ca_desvio,cb_desvio=calcular_desvios(ca::Matrix{Int64},cb::Matrix{Int64},epsilon::Float64)

resultados_m1 = DataFrame()
resultados_m2 = DataFrame()




for model in Modelos
        println("Testando modelo: $model")
        for variacao in Variacoes
                println("Testando variação: $variacao")
                for gama in Gama
                        println("Testando Gama: $gama")
                        gama_a, gama_b = cria_vetor_gama(ca::Matrix{Int64},
                                                         cb::Matrix{Int64},
                                                         gama::Float64
                                                        )
                        
                        if model == "RGP_1.jl"
                                println("Executando RGP1 com variação $variacao")
                                FO, modelo, tar, sol=robusto_modelo_1(
                                        C_treino::Matrix{Int64},
                                        ca::Matrix{Int64}, 
                                        cb::Matrix{Int64},
                                        alpha::Float64,
                                        ca_desvio::Matrix{Float64},
                                        cb_desvio::Matrix{Float64},
                                        gama_a::Vector{Float64},
                                        gama_b::Vector{Float64}, 
                                        variacao::String
                                )
        
                                metrica = calcular_metricas(
                                        modelo::Model, 
                                        C_teste::Matrix{Int64},
                                        sol::Vector{Float64},
                                        tar::Float64,
                                        y_real::Vector{Int64},
                                        model::String,
                                        variacao::String,
                                        tipo::String,
                                        gama::Float64,
                                        epsilon::Float64
                                        
                                )        # Verificar e atualizar tabela de resultados para o Modelo 1
                                global resultados_m1
                                if typeof(metrica) == DataFrame
                                    resultados_m1 = vcat(resultados_m1, metrica)
                                else
                                    println("Erro: `metricas` não é um DataFrame válido.")
                                end
                                

                        elseif model == "RGP_2.jl"
                                println("Executando RGP2 com variação $variacao")
                                FO, modelo, tar, sol=robusto_modelo_2(
                                        C_treino::Matrix{Int64},
                                        ca::Matrix{Int64},
                                        cb::Matrix{Int64},
                                        alpha::Float64,
                                        beta::Float64,
                                        ca_desvio::Matrix{Float64},
                                        cb_desvio::Matrix{Float64},
                                        gama_a::Vector{Float64},
                                        gama_b::Vector{Float64},
                                        variacao::String
                                )
                                
                                classes= calcular_classes(
                                        modelo::Model,
                                        C_teste::Matrix{Int64},
                                        sol::Vector{Float64},
                                        tar::Float64,
                                        y_real::Vector{Int64},
                                        model::String,
                                        variacao::String,
                                        tipo::String,
                                        gama::Float64,
                                        epsilon::Float64,beta::Float64
                                ) 
                                            
                                    # Verificar e atualizar tabela de resultados para o Modelo 1
                                global resultados_m2
                                if typeof(classes) == DataFrame
                                        resultados_m1 = vcat(resultados_m2, classes)
                                else
                                        println("Erro: `metricas` não é um DataFrame válido.")
                                end
                        end
                end
                        
                     
        
        
        
        
        end 
end         




