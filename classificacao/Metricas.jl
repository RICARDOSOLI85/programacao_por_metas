# Modelo Robusto  para Problema de Classificação
# Data: 02/Setembro/2024
# Nome: Ricardo Soares Oliveira 

using Printf
using Statistics 

function calcular_metricas(modelo, C ,x_vals,xo_vals,y_real,model_name)
        
    n =length(x_vals);
    w = x_vals; 
    wo =  xo_vals;
    media = mean(w)
    
         
    # 0. Calcular o Hiperplano 
    c = Matrix(C);
    y_modelo = c * w; 
    #println("vetor hiperplano =" , y_modelo)  

    # 0.1 Tranformar o data frame y_real em vector (importante)
    y_real = Matrix(y_real);
    
    # 1.0 Métricas 

     # Status da solução 
     FO = objective_value(modelo)
     FO = round(FO,digits=2)
     status = termination_status(modelo)
     time = solve_time(modelo)
     time = round(time,digits=4)
     (m,n) = size(C);
     n1 = size(ca,1);
     n2 = size(cb,1)
     
 
     # Imprimindo os resultados 
     println("=============================================================")
     println("                Teste do Modelo    $(model_name) (cb)      ")
     println("=============================================================")
     println("Função Objetivo = ", FO)
     println("Hiperlano       = ",  wo)
     println("Status = ", status)
     println("média das variáveis = " , media)   
     println("Time  = ", time)
    
   
            
    y_pred_ca = y_modelo .>= wo; 
    y_pred_cb = y_modelo .<= wo; 
    y_pred    = y_modelo .==0; 
    #println("y_pred_ca = ", y_pred_ca)
    #println("y_real    = ",  y_real)
    #println("y_pred_cb    = ", y_pred_cb )
    #println("y_pred   = ", y_pred)
     
    # 2. Calculando TP, FN, FP,TN 
    TP = sum((y_real .==1) .& (y_pred_ca .==1))
    FN = sum((y_real .==1) .& (y_pred_ca .==0))
    FP = sum((y_real .==0) .& (y_pred_cb .==0))
    TN = sum((y_real .==0) .& (y_pred_cb .==1))
    IDa = sum((y_real .==1) .& (y_pred .==1))
    IDb = sum((y_real .==0) .& (y_pred .==1))

    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
    println("---------------------------------------------------------------")

       
    # 2.1 Indefinido 
    Soma = TP +FN + FP + TN
    #println("Ind a = ", IDa)
    #println("Ind b = ", IDb)
    #println("Inde = ", IDa +IDb)
    TIP = IDa/(IDa + IDb)
    TIN  = IDb/(IDa+IDb)
    println("Soma          = ", Soma)
    

    # 3. Taxa Positivo acerto/erro  
    TPA = TP  /(TP + FN)
    TPE = FN / (TP + FN)
    TPA = round(TPA, digits=2)
    TPE = round(TPE, digits=2)
    #println("Taxa Positivo acerto = ", TPA)
    #println("Taxa Positivo erro  = ",   TPE)

    
     # 4. Taxa Negativo Acerto Erro  
     TNA = TN  /(TN + FP)   
     TNE = FP / (FP + TN)
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


    println("Acurácia    =  " , accuracy)
    println("precision   =  " , precision)
    println("recall      =  " , recall)
    println("F1Score     =  " , f1_score)

   
    
  
  # Salvar em um arquivo TXT
    # nome do arquivo 
    filename = "Resultados:$(model_name)(cb).txt"
    #filename = "Tabela_$(model_file)_$(balanceamento).txt"
    # abre o arquivo para a escrita 
    open(filename, "w") do file 
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
        println(file,"Função Objetivo = ", FO)
         println(file,"Hiperlano       = ",  wo)
        println(file,"Status = ", status)
        println(file,"média das variáveis = " , media)   
        println(file,"Time  = ", time)
        println(file, "------------------------------------------------------------")
        println(file,"--------------------------------------------------------------")
        println(file,"                    Matriz de Confusão $(model_name)          ")
        println(file,"--------------------------------------------------------------")
        println(file,"|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
        println(file,"|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
        println(file,"---------------------------------------------------------------")
        println("Ind a = ", IDa)
        println("Ind b = ", IDb)
        println("Inde = ", IDa +IDb)
        println("Soma          = ", Soma)
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