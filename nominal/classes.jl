# Modelo Robusto  para Problema de Classificação
# Data: 21/ Agosto/2024
# Nome: Ricardo Soares Oliveira 


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
    # y_definitvo_positivo
    y_def_pos = y_modelo .>= wo + beta
    
    println("y_definitvo_positivo = ", y_def_pos)  
    
    # Definitivamente positivo (acerto e erro)
    Def_P_a = sum((y_real .==1) .& (y_def_pos))
    Def_P_e = sum((y_real .==0) .& (y_def_pos))
    println(" Acerto: Def. Positivo = ", Def_P_a)
    println(" Erro  : Def. Positivo = ", Def_P_e)


end