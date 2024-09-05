#=
using Printf
using Statistics

function calcular_metricas(modelo::Model, C_teste::DataFrame,
                            sol::Vector{Float64}, tar::Float64,y_real::DataFrame,
                            model_name, gama::Float64,epsilon::Float64,tipo::String)

    n = length(sol)
    w = sol
    wo = tar
    C = C_teste
    media = mean(w)

    # Calcular o hiperplano 
    c = Matrix(C)
    y_modelo = c * w

    # Transformar o DataFrame em vetor
    y_real = Matrix(y_real)

    # Status da solução 
    FO = objective_value(modelo)
    FO = round(FO, digits=2)
    status = termination_status(modelo)
    time = solve_time(modelo)
    time = round(time, digits=4)
    NV = num_variables(modelo)
   

    # Imprimindo os resultados 
    println("=============================================================")
    println("  Resultados: $(model_name) $(tipo) ϵ= $(epsilon) Γ=$(gama)   ")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Hiperplano       = ", wo)
    println("Status = ", status)
    println("Média das variáveis = ", media)   
    println("Time  = ", time)

    # Métricas TP, FN, FP, TN 
    y_pred_ca = y_modelo .>= wo
    y_pred_cb = y_modelo .<= wo

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
    
    # Salvar em um arquivo TXT
    filename = "Tabela: $(model_name)_$(tipo) (ϵ=$(epsilon),Γ=$(gama)).txt"
    open(filename, "w") do file
        println(file, "========================================")
        println(file, "Tabela de Resultado das Taxas")
        println(file, "Modelo: $(model_name)")
        println(file, "========================================")
        println(file, "Função Objetivo = ", FO)
        println(file, "Hiperplano       = ", wo)
        println(file, "Status = ", status)
        println(file, "Média das variáveis = ", media)
        println(file, "Time  = ", time)
        println(file, "------------------------------------------------------------")
        println(file, "Matriz de Confusão $(model_name)")
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
end

=#
using DataFrames
using Printf
using Statistics

function calcular_metricas(modelo::Model, C_teste::DataFrame,
                            sol::Vector{Float64}, tar::Float64, y_real::DataFrame,
                            model_name, gama::Float64, epsilon::Float64, tipo::String)

    #n = length(sol)
    w = sol
    wo = tar
    C = C_teste
    media = mean(w)

    # Calcular o hiperplano
    c = Matrix(C)
    y_modelo = c * w

    # Transformar o DataFrame em vetor
    y_real = Matrix(y_real)

   


    # Métricas TP, FN, FP, TN
    y_pred_ca = y_modelo .>= wo
    y_pred_cb = y_modelo .<= wo

    TP = sum((y_real .== 1) .& (y_pred_ca .== 1))
    FN = sum((y_real .== 1) .& (y_pred_ca .== 0))
    FP = sum((y_real .== 0) .& (y_pred_cb .== 0))
    TN = sum((y_real .== 0) .& (y_pred_cb .== 1))

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

    # Medidas de precisão
    accuracy = (TP + TN) / (TP + FN + FP + TN)
    accuracy = round(accuracy, digits=2)
    
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    precision = round(precision, digits=2)
    recall = round(recall, digits=2)
    
    f1_score = 2 * (precision * recall) / (precision + recall)
    f1_score = round(f1_score, digits=2)

     # Status da solução
     FO = objective_value(modelo)
     FO = round(FO, digits=2)
     status = termination_status(modelo)
     time = solve_time(modelo)
     time = round(time, digits=4)
     NV = num_variables(modelo)
     wo = round(wo,digits=2)
     media = round(media,digits=2)


    # Criar DataFrame para os resultados
    return DataFrame(
        Modelo=[model_name],
        Tipo=[tipo],
        Epsilon=[epsilon],
        Gama=[gama],
        FO=[FO],
        Hiperplano=[wo],
        Media_xj=[media],
        Tempo=[time],
        TP=[TP],
        FN=[FN],
        FP=[FP],
        TN=[TN],
        Precisao=[precision],
        Recall=[recall],
        Taxa_Acerto_Pos=[TPA],
        Taxa_Erro_Pos=[TPE],
        Taxa_Acerto_Neg=[TNA],
        Taxa_Erro_Neg=[TNE],
        Acuracia=[accuracy],
        F1_Score=[f1_score]
    )
end
