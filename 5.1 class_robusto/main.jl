# Modelo Programa Principal 
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

using Printf
using Statistics
using DataFrames
using CSV
using Tables 


#.........................................................
#        Prâmetros -> (Tomador de Decisão)
#.........................................................
alpha = 1.0;
beta =  1.00; 
proporcao_treino = 0.70;

# porcentagem de incerteza 
#Epsilons = [0.0, 0.05 , 0.10, 0.20, 0.50];
Epsilons = [0.10];

# número de colunas em cada linha sujeito a incerteza   
#Gamas =   [0.0 ,3.0, 5.0, 7.0, 10.0];
Gamas =   [0.0];  
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
                    
                    # Calcular as matrizes A de desvio 
                    ca_desvio, cb_desvio = calcular_desvios(ca::DataFrame,
                                                            cb::DataFrame,
                                                            epsilon::Float64)

                    # cria vetor gama 
                    gama_a, gama_b = cria_vetor_gama(ca::DataFrame,
                                                     cb::DataFrame,
                                                     gama::Float64)
                                      
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

CSV.write("resultados_m1.csv", resultados_m1)
CSV.write("resultados_m2.csv", resultados_m2)

#=
# Função para criar um novo arquivo Excel e adicionar uma aba com o DataFrame
function criar_novo_arquivo_excel(df::DataFrame, arquivo::String, aba::String)
    println("Criando um novo arquivo Excel: $arquivo, aba: $aba")

    # Abre um novo arquivo no modo de escrita
    XLSX.openxlsx(arquivo, mode="w") do xls
        # Adiciona a nova aba
        XLSX.addsheet!(xls, aba)
        
        # Converte o DataFrame para um formato compatível com XLSX e escreve na aba
        println("Escrevendo DataFrame na aba `$(aba)`...")
        XLSX.writetable!(xls[aba], Tables.columntable(df))
    end
end

# Exemplo de uso
criar_novo_arquivo_excel(resultados_m1, "Resultados_Novo_1.xlsx", "Resultados_M1")
criar_novo_arquivo_excel(resultados_m2, "Resultados_Novo_2.xlsx", "Resultados_M2")





# Função para adicionar uma aba a um arquivo Excel existente ou criar um novo arquivo se não existir
function adicionar_aba_excel(df::DataFrame, arquivo::String, aba::String)
    println("Tentando adicionar aba `$(aba)` ao arquivo: $arquivo")

    # Verifica se o arquivo já existe
    if isfile(arquivo)
        # Abre o arquivo existente
        XLSX.openxlsx(arquivo, mode="rw") do xls
            # Verifica se a aba já existe
            sheet_exists = aba in XLSX.sheetnames(xls)
            
            if sheet_exists
                println("Aba `$(aba)` já existe. Sobrescrevendo conteúdo...")
            else
                println("Aba `$(aba)` não existe. Adicionando nova aba...")
                # Adiciona a nova aba
                XLSX.addsheet!(xls, aba)
            end
            # Converte o DataFrame para um formato compatível com XLSX e escreve na aba
            println("Escrevendo DataFrame na aba `$(aba)`...")
            XLSX.writetable!(xls[aba], Tables.columntable(df))
        end
    else
        # Cria um novo arquivo
        println("Arquivo `$(arquivo)` não encontrado. Criando um novo arquivo...")
        XLSX.openxlsx(arquivo, mode="w") do xls
            # Adiciona a nova aba
            XLSX.addsheet!(xls, aba)
            # Converte o DataFrame para um formato compatível com XLSX e escreve na aba
            println("Escrevendo DataFrame na aba `$(aba)`...")
            XLSX.writetable!(xls[aba], Tables.columntable(df))
        end
    end
end

# Exemplo de uso
adicionar_aba_excel(resultados_m1, "Resultados_Existente.xlsx", "Resultados_M1")
adicionar_aba_excel(resultados_m2, "Resultados_Existente.xlsx", "Resultados_M2")

=# 