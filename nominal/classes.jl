# Modelo Robusto  para Problema de Classificação
# Data: 21/ Agosto/2024
# Nome: Ricardo Soares Oliveira 
using Printf 

function calcular_classes(FO, C, x, xo, y_real,beta)
    n =length(x)
    w = x
    wo = xo
    
    # Calcula hiperplano 
    c = Matrix(C)
    y_modelo = c * w 
    #y_modelo = [1 2 1.8 3 3 1 2 1.8 4 1]            # criando hipotetico apenas para modelar 
    println("vetor hiperplano = ", y_modelo)
    hiper_up   = wo + beta
    hiper_down = wo - beta 
    println("hiper+beta = ",hiper_up)
    println("hiperplano = ",wo)
    println("hiper-beta = ",hiper_down)


    # Parte: A
    # Metricas

    

    println(".......................................................")
    println("                        Métricas                       ")
    println(".......................................................") 
    # 1. Definitivamente Positivo
    #    (Maior ou igual a hipeplano + beta)
    y_def_pos = y_modelo .>= wo + beta    
    println("y_definitvo_positivo = ", y_def_pos)
    
    # 2. Provavelmente Positivo
    #    (Menor ao hipeplano + beta e ".&" Maior que hiperplano)
    y_prob_pos = (y_modelo .< wo + beta) .& (y_modelo .> wo)
    println("y_provavel_positivo = ", y_prob_pos)
    println("y_real = ", y_real)
    
    # 3. Valores de Y Indefinidos
    # (Sobre o hiperplano )
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
    #println("Taxa Acerto (Def Positivo) =  ", TDPA)
    #println("Taxa Erro   (Def Positivo) =  ", TDPE)

    # 2. Taxa Provavelmente Positivo Acerto/Erro  
    TPPA = PPA/(PPA + PPE)
    TPPE = PPE/(PPA + PPE)
    TPPA = round(TPPA, digits=2)
    TPPE = round(TPPE, digits=2)
    #println("Taxa Acerto (Def Positivo) =  ", TPPA)
    #println("Taxa Erro   (Def Positivo) =  ", TPPE)

    # 3. Taxa dos valores indefinidos 
    TIA = IA /(IA +IE )
    TIE = IE /(IA +IE )
    TIA = round(TIA, digits=2)
    TIE = round(TIE, digits=2)
    #println("Taxa Acerto (Indefindos) =  ", TIA)
    #println("Taxa Erro   (Indefindos) =  ", TIE)

    # 4. Taxa Provavelmente Positivo Acerto/Erro  
    TPNA = PNA / (PNA + PNE)
    TPNE = PNE / (PNA + PNE )
    TPNA = round(TPNA, digits=2)
    TPNE = round(TPNE, digits=2)

   # 5. Taxa Definitivamente Negativo Acerto/Erro
   
   TDNA = DNA /(DNA + DNE)
   TDNE = DNE /(DNA + DNE )
   #TDNA = round(TPNA, digits=2)
   #TDNE = round(TPNE, digits=2)


    println("............................................")
    println("     Taxa de Acerto  |  Taxa de Erro ")
    println("Def Positivo  : ",   TDPA, " |       " , TDPE)
    println("Pro Positivo  : ",   TPPA, " |       " , TPPE)
    println("Indefindos    : ",   TIA, "  |       " , TIE)
    println("Pro Negativo  : ",    TPNA, "  |       " , TPNE)
    println("Def Negativo  : ",    TDNA, "  |       " , TDNE)
    println("............................................")
   
   


    # Salvar em um arquivo TXT
    # nome do arquivo 
    filename = "tabela_gp2.txt"
    # abre o arquivo para a escrita 
    open(filename, "w") do file 
        println(file, "========================================")
        println(file, "Tabela de Resultado das Taxas - GP 2: A ")
        println(file, "========================================")
        @printf(file, "Função Objetivo  = %.2f\n", FO)
        println(file, "variáveis  =  ", x)
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

    end 
    
end