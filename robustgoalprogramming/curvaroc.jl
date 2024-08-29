# Arquivo principal do modelo Robusto 
# Nome: Ricardo Soares Oliveira
# Data: 28/Agosto/2024 

using  ROCAnalysis
using Plots 

function plotar_curva(C,y_real,sol,tar)
    # calulcar o y_predito 
    # Calcular o hiperplano 
    c = Matrix(C); 
    y_predito = c * sol; 
    y_pred = y_predito .>= tar;
    println("y_predito :", y_pred)
    println(" y_real : ", y_real)

                # Inicializando variáveis para TPR e FPR
    TPR_list = Float64[]
    FPR_list = Float64[]

 # Calcular TP, FP, TN, FN para cada limiar possível (0 e 1)
 for threshold in [0, 1]
     TP = sum((y_pred .== threshold) .& (y_real .== 1))
     FP = sum((y_pred .== threshold) .& (y_real .== 0))
     TN = sum((y_pred .!= threshold) .& (y_real .== 0))
     FN = sum((y_pred .!= threshold) .& (y_real .== 1))
    
     TPR = TP / (TP + FN)
     FPR = FP / (FP + TN)
    
     push!(TPR_list, TPR)
     push!(FPR_list, FPR)
 end

    # Adicionar ponto (0,0) e (1,1) para a curva
    pushfirst!(TPR_list, 0.0)
    pushfirst!(FPR_list, 0.0)
    push!(TPR_list, 1.0)
    push!(FPR_list, 1.0)

    # Plotar a curva ROC
    plot(FPR_list, TPR_list, marker = :circle, xlabel = "False Positive Rate", ylabel = "True Positive Rate", title = "Curva ROC", legend = false)
    plot!(x -> x, linestyle = :dash, label = "Baseline")  # Linha da base (y=x)



    
end 

