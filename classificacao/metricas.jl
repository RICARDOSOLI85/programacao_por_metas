# Modelo Robusto  para Problema de Classificação
# Data: 22/ Agosto/2024
# Nome: Ricardo Soares Oliveira 

function calcular_metricas(modelo,C,x,xo,y_real,beta)
    
    n = length(x);
    w = x;
    wo = xo;
         
    # 0. Calcular o Hiperplano 
    c = Matrix(C);
    y_modelo = c * w 
    println("vetor hiperplano =" , y_modelo)  

    # 0.1 Tranformar o data frame y_real em vector (importante)
    ##y_real = Matrix(y_real)
    
    # 1.0 Métricas 

    println(".......................................................")
    println("                        Métricas                       ")
    println(".......................................................") 
    
    y_predito = y_modelo .>= wo 
    y_real .== y_real 
    # y_pred : Estou selecionando todos que estão no hiperplano 
    y_pred    = y_modelo .== wo 
    println("y_predito = ", y_predito)
    println("y_real    = ",  y_real)
    println("y_pred    = ", y_pred )
     
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
    println("Soma = ", Soma)

    # 2.2 Correção do Falso Positivo 
    FPc = FP - ERc2 
    println("Falso Positivo Correto = ", FPc)

    # 3. Taxa Positivo acerto/erro  
    TPA = TP  /(TP + FN)
    TPE = FN / (TP + FN)
    println("Taxa Positivo acerto = ", TPA)
    println("Taxa Positivo erro  = ",   TPE)

    # 4. Taxa Indefinidos Positivo/Negativo : sobre o hiperplano 
    TIP = ERc1 / (ERc1 + ERc2) 
    TIN = Erc2 / (ERc1 + ERc2)
    println("Taxa Positivo acerto = ",  TIP)
    println("Taxa Positivo erro  = ",   TIN) 

     # 5. Taxa Negativo Acerto Erro  
     TNA = TN  /(TN + FP)
     TNE = FP / (FP + TN)
     println("Taxa Positivo acerto = ", TNA)
     println("Taxa Positivo erro  = ",   TNE)


    println("............................................")
    println("     Taxa de Acerto  |  Taxa de Erro ")
    println(" Positivo  : ",   TPA, " |       " , TPE)
    println("Indefinido P/N  : ",   TIP, " |       " , TIN)
    println(" Negativo : ",   TNA, " |       " , TNE)



    
    # 4 Medidas de precisão 
    # Calcular a Acurácia (Optei por retirar FPc da acc e prec)
    accuracy = (TP + TN) / (TP + FN + FP +TN)
    accuracy = round(accuracy, digits=2)

    # Calculando precisão de Recall 
    precision = TP / (TP + FP)
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
    println("---------Impressão dados de Entrada--------")
    println("Alpha = ", alpha)
    println("Conj. treino (n)  = ", m)
    println("Dados de Teste    = ", n1+n2)
    println("Positivos CA (n1) = ", n1)
    println("Negativos CB (n2) = ", n2)
    println("------------------------------------------------")
  
    println("----------------------------")
    println("Erro Classe A = ", ERc1)
    println("Erro Classe B = ", ERc2)
    println("Indefindos    = ", Indef)
    println("Falso Positivo Correto = ", FPc)
    println("----------------------------")
     println("----------------------------")
    println("Acurácia    =  ", accuracy)
    println("precision   =  " , precision)
    println("recall      =  ", recall)
    println("F1Score     =  ", f1_score)
    println("========================================================")
    # Salvando os resultados em um arquivo de texto
    open("resultados_teste1.txt", "w") do file
    write(file," =============================================================== \n")
    write(file,"                     Teste do Modelo GP_1 : A             \n")
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
    write(file,"----------------------------\n")
    write(file,"-----------------------------\n")
    write(file, "accuray     = $accuracy\n")
    write(file,"precision   = $precision\n") 
    write(file,"recall      = $recall\n") 
    write(file, "F1Score     = $f1_score\n")
    write(file,"*****************************************************\n")
  end 
    
end








