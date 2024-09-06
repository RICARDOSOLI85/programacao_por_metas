# Modelo Programa Principal 
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

using Printf
using Statistics
using DataFrames
using XLSX: eachtablerow, readxlsx, writetable 
using Tables 


#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha = 1.0;
beta =  1.00; 
proporcao_treino = 0.70;

# porcentagem de incerteza 
Epsilons = [0.0] # 0.05 , 0.10, 0.20, 0.50];

# número de colunas em cada linha sujeito a incerteza   
Gamas =   [0.0] # ,3.0, 5.0, 7.0, 10.0]; 
#----------------------------------------------------------
#     Leitura e Processamento dos dados 
#----------------------------------------------------------

# 1. dados
include("dados.jl")
arquivo="exames.csv"  
data = ler_arquivo(arquivo::String)

# 2. dividir
include("divisao.jl") 
C_teste, df_treino, df_teste, y_real = dividir_dados(data::DataFrame, proporcao_treino::Float64)

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

# Inicializa tabelas vazias para armazenar resultados (*)
resultados_m1 = DataFrame()
resultados_m2 = DataFrame()



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
                    #println("DataFram resultados m1 ", resultados_m1)
                    #println("DataFram resultados m2 ", resultados_m2)

                   
                    # Modelo 1 
                    if model == "RGP_1.jl"
                        println("Implementando o modelo $model.$variacao($tipo)")
                        FO, modelo, tar, sol =robusto_modelo_1(
                            C_treino::DataFrame,
                            ca::DataFrame,
                            cb::DataFrame,
                            alpha::Float64,
                            ca_desvio::Matrix{Float64},
                            cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},
                            gama_b::Vector{Float64},
                            variacao::String
                        )

                        # metricas do modelo 1
                        println("Calculando as métricas do $model.$variacao($tipo)")
                        metricas = calcular_metricas(
                            modelo::Model, 
                            C_teste::DataFrame,
                            sol::Vector{Float64},
                            tar::Float64,
                            y_real::DataFrame,
                            model::String,
                            variacao::String,
                            tipo::String,
                            gama::Float64,
                            epsilon::Float64
                        )
                        
                        # Verificar e atualizar tabela de resultados para o Modelo 1
                        global resultados_m1
                        if typeof(metricas) == DataFrame
                            resultados_m1 = vcat(resultados_m1, metricas)
                        else
                            println("Erro: `metricas` não é um DataFrame válido.")
                        end

                                           
                    # Modelo 2 
                    elseif model == "RGP_2.jl"
                        println("Implementando o modelo $model.$variacao($tipo)")
                        FO, modelo, tar, sol = robusto_modelo_2(
                            C_treino::DataFrame,
                            ca::DataFrame,
                            cb::DataFrame,
                            alpha::Float64,
                            beta::Float64,
                            ca_desvio::Matrix{Float64},
                            cb_desvio::Matrix{Float64},
                            gama_a::Vector{Float64},
                            gama_b::Vector{Float64},
                            variacao::String
                        )

                        # metricas do modelo 2
                        println("Calculando as métricas do $model.$variacao($tipo)") 
                        classes = calcular_classes(
                            modelo::Model,
                            C_teste::DataFrame,
                            sol::Vector{Float64},
                            tar::Float64,
                            y_real::DataFrame,
                            model::String,
                            variacao::String,
                            tipo::String,
                            gama::Float64,
                            epsilon::Float64,
                            beta::Float64
                        )

                        # Verificar e atualizar tabela de resultados para o Modelo 2
                        global resultados_m2
                        if typeof(classes) == DataFrame
                            resultados_m2 = vcat(resultados_m2, classes)
                        else
                            println("Erro: `classes` não é um DataFrame válido.")
                        end

                    end               
                end
            end
        end
    end
end  



function salvar_dataframe_excel(df::DataFrame, arquivo::String, aba::String)
    println("Tentando salvar o DataFrame em $arquivo, aba: $aba")

    XLSX.openxlsx(arquivo, mode="rw") do xls
        # Verifica se a aba já existe
        sheet_exists = aba in XLSX.sheetnames(xls)
        
        if sheet_exists
            println("Aba `$(aba)` já existe. Sobrescrevendo conteúdo...")
        else
            println("Aba `$(aba)` não existe. Adicionando nova aba...")
            # Se a aba não existe, adiciona uma nova aba
            XLSX.addsheet!(xls, aba)
        end

        # Converte o DataFrame para um formato compatível com XLSX e escreve na aba
        println("Escrevendo DataFrame na aba `$(aba)`...")
        XLSX.writetable!(xls[aba], Tables.columntable(df))
    end
end

# Exemplo de uso
salvar_dataframe_excel(resultados_m1, "Resultados_Modelo_1.xlsx", "Resultados_M1")
salvar_dataframe_excel(resultados_m2, "Resultados_Modelo_2.xlsx", "Resultados_M2")












#=
# Salva os resultados em arquivos Excel separados para cada modelo (****)
XLSX.open("Resultados_Modelo_1.xlsx", mode="w") do xls
    XLSX.write(xls, "Resultados", resultados_m1)
end

XLSX.open("Resultados_Modelo_2.xlsx", mode="w") do xls
    XLSX.write(xls, "Resultados", resultados_m2)
end
# criando a tabela de resultados (***)
                        # Atualiza tabela de resultados para o Modelo 2
                        #resultados_m2 = vcat(resultados_m2, classes)
                        #atualiza_tabela_classe!(resultados_m2,classes,model,variacao,tipo,gama,epsilon)

 # criando a função para atualziar a tabela de resultados (***)
                        # Atualiza tabela de resultados para o Modelo 1
                        #resultados_m1 = vcat(resultados_m1, metricas)
                        #atualizar_tabela_classe!(resultados_m1, metricas, gama, epsilon)
                        #function atualizar_tabela_classe!(df::DataFrame, metricas::DataFrame, gama::Float64, epsilon::Float64)
                            # adiciona uma nova linha ao data frame com os valores atualziados
                        #    new_row = DataFrame(metricas=metricas, gama=gama,epsilon=epsilon)
                        #    append!(df,new_row)
                        #end                         

=#
