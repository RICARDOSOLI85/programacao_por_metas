# Modelo Robusto para Problema de Classificação
# Data: 21/ Agosto/2024
# Nome: Ricardo Soares Oliveira
using Printf 

function calcular_classes(FO, C, x, xo, y_real, beta, modelo)
    n = length(x)
    w = x
    wo = xo    
    # Calcula hiperplano 
    c = Matrix(C)
    y_modelo = c * w 
    println("vetor hiperplano = ", y_modelo)
    hiper_up   = wo + beta
    hiper_down = wo - beta 
    println("hiper+beta = ", hiper_up)
    println("hiperplano = ", wo)
    println("hiper-beta = ", hiper_down)
    println("x[0] = ", xo)
    for i = 1:n 
        println("x[$i] = ", JuMP.value.(x[i]))
    end

    # Parte: A
    # Métricas   
    println(".......................................................")
    println("                        Métricas                       ")
    println(".......................................................") 

    # 1. Definitivamente Positivo
    y_def_pos = y_modelo .>= wo + beta    
    println("y_definitvo_positivo = ", y_def_pos)
    
    # 2. Provavelmente Positivo
    y_prob_pos = (y_modelo .< wo + beta) .& (y_modelo .> wo)
    println("y_provavel_positivo = ", y_prob_pos)
    println("y_real = ", y_real)
    
    # 3. Valores de Y Indefinidos
    y_indef = y_modelo .== wo
    println("y_indef = ", y_indef)

    # 4. Provavelmente Negativos 
    y_prob_neg =  (y_modelo .< wo) .& (y_modelo .> wo - beta )
    println("y_prob_neg = ", y_prob_neg)

    # 5. Definitivamente Negativo 
    y_def_neg = y_modelo .<= wo - beta
    println("y_def_neg = ", y_def_neg) 

    println(".......................................................")
    # 1. Definitivamente Positivo (valores de acertos e erros)
    DPA = sum((y_real .== 1) .& (y_def_pos .== 1))
    DPE = sum((y_real .== 0) .& (y_def_pos .== 1))
    println("Valor Acerto (Def Positivo)  = ", DPA)
    println("Valor Erro   (Def. Positivo) = ", DPE)

    # 2. Provavelmente Positivo (Valores de acertos e erros)
    PPA = sum((y_real .== 1) .& (y_prob_pos .== 1))
    PPE = sum((y_real .== 0) .& (y_prob_pos .== 1))
    println("Valor Acerto (Prob Positivo) = ", PPA)
    println("Valor Erro   (Prob Positivo) = ",  PPE)

    # 3. Indefinidos (sobre o hiperplano)
    IA = sum((y_real .== 1) .& (y_indef .== 1))
    IE = sum((y_real .== 0) .& (y_indef .== 1))
    println("Valores Acerto (Indefinidos) = ", IA)
    println("Valores Erro  (Indefinidos)  = ", IE)

    # 4. Provavelmente Negativos (Valores de acertos e erros)
    PNA = sum((y_real .== 0) .& (y_prob_neg .== 1))
    PNE = sum((y_real .== 1) .& (y_prob_neg .== 1))
    println("Valor Acerto (Prob Negativo) = ", PNA)
    println("Valor Erro  (Prob Negativo)  = ",  PNE)

    # 5. Definitivamente Negativo (Valores de acertos e erros)
    DNA = sum((y_real .== 0) .& (y_def_neg .== 1))
    DNE = sum((y_real .== 1) .& (y_def_neg .== 1))
    println("Valor Acerto (Def Negativo)  = ", DNA)
    println("Valor Erro  (Def Negativo)   = ",  DNE)

    # Calculo das taxas 
    # 1. Taxa Definitivamente Positivo Acerto/Erro  
    TDPA = DPA / (DPA + DPE)
    TDPE = DPE / (DPA + DPE)  
    TDPA = round(TDPA, digits=2)
    TDPE = round(TDPE, digits=2)

    # 2. Taxa Provavelmente Positivo Acerto/Erro  
    TPPA = PPA / (PPA + PPE)
    TPPE = PPE / (PPA + PPE)
    TPPA = round(TPPA, digits=2)
    TPPE = round(TPPE, digits=2)

    # 3. Taxa dos valores indefinidos 
    TIA = IA / (IA + IE)
    TIE = IE / (IA + IE)
    TIA = round(TIA, digits=2)
    TIE = round(TIE, digits=2)

    # 4. Taxa Provavelmente Negativo Acerto/Erro  
    TPNA = PNA / (PNA + PNE)
    TPNE = PNE / (PNA + PNE)
    TPNA = round(TPNA, digits=2)
    TPNE = round(TPNE, digits=2)

    # 5. Taxa Definitivamente Negativo Acerto/Erro
    TDNA = DNA / (DNA + DNE)
    TDNE = DNE / (DNA + DNE)
    
    println("............................................")
    println("     Taxa de Acerto  |  Taxa de Erro ")
    println("Def Positivo  : ",   TDPA, " |       " , TDPE)
    println("Pro Positivo  : ",   TPPA, " |       " , TPPE)
    println("Indefindos    : ",   TIA, "  |       " , TIE)
    println("Pro Negativo  : ",   TPNA, "  |       " , TPNE)
    println("Def Negativo  : ",    TDNA, "  |       " , TDNE)
    println("....................................................")

    # B Calculo das medias de precisão TP, FP, FN, TN
    TP = DPA + PPA 
    FP = DPE + PPE 
    ID = IA + IE 
    FN = PNE + DNE 
    TN = PNA + DNA 
    soma = TP + FP + ID + FN + TN
    println(" ............. Modelo 2 A $beta ...................")
    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
    println("---------------------------------------------------------------")
    println("Indefinido    = ", ID)
    println("Soma do Total = ", soma)

    # Calcular a Acurácia 
    accuracy = (TP + TN) / (TP + FN + FP + TN)

    # Calculando precisão de Recall 
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)

    # Calcular F1 Score 
    f1_score = 2 * (precision * recall) / (precision + recall)

    println( "accuray    = ", accuracy)
    println("precision  = ", precision) 
    println("recall     = ", recall) 
    println("F1Score    = ", f1_score)

    # Taxa de acerto e taxa de erro 
    TPA = (DPA + PPA) / (DPA + PPA + DPE + PPE) 
    TPE = (DPE + PPE) / (DPA + PPA + DPE + PPE)
    TI = (ID / soma)
    TNA = (DNA + PNA) / (DNA + PNA + DNE + PNE) 
    TNE = (DNE + PNE) / (DNA + PNA + DNE + PNE)
    println("............................................")
    println("         Taxa de Acerto |  Taxa de Erro ")
    println(" Positivo   :   ",  TPA, "     |     " , TPE)
    println(" Indefindo  :   ",   TI, "     |     " , TI)
    println(" Negativo   :   ",    TNA, "     |     " , TNE)
    println("............................................")

    # Salvar em um arquivo TXT
    # nome do arquivo 
    filename = "tabela_$(modelo)_$beta.txt"
    open(filename, "w") do file
        @printf file "Modelo: %s\n", modelo
        @printf file "beta: %.2f\n", beta
        @printf file "Definitivamente Positivo: Acertos = %d, Erros = %d\n", DPA, DPE
        @printf file "Provavelmente Positivo: Acertos = %d, Erros = %d\n", PPA, PPE
        @printf file "Indefinidos: Acertos = %d, Erros = %d\n", IA, IE
        @printf file "Provavelmente Negativo: Acertos = %d, Erros = %d\n", PNA, PNE
        @printf file "Definitivamente Negativo: Acertos = %d, Erros = %d\n", DNA, DNE
        @printf file "Taxa de Acerto Def Positivo: %.2f\n", TDPA
        @printf file "Taxa de Erro Def Positivo: %.2f\n", TDPE
        @printf file "Taxa de Acerto Prov Positivo: %.2f\n", TPPA
        @printf file "Taxa de Erro Prov Positivo: %.2f\n", TPPE
        @printf file "Taxa de Acerto Indefinidos: %.2f\n", TIA
        @printf file "Taxa de Erro Indefinidos: %.2f\n", TIE
        @printf file "Taxa de Acerto Prov Negativo: %.2f\n", TPNA
        @printf file "Taxa de Erro Prov Negativo: %.2f\n", TPNE
        @printf file "Taxa de Acerto Def Negativo: %.2f\n", TDNA
        @printf file "Taxa de Erro Def Negativo: %.2f\n", TDNE
        @printf file "Acurácia: %.2f\n", accuracy
        @printf file "Precisão: %.2f\n", precision
        @printf file "Recall: %.2f\n", recall
        @printf file "F1 Score: %.2f\n", f1_score
        @printf file "Taxa de Acerto Positivo: %.2f\n", TPA
        @printf file "Taxa de Erro Positivo: %.2f\n", TPE
        @printf file "Taxa de Indefinidos: %.2f\n", TI
        @printf file "Taxa de Acerto Negativo: %.2f\n", TNA
        @printf file "Taxa de Erro Negativo: %.2f\n", TNE
    end
end
