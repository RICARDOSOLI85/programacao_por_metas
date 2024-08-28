# Métricas para o resultado do modelo
# Nome: Ricardo Soares Oliveira
# Data 28/Agosto/2024 

function calcular_classes(C::DataFrame,y_real::DataFrame,gama::Float64,beta::Float64,
    modelo::Model,tar::Float64,sol::Vector{Float64},model_name::String,
    epsilon::Float64,modelo_nome::String)

    # leitura
    n = length(sol);
    target = tar;
    solucao = sol;
    
    # Calcular o hiperplano 
    c = Matrix(C); 
    y_modelo = c * solucao; 
    #println("vetor target = " , y_modelo) 
    
    # Transformar o data frame em um vetor Float
    y_real = Matrix(y_real);

    hiper_up   = wo .+ beta
    hiper_down = wo .- beta 
    println("hiper+beta = ",hiper_up)
    println("hiperplano = ",wo)
    println("hiper-beta = ",hiper_down)
    
    
    # 1.0 Calcular as Métricas
    println(" ")
    println("           Métricas                ")

    # 1. Definitivamente Positivo
    y_def_pos = y_modelo .>= (target + beta);  

    # 2. Provavelmente Positivo
    y_prob_pos = (y_modelo .< target + beta) .& (y_modelo .> target); 
    
    # 3. Valores de Y Indefinidos
    y_indef = (y_modelo .== target);

    # 4. Provavelmente Negativos 
    y_prob_neg =  (y_modelo .< target) .& (y_modelo .> target - beta );

    # 5. Definitivamente Negativo 
    y_def_neg = (y_modelo .<= target  - beta);

    #---------------------------------------------------------
    # 1. Definitivamente Positivo (valores de acertos e erros)
    DPA = sum((y_real .==1) .& (y_def_pos .==1))
    DPE = sum((y_real .==0) .& (y_def_pos .==1))
    #println("Valor Acerto (Def Positivo)  = ", DPA)
    #println("Valor Erro   (Def. Positivo) = ", DPE)

    # 2. Provavelmente Positivo (Valores de acertos e erros)
    PPA = sum((y_real .== 1) .& (y_prob_pos .==1))
    PPE = sum((y_real .== 0) .& (y_prob_pos .==1))
    #println("Valor Acerto (Prob Positivo) = ", PPA)
    #println("Valor Erro   (Prob Positivo) = ",  PPE)

    # 3. Indefinidos (sobre o hiperplano)
    IA = sum((y_real .==1) .& (y_indef .==1))
    IE = sum((y_real .==0) .& (y_indef .==1))
    #println("Valores Acerto (Indefinidos) = ", IA)
    #println("Valores Erro  (Indefinidos)  = ", IE)

    # 4. Provavelmente Negativos (Valores de acertos e erros)
    PNA = sum((y_real .==0).&(y_prob_neg .==1))
    PNE = sum((y_real .==0) .& (y_prob_neg .==1))

    #println("Valor Acerto (Prob Negativo) = ", PNA)
    #println("Valor Erro  (Prob Negativo)  = ",  PNE)

    # 5. Definitivamente Negativo (Valores de acertos e erros)
    DNA = sum((y_real .==0) .& (y_def_neg .==1))
    DNE = sum((y_real .==1) .& (y_def_neg .==1))

    #println("Valor Acerto (Def Negativo)  = ", DNA)
    #println("Valor Erro  (Def Negativo)   = ",  DNE)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # y_predito: Estou selecionando maior ou igual ao hiperplano
    y_predito = y_modelo .>= target;
    y_real = y_real; 
    # y_pred : Estou selecionando os pontos no hiperplano
    y_pred = y_modelo .== target; 

    #println("y_predito = " , y_predito) 
    #println("y_pred = " , y_pred) 
    #println("y_real = " , y_real)

    # 2. Calcular TP, FN, FP, TN 
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
    
    # 2.1 Erros nas classes e o indefinido 
    # Estou retirando com ERc2 a classe do tipo B sobre o hiperplano
    Erc1 = sum((y_real .==1) .& (y_pred .==1))
    Erc2 = sum((y_real .==0 ) .& (y_pred .==1))
    Indefinidos = Erc1 + Erc2 
    Soma = TP + FN + FP + TN 

    println("Erro Classe A = ", Erc1)
    println("Erro Classe B = ", Erc2)
    println("Indefindos    = ", Indefinidos)
    println("Soma          = ", Soma)

    # 2.2 Correção do Falso Positivo 
    FPc = FP - Erc2 
    Soma_C = TP +FN + FPc + TN 
    println("Falso Positivo Correto = ", FPc)
    println("Soma_atual             = ", Soma_C)

      # 3. Taxa Positivo acerto/erro  
    TPA = TP  /(TP + FN)
    TPE = FN / (TP + FN)
    TPA = round(TPA, digits=2)
    TPE = round(TPE, digits=2)
    #println("Taxa Positivo acerto = ", TPA)
    #println("Taxa Positivo erro   = ",   TPE)

    # 4. Taxa Indefinidos Positivo/Negativo : sobre o hiperplano 
    TIP = Erc1 / (Erc1 + Erc2) 
    TIN = Erc2 / (Erc1 + Erc2)
    TIP = round(TIP, digits=2)
    TIN = round(TIN, digits=2)
    #println("Taxa Positivo acerto = ",  TIP)
    #println("Taxa Positivo erro  = ",   TIN) 
   

     # 5. Taxa Negativo Acerto Erro  
     TNA = TN  /(TN + FPc)   # Falso Positivo C 
     TNE = FPc / (FPc + TN)
     TNA = round(TNA, digits=2)
     TNE = round(TNE, digits=2)
     #println("Taxa Positivo acerto = ", TNA)
     #println("Taxa Positivo erro  = ",   TNE)

    println("............................................")
    println("    Taxa de Acerto  |  Taxa de Erro ")
    println(" Positivo   : ",   TPA, "   |    " , TPE)
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

    # Impressão dos resultados 

    println(".................................................")
    println("   Imprimindo a solução do modelo Robusto 1 A ")
    println("        O valor de Gama é (Γ =  ", gama, ")")
    println(".................................................")
    FO     = JuMP.objective_value(modelo)
    tar = JuMP.value(target)
    sol = JuMP.value.(solucao)
    NV= num_variables(modelo)
    println("Função Objetivo (FO) = ", FO)
    println("Target  x[o]           = ", tar)
    println("Solução x[j]         = ", sol)
    println("N. variáveis         = ", NV)
    m = size(C,2);
    for j=1:m 
        println("sol[$j] = ", JuMP.value.(sol[j]))
    end 
    Status = termination_status(modelo)
    time = round(solve_time(modelo), digits=4)
    println("Status = ", Status)
    println("Time   = ", time, " s")
    println(".................................................")

    # Salvar em um arquivo TXT
    
    # Defina o caminho do diretório onde deseja salvar o arquivo
    diretorio = "Resultados: RPG1"
    # Cria o diretório se ele não existir
    mkpath(diretorio)
    # nome do arquivo
    #filename = "Tabela :$(model_name).txt"
    filename = joinpath(diretorio,"$(model_name)_$(modelo_nome)_Γ_$(gama)_ϵ_$(epsilon).txt")
    # abre o arquivo para a escrita
    open(filename, "w") do file
        println(file,"........................................")
        println(file," Solução do modelo : $(model_name)" )
        println(file," filtro/balanceado : $(modelo_nome)" )
        println(file, "O valor de Gama é (Γ = ", gama, ")")
        println(file, "O valor de Epsilo é (ϵ = ", epsilon, ")")
        println(file,"........................................")
        println(file,"Função Objetivo (FO) = ", FO)
        println(file,"Target  x[o]         = ", tar)
        println(file,"Solução x[j]         = ", sol)
        println(file,"N. variáveis         = ", NV)
        for j=1:m
         println(file,"sol[$j] = ", JuMP.value.(sol[j]))
        end 
        println(file,"Status = ", Status)
        println(file,"Time   = ", time, " s")
        println(file,"--------------------------------------------------------------")
        println(file,"                      Matriz de Confusão                        ")
        println(file,"--------------------------------------------------------------")
        println(file,"|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
        println(file,"|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
        println(file,"---------------------------------------------------------------")
        println(file,"Erro Classe A = ", Erc1)
        println(file,"Erro Classe B = ", Erc2)
        println(file,"Indefindos    = ", Indefinidos)
        println(file,"Soma          = ", Soma)
        println(file,"Falso Positivo Correto = ", FPc)
        println(file,"Soma_atual             = ", Soma_C)
        println(file,"............................................")
        println(file,"    Taxa de Acerto  |  Taxa de Erro ")
        println(file," Positivo   : ",   TPA, "   |    " , TPE)
        println(file," Indefinido : ",   TIP, "  |    " , TIN)
        println(file," Negativo   : ",   TNA, "  |    " , TNE)
        println(file,"............................................")
        println(file,"Acurácia    =  ", accuracy)
        println(file,"precision   =  " , precision)
        println(file,"recall      =  ", recall)
        println(file,"F1Score     =  ", f1_score)
        println(file,"*******************************************")

    end 



    return resultados 
    
end