# Modelo Robusto  para Problema de Classificação
# Data: 22/ Agosto/2024
# Nome: Ricardo Soares Oliveira 

using Printf

function calcular_metricas(modelo, C, x, xo, y_real, model_name)
    
    
    n = length(x);
    w = x;
    wo = xo;
         
    # 0. Calcular o Hiperplano 
    c = Matrix(C);
    y_modelo = c * w 
    #println("vetor hiperplano =" , y_modelo)  

    # 0.1 Tranformar o data frame y_real em vector (importante)
    y_real = Matrix(y_real)
    
    # 1.0 Métricas 

    
    println("                        Métricas                       ")
    
    
    y_predito = y_modelo .>= wo 
    y_real .== y_real 
    # y_pred : Estou selecionando todos que estão no hiperplano 
    y_pred    = y_modelo .== wo 
    #println("y_predito = ", y_predito)
    #println("y_real    = ",  y_real)
    #println("y_pred    = ", y_pred )
     
    # 2. Calculando TP, FN, FP,TN 
    TP = sum((y_real .==1) .& (y_predito .==1))
    FN = sum((y_real .==1) .& (y_predito .==0))
    FP = sum((y_real .==0) .& (y_predito .==1))
    TN = sum((y_real .==0) .& (y_predito .==0))

    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
    println("---------------------------------------------------------------")

       
    # 2.1 Erros de classe e indefinido 
    # estou tirando com ERc2 a classe B que está no hiperplano
    ERc1 = sum((y_real .==1) .& (y_pred .==1))
    ERc2 = sum((y_real .==0) .& (y_pred .==1))
    Indef = ERc1+ERc2 
    Soma = TP +FN + FP + TN
    
    println("Erro Classe A = ", ERc1)
    println("Erro Classe B = ", ERc2)
    println("Indefindos    = ", Indef)
    println("Soma          = ", Soma)
    

    # 2.2 Correção do Falso Positivo 
    FPc = FP - ERc2 
    Soma_C = TP +FN + FPc + TN 
    println("Falso Positivo Correto = ", FPc)
    println("Soma_C        = ", Soma_C)

    # 3. Taxa Positivo acerto/erro  
    TPA = TP  /(TP + FN)
    TPE = FN / (TP + FN)
    TPA = round(TPA, digits=2)
    TPE = round(TPE, digits=2)
    #println("Taxa Positivo acerto = ", TPA)
    #println("Taxa Positivo erro  = ",   TPE)

    # 4. Taxa Indefinidos Positivo/Negativo : sobre o hiperplano 
    TIP = ERc1 / (ERc1 + ERc2) 
    TIN = ERc2 / (ERc1 + ERc2)
    #println("Taxa Positivo acerto = ",  TIP)
    #println("Taxa Positivo erro  = ",   TIN) 
    TIP = round(TIP, digits=2)
    TIN = round(TIN, digits=2)

     # 5. Taxa Negativo Acerto Erro  
     TNA = TN  /(TN + FPc)   # Falso Positivo C 
     TNE = FPc / (FPc + TN)
     TNA = round(TNA, digits=2)
     TNE = round(TNE, digits=2)
     #println("Taxa Positivo acerto = ", TNA)
     #println("Taxa Positivo erro  = ",   TNE)


    println("............................................")
    println("    Taxa de Acerto |  Taxa de Erro ")
    println(" Positivo   : ",   TPA, "  |    " , TPE)
    println(" Indefinido : ",   TIP, "  |    " , TIN)
    println(" Negativo   : ",   TNA, "  |    " , TNE)
    println("............................................")



    
    # 4 Medidas de precisão 
    # Calcular a Acurácia (Optei por retirar FPc da acc e prec)
    accuracy = (TP + TN) / (TP + FN + FPc +TN)
    accuracy = round(accuracy, digits=2)

    # Calculando precisão de Recall 
    precision = TP / (TP + FPc)
    recall = TP / (TP + FN)
    precision = round(precision, digits=2)
    recall = round(recall, digits=2)

    # Calcular F1 Score 

    f1_score  = 2 * (precision * recall) / (precision + recall);
    f1_score = round(f1_score, digits=2)


    println("Acurácia    =  ", accuracy)
    println("precision   =  " , precision)
    println("recall      =  ", recall)
    println("F1Score     =  ", f1_score)

    # Status da solução 
    FO = objective_value(modelo)
    status = termination_status(modelo)
    time = solve_time(modelo)
    time = round(time,digits=4)
    (m,n) = size(C);
    n1 = size(ca,1);
    n2 = size(cb,1)
    

    # Imprimindo os resultados 
    println("=============================================================")
    println("                      Teste do Modelo GP_1                 ")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Status = ", status)
    println("Time  = ", time)
    println("Hiperlano       = ",  wo)
    
  
  # Salvar em um arquivo TXT
    # nome do arquivo 
    filename = "Tabela_$(model_name)_Cb.txt"
    #filename = "Tabela_Modelo_1_Filtro_Teste.txt"
    # abre o arquivo para a escrita 
    open(filename, "a") do file 
        println(file, "========================================")
        println(file, "Tabela de Resultado das Taxas")
        # Personaliza a saída com base no nome do modelo
        if model_name == "GP_1A.jl"
          println(file, "|---------Modelo 1 A---------|")
        elseif model_name == "GP_1B.jl"
          println(file, "|---------Modelo 1 B---------|")
        end
        if model_name == "GP_1C.jl"
          println(file, "|---------Modelo 1 C---------|")
        elseif model_name == "GP_1D.jl"
          println(file, "|---------Modelo 1 D---------|")
        end  
        println(file, "========================================")
        @printf(file, "Função Objetivo  = %.2f\n", FO)
        println(file,"Status = ", status)
        println(file,"Time  = ", time)
        println(file, "-----------------------------------------")
        println(file,"--------------------------------------------------------------")
        println(file,"                      Matriz de Confusão                        ")
        println(file,"--------------------------------------------------------------")
        println(file,"|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
        println(file,"|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
        println(file,"---------------------------------------------------------------")
        println(file,"Erro Classe A = ", ERc1)
        println(file,"Erro Classe B = ", ERc2)
        println(file,"Indefindos    = ", Indef)
        println(file,"Soma          = ", Soma)
        println(file,"Falso Positivo Correto = ", FPc)
        println(file,"Soma_C        = ", Soma_C)
        println(file,"............................................")
        println(file,"   Taxa de Acerto |  Taxa de Erro ")
        println(file," Positivo   : ",   TPA, " |   " , TPE)
        println(file," Indefinido : ",   TIP, " |    " , TIN)
        println(file," Negativo   : ",   TNA, " |    " , TNE)
        println(file,"............................................")
        println(file,"Acurácia    =  ", accuracy)
        println(file,"precision   =  " , precision)
        println(file,"recall      =  ", recall)
        println(file,"F1Score     =  ", f1_score)
        println(file,"********************************************")
    end 


  
    
end








