# Arquivo principal do modelo Robusto 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 

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

#----------------------------------------------------------
#     Implementar o Modelos e imprimir as soluções  
#----------------------------------------------------------

include("gama.jl")
include("RPG_1A.jl")
include("RPG_1B.jl")
include("RPG_1C.jl")
include("RPG_1D.jl")
include("classes.jl")
include("matrizes.jl")
include("Metricas.jl")

#=

# Lista de Modelos 
Set_model_1 = ["RGP_1A.jl", "RGP_1B.jl", "RGP_1C.jl", "RGP_1D.jl"]


# teste para configuração : Filtro e balanceado
for (ca,cb, tipo) in [(ca_filtro,cb_filtro,"(sb)"),
    (ca_balanceado,cb_balanceado,"(cb)")]
    println(" configuração para $tipo")  # mudei para tipo ****
    
    # ϵ : implementar o modelo para cada valor de (Epsilon)
    for epsilon in Epsilons
        println(" Teste do modelo para epsilon = $epsilon")
        
        # configurar o conjunto de dados  
        #global  ca = ca;
        #global  cb = cb;  
        
        # Γ:   implementar o modelo para cada valor de (Gamma)
        for gama in Gammas
            println(" Testando o modelo para gama = $gama")   
            
            # Criar as matrizes dos desvios 
            global  ca_desvio, cb_desvio = calcular_desvios(ca::DataFrame,cb::DataFrame,epsilon::Float64)

            # Criar os vetores Γ (Gamma) sujeitas a incerteza em cada linha
            global gama_a, gama_b = cria_vetor_gama(ca::DataFrame,cb::DataFrame,gama::Float64)

            # Implementar o modelo Robusto de Goal Programming
            # Para as quatro categorias A,B,C, e D 
            for model_name in Set_model_1
                println("Excecutando o $model_name")

                # Modelo 1 A 
                
                if model_name == "RGP_1A.jl"
                    global  FO, modelo, tar, sol = robusto_modelo1(C_treino::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            calcular_metricas(modelo::Model, C_teste::DataFrame,
                            sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                            model_name, gama::Float64,epsilon::Float64,tipo::String)

                # Modelo 1 B            

                elseif model_name == "RGP_1B.jl"
                    global  FO, modelo, tar, sol = robusto_modelo2(C_treino::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            calcular_metricas(modelo::Model, C_teste::DataFrame,
                            sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                            model_name, gama::Float64,epsilon::Float64,tipo::String)

                # Modelo 1 C 

                elseif model_name == "RGP_1C.jl"
                            global  FO, modelo, tar, sol = robusto_modelo3(C_treino::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                           calcular_metricas(modelo::Model, C_teste::DataFrame,
                           sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                           model_name, gama::Float64,epsilon::Float64,tipo::String)

               # Modelo 1 D

                elseif model_name == "RGP_1D.jl"
                            global  FO, modelo, tar, sol = robusto_modelo4(C_treino::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            calcular_metricas(modelo::Model, C_teste::DataFrame,
                            sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                            model_name, gama::Float64,epsilon::Float64,tipo::String)
                end

               

                println("Resultado para gama = $gama e epsilon = $epsilon: Função Objetivo = $FO\n")
            end     
           
        end 
    end 
end


#= 


gama = 1.0     
ca_desvio, cb_desvio = calcular_desvios(ca::DataFrame,cb::DataFrame,epsilon::Float64)
gama_a, gama_b = cria_vetor_gama(ca::DataFrame,cb::DataFrame,gama::Float64)
C = C_treino
FO, modelo, tar, sol = robusto_modelo1(C::DataFrame,ca::DataFrame,
    cb::DataFrame,alpha::Float64,
    ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
    gama_a::Vector{Float64},gama_b::Vector{Float64})

model_name ="Modelo_1A.Robusto_sb"
C = C_teste 
calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
    modelo::Model,tar::Float64,sol::Vector{Float64},
    model_name::String)

 ##    
# Exemplo 
C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 
=#
=# 
using CSV
using DataFrames

# Definir listas para armazenar os resultados
resultados_tabela1 = []
resultados_tabela2 = []

# Lista de Modelos
Set_model_1 = ["RGP_1A.jl", "RGP_1B.jl", "RGP_1C.jl", "RGP_1D.jl"]

for (ca, cb, tipo) in [(ca_filtro, cb_filtro, "(sb)"), (ca_balanceado, cb_balanceado, "(cb)")]
    println("configuração para $tipo")
    
    for epsilon in Epsilons
        println("Teste do modelo para epsilon = $epsilon")
        
        for gama in Gammas
            println("Testando o modelo para gama = $gama")
            
            global ca_desvio, cb_desvio = calcular_desvios(ca::DataFrame, cb::DataFrame, epsilon::Float64)
            global gama_a, gama_b = cria_vetor_gama(ca::DataFrame, cb::DataFrame, gama::Float64)

            for model_name in Set_model_1
                println("Executando o $model_name")

                if model_name == "RGP_1A.jl"
                    global FO, modelo, tar, sol = robusto_modelo1(C_treino::DataFrame, ca::DataFrame,
                            cb::DataFrame, alpha::Float64,
                            ca_desvio::Matrix{Float64}, cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64}, gama_b::Vector{Float64})

                elseif model_name == "RGP_1B.jl"
                    global FO, modelo, tar, sol = robusto_modelo2(C_treino::DataFrame, ca::DataFrame,
                            cb::DataFrame, alpha::Float64,
                            ca_desvio::Matrix{Float64}, cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64}, gama_b::Vector{Float64})

                elseif model_name == "RGP_1C.jl"
                    global FO, modelo, tar, sol = robusto_modelo3(C_treino::DataFrame, ca::DataFrame,
                            cb::DataFrame, alpha::Float64,
                            ca_desvio::Matrix{Float64}, cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64}, gama_b::Vector{Float64})

                elseif model_name == "RGP_1D.jl"
                    global FO, modelo, tar, sol = robusto_modelo4(C_treino::DataFrame, ca::DataFrame,
                            cb::DataFrame, alpha::Float64,
                            ca_desvio::Matrix{Float64}, cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64}, gama_b::Vector{Float64})
                end

                # Calcular métricas e adicionar aos DataFrames
                df_metricas = calcular_metricas(modelo::Model, C_teste::DataFrame,
                                                sol::Vector{Float64}, tar::Float64, y_real::DataFrame,
                                                model_name, gama::Float64, epsilon::Float64, tipo::String)
                
                #append!(resultados_tabela1, df_metricas)
                #append!(resultados_tabela2, df_metricas[!, [:Modelo, :Tipo, :Epsilon, :Gama, :Taxa_Acerto_Pos, :Taxa_Erro_Pos, :Taxa_Acerto_Neg, :Taxa_Erro_Neg, :Acuracia, :F1_Score]])
                resultados_tabela1 = DataFrame()
                resultados_tabela2 = DataFrame()

                # Suponha que `resultados_tabela1` e `resultados_tabela2` sejam DataFrames
                resultados_tabela1 = vcat(resultados_tabela1, df_metricas)

                # Para adicionar apenas colunas específicas do df_metricas
                resultados_tabela2 = vcat(resultados_tabela2, df_metricas[!, [:Modelo, :Tipo, :Epsilon, :Gama, :Taxa_Acerto_Pos, :Taxa_Erro_Pos, :Taxa_Acerto_Neg, :Taxa_Erro_Neg, :Acuracia, :F1_Score]])

                println("Resultado para gama = $gama e epsilon = $epsilon: Função Objetivo = $FO\n")
            end
        end
    end
end

# Criar DataFrames para as tabelas
df_tabela1 = DataFrame(resultados_tabela1)
df_tabela2 = DataFrame(resultados_tabela2)

# Salvar as tabelas em arquivos CSV
CSV.write("tabela1.csv", df_tabela1)
CSV.write("tabela2.csv", df_tabela2)
