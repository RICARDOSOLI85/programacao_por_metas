# Modelo Robusto  para Problema de Classificação
# Data: 22/ Agosto/2024
# Nome: Ricardo Soares Oliveira 

function calcular_metricas(C,x,xo,y_real)
    n = length(x)
    w = zeros(n)
    wo = JuMP.value(xo)
    
    for j=1:n 
        w[j] = JuMP.value(x[j])
    end 

    w = [w[j] for j in 1:n]

    # Calcular o Hiperplano 
    c = Matrix(C)
    y_modelo = c * w 
    y_predito = y_modelo .>= wo 
    y_pred    = y_modelo .== wo 
    println("y_predito = ", y_predito)
    println(" y_true    = ",  y_real)
    println("y_pred    = ", y_pred )

    # Calculando TP, FN, FP,TN 
    TP = sum((y_real .==1) .& (y_predito .==1))
    FN = sum((y_real .==1) .& (y_predito .==0))
    FP = sum((y_real .==0) .& (y_predito .==1))
    TN = sum((y_real .==0) .& (y_predito .==0))

    
    # Erros de classe e indefinido 
    ERc1 = sum((y_real .==1) .& (y_pred .==1))
    ERc2 = sum((y_real .==0) .& (y_pred .==1))
    Indef = ERc1+ERc2 

    # Correção do Falso Positivo 
    FPc = FP - ERc2 

    # Calcular a Acurácia 
    accuracy = (TP + TN) / (TP + FN + FPc +TN)

    # Calculando precisão de Recall 
    precision = TP / (TP + FPc)
    recall = TP / (TP + FN)

    # Calcular F1 Score 

    f1_score  = 2 * (precision * recall) / (precision + recall)

    # Imprimindo os resultados 
    println("=============================================================")
    println("                      Teste do Modelo GP_1                   ")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Hiperlano       = ",  wo)
    println("--------------------------------------------------------------")
    println("                    Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
    println("---------------------------------------------------------------")
    #println("False Negative (FN)  =  ", FN)
    #println("False Positive (FP)  = ", FP) 
    #println("True Negative  (TN)  = ", TN)
    println("----------------------------")
    println("Erro Classe A = ", ERc1)
    println("Erro Classe B = ", ERc2)
    println("Indefindos    = ", Indef)
    println("Falso Positivo Correto = ", FPc)
    println("----------------------------")
    println("Acurácia    =  ", accuracy)
    println("precision   =  " , precision)
    println("recall      =  ", recall)
    println("F1Score     =  ", f1_score)
    println("==================================================================")

    # Salvando os resultados em um arquivo de texto
    open("resultados_teste1.txt", "w") do file
    write(file," =============================================================== \n")
    write(file,"                     Teste do Modelo GP_1                        \n")
    write(file," =============================================================== \n")
    write(file," \n")
    write(file,"Função Objetivo = $FO\n")
    write(file,"hiperplano      = $xo\n")
    write(file,"---------------------------------------------------------------\n")
    write(file,                        "Matriz de Confusão                     \n")
    write(file,"--------------------------------------------------------------- \n")   
    write(file, "|| True Positive (TP) = $TP  | False Negative (FN) = $FN ||\n")
    write(file, "|| False Positive (FP) = $FP | True Negative (TN) = $TN  ||\n")
    write(file,"--------------------------------------------------------------- \n")   
    write(file,"-----------------------------\n")
    write(file,"Erro Classe A =  $ERc1\n")
    write(file, "Erro Classe B =  $ERc2\n")
    write(file,"Indefindos    =  $Indef\n") 
    write(file,"Falso Positivo Correto = $FPc\n") 
    write(file,"-----------------------------\n")
    write(file, "Acurácia   = $accuracy\n")
    write(file,"precision   = $precision\n") 
    write(file,"recall      = $recall\n") 
    write(file, "F1Score    = $f1_score\n")
    write(file,"=======================================================\n")
    end 
end









