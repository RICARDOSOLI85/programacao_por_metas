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
    
    # Metricas
    println(".......................................................")
    println("                        Metricas                       ") 
    # Valores de Y Definitivamente Positivo
    # (Maior ou igual a hipeplano + beta)
    y_def_pos = y_modelo .>= wo + beta    
    println("y_definitvo_positivo = ", y_def_pos)
    
    # Valores de Y Provavelmente Positivo
    # (Menor ao hipeplano + beta e ".&" Maior que hiperplano)
    y_prob_pos = (y_modelo .< wo + beta) .& (y_modelo .> wo)
    println("y_provavel_positivo = ", y_prob_pos)
    println("y_real = ", y_real)   
    
    println(".......................................................")
    # Definitivamente Positivo (valores de acertos e erros)
    DPA = sum((y_real .==1) .& (y_def_pos .==1))
    DPE = sum((y_real .==0) .& (y_def_pos .==1))
    println("Valor Acerto (Def Positivo)  = ", DPA)
    println("Valor Erro   (Def. Positivo) = ", DPE)

    # Provavelmente Positivo (Valores de acertos e erros)
    PPA = sum((y_real .== 1) .& (y_prob_pos .==1))
    PPE = sum((y_real .== 0) .& (y_prob_pos .==1))
    println("Valor Acerto (Prob Positivo) = ", PPA)
    println("Valor Erro   (Prob Positivo) = ",  PPE)

    # Calculo das taxas 
    # Taxa Definitivamente Positivo Acerto/Erro  
    TDPA = DPA/(DPA +DPE)
    TDPE = DPA/(DPA +DPE)  

    #println("Taxa Acerto (Def Positivo) =  ", TDPA)
    #println("Taxa Erro   (Def Positivo) =  ", TDPE)

    # Taxa Definitivamente Positivo Acerto/Erro  
    TPPA = PPA/(PPA + PPE)
    TPPE = PPA/(PPA + PPE)  

    #println("Taxa Acerto (Def Positivo) =  ", TPPA)
    #println("Taxa Erro   (Def Positivo) =  ", TPPE)

    println("............................................")
    println("     Taxa de Acerto  |  Taxa de Erro ")
    println("Def Positivo  : ",   TDPA, "  |       " , TDPE)
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
        println(file, ".............................................")
        println(file,"     Taxa de Acerto  |  Taxa de Erro ")
        println(file,"Def Positivo  : ",   TDPA, "  |       " , TDPE)
        println(file, "............................................")
    end 


     




end