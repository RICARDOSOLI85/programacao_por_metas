# Arquivo principal do modelo Robusto 
# Nome: Ricardo Soares Oliveira
# Data: 27/Agosto/2024 

#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha =1.0;
beta = 0.50; 
Epsilons = [0.10, 0.20, 0.30];  
Gammas = [1.0, 3.0, 5.0, 7.0, 10.0]; 
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
arquivo="exames.csv"  
df = ler_arquivo(arquivo::String)
C_teste, df_treino, df_teste, y_real = dividir_dados(df::DataFrame, proporcao_treino::Float64)

# selecionar categorias A e B 
C_treino, ca_filtro, cb_filtro = dividir_categorias(df_treino::DataFrame)

# balancear as categorias A = B 
ca_balanceado, cb_balanceado= balancear_categorias(ca_filtro::DataFrame, cb_filtro::DataFrame)

#----------------------------------------------------------
#     Implementar o Modelos e imprimir as soluções  
#----------------------------------------------------------
include("matrizes.jl")
include("gama.jl")
include("RPG_1A.jl")
include("RPG_1B.jl")
include("RPG_1C.jl")
include("RPG_1D.jl")
include("metricas.jl")

# Lista de Modelos 
Set_Model_1 = ["RPG_1A.jl", "RPG_1B.jl", "RPG_1C.jl", "RPG_1D.jl"]

# teste para configuração : Filtro e balanceado
for (ca,cb, modelo_nome) in [(ca_filtro,cb_filtro,"(sb)"),
    (ca_balanceado,cb_balanceado,"(cb)")]
    println(" configuração para $modelo_nome")
    
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
                prinln("Excecutando o $model_name")

                # Modelo 1 A 
                
                if model_name == "RPG_1A.jl"
                    C = C_treino; 
                    global  FO, modelo, tar, sol = robusto_modelo1(C::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            C = C_teste 
                            calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
                            modelo::Model,tar::Float64,sol::Vector{Float64},model_name::String,
                            epsilon::Float64,modelo_nome::String)

                # Modelo 1 B            

                elseif model_name == "RPG_1B.jl"
                    C = C_treino; 
                    global  FO, modelo, tar, sol = robusto_modelo2(C::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            C = C_teste 
                            calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
                            modelo::Model,tar::Float64,sol::Vector{Float64},model_name::String,
                            epsilon::Float64,modelo_nome::String)

                # Modelo 1 C 

                elseif model_name == "RPG_1C.jl"
                    C = C_treino; 
                    global  FO, modelo, tar, sol = robusto_modelo3(C::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            C = C_teste 
                            calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
                            modelo::Model,tar::Float64,sol::Vector{Float64},model_name::String,
                            epsilon::Float64,modelo_nome::String)

               # Modelo 1 D

                elseif model_name == "RPG_1D.jl"
                    C = C_treino; 
                    global  FO, modelo, tar, sol = robusto_modelo4(C::DataFrame,ca::DataFrame,
                            cb::DataFrame,alpha::Float64,
                            ca_desvio::Matrix{Float64},cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},gama_b::Vector{Float64})

                # Imprimir os resultados do Modelo Robusto e salvar
                            C = C_teste 
                            calcular_metricas(C::DataFrame,y_real::DataFrame,gama::Float64,
                            modelo::Model,tar::Float64,sol::Vector{Float64},model_name::String,
                            epsilon::Float64,modelo_nome::String)
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