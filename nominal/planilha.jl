# Modelo Robusto  para Problema de Classificação
# Data: 31/Agosto/2024
# Nome: Ricardo Soares Oliveira 



using DataFrames
using CSV

function salvar_resultados(metricas::Dict{Any, Any}, filename::String)
    open(filename, "w") do file
        if haskey(metricas, "Função Objetivo")
            write(file, "Função Objetivo: ", metricas["Função Objetivo"], "\n")
        end
        if haskey(metricas, "Solução")
            write(file, "Solução: ", metricas["Solução"], "\n")
        end
        if haskey(metricas, "Hiperplano")
            write(file, "Hiperplano: ", metricas["Hiperplano"], "\n")
        end
        if haskey(metricas, "Matriz de Confusão")
            write(file, "Matriz de Confusão: ", metricas["Matriz de Confusão"], "\n")
        else
            write(file, "Matriz de Confusão: Não disponível\n")
        end
        if haskey(metricas, "Acurácia")
            write(file, "Acurácia: ", metricas["Acurácia"], "\n")
        end
        if haskey(metricas, "Precisão")
            write(file, "Precisão: ", metricas["Precisão"], "\n")
        end
        if haskey(metricas, "Recall")
            write(file, "Recall: ", metricas["Recall"], "\n")
        end
    end
end 

#=

function salvar_resultados(metricas, filename)
    # Verificar e acessar os dados no dicionário corretamente
    matriz_confusao = metricas["Matriz de Confusão"]
    taxa_acerto_erro = metricas["Taxa de Acerto e Taxa de Erro"]
    taxa_acerto_erro_detalhadas = metricas["Taxa de Acerto e Taxa de Erro Detalhadas"]

    df_confusao = DataFrame(
        "Matriz de Confusão" => ["True Positive", "False Negative", "False Positive", "True Negative"],
        "Valor" => [matriz_confusao["True Positive"],
                   matriz_confusao["False Negative"],
                   matriz_confusao["False Positive"],
                   matriz_confusao["True Negative"]]
    )

    df_metricas = DataFrame(
        "Métrica" => ["Acurácia", "Precisão", "Recall", "F1-Score"],
        "Valor" => [metricas["Acurácia"], metricas["Precisão"], metricas["Recall"], metricas["F1-Score"]]
    )

    df_valores = DataFrame(
        "Categoria" => ["Valor Acerto (Def Positivo)", "Valor Erro (Def Positivo)", "Valor Acerto (Pro Positivo)",
                        "Valor Erro (Pro Positivo)", "Taxa Acerto (Indefindos)", "Taxa Erro (Indefindos)",
                        "Valor Acerto (Prob Negativo)", "Valor Erro (Prob Negativo)"],
        "Valor" => [metricas["Valor Acerto (Def Positivo)"], metricas["Valor Erro (Def Positivo)"],
                    metricas["Valor Acerto (Pro Positivo)"], metricas["Valor Erro (Pro Positivo)"],
                    metricas["Taxa Acerto (Indefindos)"], metricas["Taxa Erro (Indefindos)"],
                    metricas["Valor Acerto (Prob Negativo)"], metricas["Valor Erro (Prob Negativo)"]]
    )

    df_taxas = DataFrame(
        "Categoria" => ["Def Positivo", "Pro Positivo", "Indefindos", "Pro Negativo", "Def Negativo"],
        "Taxa Acerto" => [taxa_acerto_erro["Def Positivo"][1],
                          taxa_acerto_erro["Pro Positivo"][1],
                          taxa_acerto_erro["Indefindos"][1],
                          taxa_acerto_erro["Pro Negativo"][1],
                          taxa_acerto_erro["Def Negativo"][1]],
        "Taxa Erro" => [taxa_acerto_erro["Def Positivo"][2],
                        taxa_acerto_erro["Pro Positivo"][2],
                        taxa_acerto_erro["Indefindos"][2],
                        taxa_acerto_erro["Pro Negativo"][2],
                        taxa_acerto_erro["Def Negativo"][2]]
    )

    df_taxas_detalhadas = DataFrame(
        "Categoria" => ["Positivo", "Indefindo", "Negativo"],
        "Taxa Acerto" => [taxa_acerto_erro_detalhadas["Positivo"][1],
                          taxa_acerto_erro_detalhadas["Indefindo"][1],
                          taxa_acerto_erro_detalhadas["Negativo"][1]],
        "Taxa Erro" => [taxa_acerto_erro_detalhadas["Positivo"][2],
                        taxa_acerto_erro_detalhadas["Indefindo"][2],
                        taxa_acerto_erro_detalhadas["Negativo"][2]]
    )

    # Salvar DataFrames em um arquivo CSV
    CSV.write(filename * "_confusao.csv", df_confusao)
    CSV.write(filename * "_metricas.csv", df_metricas)
    CSV.write(filename * "_valores.csv", df_valores)
    CSV.write(filename * "_taxas.csv", df_taxas)
    CSV.write(filename * "_taxas_detalhadas.csv", df_taxas_detalhadas)
end

=# 