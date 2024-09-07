# Métricas para o resultado do modelo
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

using DataFrames
using JuMP
using Printf
using Statistics
using DataFrames

function calcular_metricas(modelo::Model, 
    C_teste::Matrix{Int64},
    sol::Vector{Float64},
    tar::Float64,
    y_real::Vector{Int64},
    model::String,
    variacao::String,
    tipo::String,
    gama::Float64,
    epsilon::Float64)


    n = length(sol);
    solucao = sol;
    target = tar;
    C = C_teste;
    media = mean(solucao);

    # Calcular o hiperplano 
    c = Matrix(C);
    y_modelo = c * solucao;

    # Transformar o DataFrame em vetor
    #y_real = Matrix(y_real);

    # Status da solução 
    FO = objective_value(modelo)
    FO = round(FO, digits=2)
    status = termination_status(modelo)
    time = solve_time(modelo)
    time = round(time, digits=4)
    nv = num_variables(modelo)
   

    # Imprimindo os resultados 
    println("=============================================================")
    println("Resultados: modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Hiperplano       = ", target)
    println("Status = ", status)
    println("Média das variáveis = ", media)   
    println("Time  = ", time)
    println("N variáveis  = ", nv)


    # Métricas TP, FN, FP, TN 
    y_pred_ca = y_modelo .>= target;
    y_pred_cb = y_modelo .<= target;

    TP = sum((y_real .== 1) .& (y_pred_ca .== 1))
    FN = sum((y_real .== 1) .& (y_pred_ca .== 0))
    FP = sum((y_real .== 0) .& (y_pred_cb .== 0))
    TN = sum((y_real .== 0) .& (y_pred_cb .== 1))

    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN, " ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN)  = ", TN, " ||")
    println("--------------------------------------------------------------")

    # Taxa Positivo acerto/erro  
    TPA = TP / (TP + FN)
    TPE = FN / (TP + FN)
    TPA = round(TPA, digits=2)
    TPE = round(TPE, digits=2)

    # Taxa Negativo Acerto Erro  
    TNA = TN / (TN + FP)
    TNE = FP / (FP + TN)
    TNA = round(TNA, digits=2)
    TNE = round(TNE, digits=2)

    println("............................................")
    println("   Taxa de Acerto |  Taxa de Erro ")
    println(" Positivo   : ", TPA, "  |    ", TPE)
    println(" Negativo   : ", TNA, "  |    ", TNE)
    println("............................................")

    # Medidas de precisão 
    accuracy = (TP + TN) / (TP + FN + FP + TN)
    accuracy = round(accuracy, digits=2)

    # Calculando precisão e recall 
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    precision = round(precision, digits=2)
    recall = round(recall, digits=2)

    # Calcular F1 Score 
    f1_score = 2 * (precision * recall) / (precision + recall)
    f1_score = round(f1_score, digits=2)

    println("Acurácia    =  ", accuracy)
    println("Precisão    =  ", precision)
    println("Recall      =  ", recall)
    println("F1Score     =  ", f1_score)

    # Função Interna para construir o DataFrame das métricas
    function construir_dataframe_metricas()
        return DataFrame(
            #.....Parâmetros 
            modelo = model,
            var = variacao,
            tipo = tipo, 
            gama= gama, 
            epsilon= epsilon,
            #....Otimização 
            FuncObj =FO,
            HipePlan = target,
            status = string(status),
            media  = media,
            tempo = time,
            num_variaveis = nv, 
            #.......Matriz Confusão 
            TP = TP,
            FN = FN,
            FP = FP,
            TN = TN, 
            #........Taxas de Acerto
            TPA = TPA,
            TPE = TPE,
            TNA = TNA,
            TNE = TNE, 
            #.........Métricas
            Acurácia = accuracy,
            Precisão = precision,
            Recall = recall, 
            F1_score = f1_score
        )
        
    end
    
    # Salvar em um arquivo TXT
    # Defina o caminho do diretório onde deseja salvar o arquivo
    diretorio = "resultados_modelo_1"
    # Cria o diretório se ele não existir
    mkpath(diretorio)
    filename = joinpath(diretorio,"Tabela:modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon.txt")
    #filename = "Tabela: $(model_name)_$(tipo) (ϵ=$(epsilon),Γ=$(gama)).txt"
    open(filename, "w") do file
        println(file, "========================================")
        println(file, "Solução do modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon")
        println(file, "========================================")
        println(file, "Função Objetivo = ", FO)
        println(file, "Hiperplano       = ", target)
        println(file, "Status = ", status)
        println(file, "Média das variáveis = ", media)
        println(file, "Time  = ", time)
        println(file,"N variáveis  = ", nv)
        println(file, "------------------------------------------------------------")
        println(file, "                    Matriz de Confusão                      ")
        println(file, "|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN, " ||")
        println(file, "|| False Positive (FP)  = ", FP, " | True Negative  (TN)  = ", TN, " ||")
        println(file, "------------------------------------------------------------")
        println(file, "Taxa de Acerto | Taxa de Erro")
        println(file, "Positivo   : ", TPA, " | ", TPE)
        println(file, "Negativo   : ", TNA, " | ", TNE)
        println(file, "Acurácia    =  ", accuracy)
        println(file, "Precisão    =  ", precision)
        println(file, "Recall      =  ", recall)
        println(file, "F1Score     =  ", f1_score)
        println(file, "********************************************")
    end

    # construir e retornar o DataFrame
    metricas = construir_dataframe_metricas()

    return metricas 
end