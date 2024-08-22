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

    println("vetor hiperplano = ", y_modelo)
    hiper_up   = wo + beta
    hiper_down = wo - beta 
    println("hiper+beta = ",hiper_up)
    println("hiperplano = ",wo)
    println("hiper-beta = ",hiper_down)

    # Metricas 
    # Valores de Y Definitivamente Positivo
    # (Maior ou igual a hipeplano + beta)
    y_def_pos = y_modelo .>= wo + beta    
    println("y_definitvo_positivo = ", y_def_pos)  
    
    # Definitivamente Positivo (valores de acertos e erros)
    DPA = sum((y_real .==1) .& (y_def_pos))
    DPE = sum((y_real .==0) .& (y_def_pos))
    println("Valor Acerto (Def Positivo)  = ", DPA)
    println("Valor Erro   (Def. Positivo) = ", DPE)

    # Provavelmente Positivo (Valores de acertos e erros)

    # Calculo das taxas 
    # Taxa Definitivamente Positivo Acerto/Erro  
    TDPA = DPA/(DPA +DPE)
    TDPE = DPA/(DPA +DPE)  

    println("Taxa Acerto (Def Positivo) =  ", TDPA)
    println("Taxa Erro   (Def Positivo) =  ", TDPE)





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
        println(file,"Taxa Acerto (Def Positivo) =  ", TDPA)
        println(file,"Taxa Erro   (Def Positivo) =  ", TDPE)
    end 


     




end