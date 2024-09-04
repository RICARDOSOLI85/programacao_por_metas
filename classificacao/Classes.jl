# Modelo Robusto  para Problema de Classificação
# Data: 21/ Agosto/2024
# Nome: Ricardo Soares Oliveira 

using Printf 
using Statistics 

function calcular_classes(FO, modelo , C, x_vals, xo_val, y_real,beta, model_name)

     
    n =length(x_vals);
    w = x_vals; 
    wo =  xo_val;
    media = mean(w)
    
    # 0.  Calcula hiperplano 
    c = Matrix(C);
    #y_modelo = c * x;
    y_modelo = c * w 
    #println("y_modelo =", y_modelo)

     # 0.1 Tranformar o data frame y_real em vector (importante)
    y_real = Matrix(y_real);
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
    println("                      Teste do Modelo                ")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Hiperlano       = ",  wo)
    println("Status = ", status)
    println("média das variáveis = " , media)   
    println("Time  = ", time)
    hiper_up   = wo .+ beta
    hiper_down = wo .- beta 
    println("hiper+beta = ",hiper_up)
    println("hiperplano = ",wo)
    println("hiper-beta = ",hiper_down)


   


    # Parte: A
    # Métricas   

    println(".......................................................")
    println("       Métricas  $(model_name) β $beta(cb)         ")
    println(".......................................................") 
    
    # 1. Definitivamente Positivo
    #    (Maior ou igual a hipeplano + beta)
    y_def_pos = y_modelo .>= (wo + beta);    
    #println("y_definitvo_positivo = ", y_def_pos)
    
    # 2. Provavelmente Positivo
    #    (Menor ao hipeplano + beta e ".&" Maior que hiperplano)
    y_prob_pos = (y_modelo .< wo + beta) .& (y_modelo .> wo);
    #println("y_provavel_positivo = ", y_prob_pos)
        
    # 3. Valores de Y Indefinidos
    # (Sobre o hiperplano )
    y_indef = y_modelo .== wo;
    #println("y_indef = ", y_indef)
    
    # 4. Provavelmente Negativos 
    y_prob_neg =  (y_modelo .< wo) .& (y_modelo .> wo - beta );
    #println("y_prob_neg = ", y_prob_neg)

    # 5. Definitivamente Negativo 
    y_def_neg = y_modelo .<= wo - beta;
    #println("y_def_neg = ", y_def_neg) 

    #---------------------------------------------------------
    # 1. Definitivamente Positivo (valores de acertos e erros)
    DPA = sum((y_real .==1) .& (y_def_pos .==1))
    DPE = sum((y_real .==0) .& (y_def_pos .==1))
    println("Valor Acerto (Def Positivo)  = ", DPA)
    println("Valor Erro   (Def. Positivo) = ", DPE)

    # 2. Provavelmente Positivo (Valores de acertos e erros)
    PPA = sum((y_real .== 1) .& (y_prob_pos .==1))
    PPE = sum((y_real .== 0) .& (y_prob_pos .==1))
    println("Valor Acerto (Prob Positivo) = ", PPA)
    println("Valor Erro   (Prob Positivo) = ",  PPE)

    # 3. Indefinidos (sobre o hiperplano)
    IA = sum((y_real .==1) .& (y_indef .==1))
    IE = sum((y_real .==0) .& (y_indef .==1))
    println("Valores Acerto (Indefinidos) = ", IA)
    println("Valores Erro  (Indefinidos)  = ", IE)

    # 4. Provavelmente Negativos (Valores de acertos e erros)
    PNA = sum((y_real .==0).&(y_prob_neg .==1))
    PNE = sum((y_real .==0) .& (y_prob_neg .==1))

    println("Valor Acerto (Prob Negativo) = ", PNA)
    println("Valor Erro  (Prob Negativo)  = ",  PNE)

    # 5. Definitivamente Negativo (Valores de acertos e erros)
    DNA = sum((y_real .==0) .& (y_def_neg .==1))
    DNE = sum((y_real .==1) .& (y_def_neg .==1))

    println("Valor Acerto (Def Negativo)  = ", DNA)
    println("Valor Erro  (Def Negativo)   = ",  DNE)

    # Calculo das taxas 

    # 1. Taxa Definitivamente Positivo Acerto/Erro  
    TDPA = DPA/(DPA +DPE)
    TDPE = DPE/(DPA +DPE)  
    TDPA = round(TDPA, digits=2)
    TDPE = round(TDPE, digits=2)
    
    # 2. Taxa Provavelmente Positivo Acerto/Erro  
    TPPA = PPA/(PPA + PPE)
    TPPE = PPE/(PPA + PPE)
    TPPA = round(TPPA, digits=2)
    TPPE = round(TPPE, digits=2)
    
    # 3. Taxa dos valores indefinidos 
    TIA = IA /(IA +IE )
    TIE = IE /(IA +IE )
    TIA = round(TIA, digits=2)
    TIE = round(TIE, digits=2)
    
    # 4. Taxa Provavelmente Positivo Acerto/Erro  
    TPNA = PNA / (PNA + PNE)
    TPNE = PNE / (PNA + PNE )
    TPNA = round(TPNA, digits=2)
    TPNE = round(TPNE, digits=2)

   # 5. Taxa Definitivamente Negativo Acerto/Erro
   TDNA = DNA /(DNA + DNE)
   TDNE = DNE /(DNA + DNE )
   TDNA = round(TDNA, digits=2)
   TDNE = round(TDNE, digits=2)


    println("............................................")
    println("     Taxa de Acerto  |  Taxa de Erro ")
    println("Def Positivo  : ",   TDPA, " |       " , TDPE)
    println("Pro Positivo  : ",   TPPA, " |       " , TPPE)
    println("Indefindos    : ",   TIA, "  |       " , TIE)
    println("Pro Negativo  : ",    TPNA, "  |       " , TPNE)
    println("Def Negativo  : ",    TDNA, "  |       " , TDNE)
    println("............................................")
   
    
   # 1.0 Métricas 
   
   println(".........Métricas $(model_name)................")
        
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
   println("Ind a = ", IDa)
   println("Ind b = ", IDb)
   println("Inde = ", IDa +IDb)
   println("Soma          = ", Soma)
   TIP = IDa/(IDa + IDb)
   TIN  = IDb/(IDa+IDb)
   

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
    filename = "Resultados:$(model_name)_β$beta(cb).txt"
    #filename = "Tabela_$(model_file)_$(balanceamento).txt"
    # abre o arquivo para a escrita 
    open(filename, "w") do file 
        println(file, "========================================")
        println(file, "Tabela de Resultado das Taxas")
        # Personaliza a saída com base no nome do modelo
        if model_name == "GP_2A.jl"
          println(file, "|---------Modelo 2 A---------|")
        elseif model_name == "GP_2B.jl"
          println(file, "|---------Modelo 2 B---------|")
        end
        if model_name == "GP_2C.jl"
          println(file, "|---------Modelo 2 C---------|")
        elseif model_name == "GP_2D.jl"
          println(file, "|---------Modelo 2 D---------|")
        end  
        println(file, "========================================")
        println(file,"Função Objetivo = ", FO)
        println(file,"Hiperlano       = ",  wo)
        println(file,"Status = ", status)
        println(file,"média das variáveis = " , media)   
        println(file,"Time  = ", time)
        println(file, "hiper+beta =  ",hiper_up)
        println(file, "hiperplano =  ",wo)
        println(file, "hiper-beta =  ",hiper_down)
        println(file, "-----------------------------------------")
        println(file,"Valor Acerto (Def Positivo) =  ", DPA)
        println(file,"Valor Erro   (Def Positivo) =  ", DPE)
        println(file,"Valor Acerto (Def Positivo) =  ", PPA)
        println(file,"Valor Erro   (Def Positivo) =  ", PPE)
        println(file,"Taxa Acerto (Indefindos)    =  ", TIA)
        println(file,"Taxa Erro   (Indefindos)    =  ", TIE)
        println(file,"Valor Acerto (Prob Negativo)= ", PNA)
        println(file,"Valor Erro  (Prob Negativo) = ",  PNE)
        println(file,"Valor Acerto (Def Negativo)  = ", DNA)
        println(file,"Valor Erro  (Def Negativo)   = ",  DNE)
        println(file, ".............................................")
        println(file,"     Taxa de Acerto  |  Taxa de Erro ")
        println(file,"Def Positivo  : ",   TDPA, " |       " , TDPE)
        println(file,"Pro Positivo  : ",   TPPA, " |       " , TPPE)
        println(file, "Indefindos    : ",   TIA, "  |       " , TIE)
        println(file, "Pro Negativo  : ",   TPNA, "  |       " , TPNE)
        println(file, "Def Negativo  : ",    TDNA, "  |       " , TDNE)
        println(file, ".............................................")
        println(file," ")
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