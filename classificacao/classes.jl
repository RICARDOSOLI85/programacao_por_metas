# Modelo Robusto  para Problema de Classificação
# Data: 21/ Agosto/2024
# Nome: Ricardo Soares Oliveira 
using Printf 

function calcular_classes(FO, C, x, w, y_real,beta, model_name)
   
    n =length(x);
    x = x;
    wo =  xo;
    
    # 0.  Calcula hiperplano 
    c = Matrix(C);
    y_modelo = c * x;
    #println("y_modelo =", y_modelo)

     # 0.1 Tranformar o data frame y_real em vector (importante)
    y_real = Matrix(y_real);
    println(" tipo de variável y_ real =", typeof(y_real))

    println("tipo wo, : ", typeof(wo))
    println("tipo beta, : ", typeof(beta))

    hiper_up   = wo .+ beta
    hiper_down = wo .- beta 
    println("hiper+beta = ",hiper_up)
    println("hiperplano = ",wo)
    println("hiper-beta = ",hiper_down)
   


    # Parte: A
    # Métricas   

    println(".......................................................")
    println("                        Métricas                       ")
    println(".......................................................") 
    
    # 1. Definitivamente Positivo
    #    (Maior ou igual a hipeplano + beta)
    y_def_pos = y_modelo .>= wo + beta;    
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


    # B Calculo das medias de precisão TP, FP, FN, TN
    TP = DPA + PPA 
    FP = DPE + PPE 
    ID = IA + IE 
    FN = PNE + DNE 
    TN = PNA + DNA 
    soma = TP + FP + ID + FN + TN
    println(" ")
    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
    println("---------------------------------------------------------------")
    println("Indefinido    = ", ID)
    println("Soma do Total = ", soma)

    # Calcular a Acurácia 
    accuracy = (TP + TN) / (TP + FN + FP +TN)
    println("accuracy = ", accuracy)
    # Calculando precisão de Recall 
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    println("precision = ", precision)
    println("recall = ", recall)

    # Calcular F1 Score 
    f1_score  = 2 * (precision * recall) / (precision + recall)
    println("f1_score = ", f1_score)

    # Taxa de acerto e taxa de erro 

    TPA = (DPA + PPA) / (DPA + PPA + DPE + PPE) 
    TPE = (DPE + PPE) / (DPA + PPA + DPE + PPE)
    TI  = (ID / soma)
    TNA = (DNA + PNA) / (DNA + PNA + DNE + PNE) 
    TNE = (DNE + PNE) / (DNA + PNA + DNE + PNE)
    println(" ")
    println("............................................")
    println("         Taxa de Acerto |  Taxa de Erro ")
    println(" Positivo   :   ",  TPA, "     |     " , TPE)
    println(" Indefindo  :   ",   TI, "     |     " , TI)
    println(" Negativo   :   ",    TNA, "     |     " , TNE)
    println("............................................")


    # Salvar em um arquivo TXT
    # nome do arquivo 
    filename = "Tabela_$(model_name)_sb.txt"
    #filename = "Tabela_Modelo_1_Filtro_Teste.txt"
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
        @printf(file, "Função Objetivo  = %.2f\n", FO)
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
        println(file,"                      Matriz de Confusão                        ")
        println(file,"--------------------------------------------------------------")
        println(file,"|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
        println(file,"|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
        println(file,"---------------------------------------------------------------")
        println(file,"Indefinido    = ", ID)
        println(file,"Soma do Total = ", soma)
        println(file,"-----------------------------")
        println(file, "accuray    = ", accuracy)
        println(file,"precision  = ", precision) 
        println(file,"recall     = ", recall) 
        println(file, "F1Score    = ", f1_score)
        println(file,"............................................")
        println(file,"         Taxa de Acerto |  Taxa de Erro ")
        println(file," Positivo   :   ",  TPA, "     |     " , TPE)
        println(file," Indefindo  :   ",   TI, "     |     " , TI)
        println(file," Negativo   :   ",    TNA, "     |     " , TNE)
        println(file,"............................................")
        println(file,"*************************************************************\n")

    end 
    
end