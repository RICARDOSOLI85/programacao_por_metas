# Métricas para o resultado do modelo
# Nome: Ricardo Soares Oliveira
# Data 05/09/2024

function calcular_classes(modelo::Model,C_teste::DataFrame,
    sol::Vector{Float64},tar::Float64,y_real::DataFrame,
    model::String,variacao::String,
    tipo::String,gama::Float64,epsilon::Float64,
    beta::Float64)  

    # leitura
    n = length(sol);
    target = tar;
    solucao = sol;
    media = mean(solucao)
    
    # Calcular o hiperplano
    C = C_teste; 
    c = Matrix(C); 
    y_modelo = c * solucao; 
    #println("vetor target = " , y_modelo) 
    
    # Transformar o data frame em um vetor Float
    y_real = Matrix(y_real);

    hiper_up   = target .+ beta
    hiper_down = target .- beta 
    #println("hiper+beta = ",hiper_up)
    #println("hiperplano = ",target)
    #println("hiper-beta = ",hiper_down)

    # Status da solução 
    FO = objective_value(modelo)
    FO = round(FO, digits=2)
    status = termination_status(modelo)
    time = solve_time(modelo)
    time = round(time, digits=4)
    nv = num_variables(modelo)
    
    
    # imprimindo os resultados 
    println("=============================================================")
    println("Resultados: modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon")
    println("=============================================================")
    println("Função Objetivo = ", FO)
    println("Hiperplano       = ", target)
    println("Status = ", status)
    println("Média das variáveis = ", media)   
    println("Time  = ", time)
    println("N variáveis  = ", nv)


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
    PNE = sum((y_real .==1) .& (y_prob_neg .==1))
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
    println("Def Positivo  : ",    TDPA, " |       " , TDPE)
    println("Pro Positivo  : ",    TPPA, " |       " , TPPE)
    println("Indefindos    : ",    TIA, "  |       " , TIE)
    println("Pro Negativo  : ",    TPNA, "  |       " , TPNE)
    println("Def Negativo  : ",    TDNA, "  |       " , TDNE)
    println("............................................")
    
    # Parte B 
    # Métricas TP, FN, FP, TN 
    
    y_pred_ca = y_modelo .>= target;
    y_pred_cb = y_modelo .<= target;

    TP = sum((y_real .== 1) .& (y_pred_ca .== 1))
    FN = sum((y_real .== 1) .& (y_pred_ca .== 0))
    FP = sum((y_real .== 0) .& (y_pred_cb .== 0))
    TN = sum((y_real .== 0) .& (y_pred_cb .== 1))


    println("--------------------------------------------------------------")
    println("                      Matriz de Confusão                        ")
    println("--------------------------------------------------------------")
    println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN, " ||")
    println("|| False Positive (FP)  = ", FP, " | True Negative  (TN)  = ", TN, " ||")
    println("--------------------------------------------------------------")

    # Taxa Positivo acerto/erro  
    TPA = TP / (TP + FN)
    TPE = FN / (TP + FN)
    TPA = round(TPA, digits=2)
    TPE = round(TPE, digits=2)

    # Taxa Negativo Acerto Erro  
    TNA = TN / (TN + FP)
    TNE = FP / (FP + TN)
    TNA = round(TNA, digits=2)
    TNE = round(TNE, digits=2)

    println("............................................")
    println("   Taxa de Acerto |  Taxa de Erro ")
    println(" Positivo   : ", TPA, "  |    ", TPE)
    println(" Negativo   : ", TNA, "  |    ", TNE)
    println("............................................")

    # Medidas de precisão 
    accuracy = (TP + TN) / (TP + FN + FP + TN)
    accuracy = round(accuracy, digits=2)

    # Calculando precisão e recall 
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    precision = round(precision, digits=2)
    recall = round(recall, digits=2)

    # Calcular F1 Score 
    f1_score = 2 * (precision * recall) / (precision + recall)
    f1_score = round(f1_score, digits=2)

    println("Acurácia    =  ", accuracy)
    println("Precisão    =  ", precision)
    println("Recall      =  ", recall)
    println("F1Score     =  ", f1_score)




    # Impressão dos resultados 

    println(".................................................")
    println("   Imprimindo a solução do modelo Robusto 1 A ")
    println("        O valor de Gama é (Γ =  ", gama, ")")
    println("        O valor de Beta é (Β =  ", beta, ")")
    println("        O valor de Epsilon é(Ε =  ", beta, ")")
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
    diretorio = "resultados_modelo_2"
    # Cria o diretório se ele não existir
    mkpath(diretorio)
    filename = joinpath(diretorio,"Tabela:modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon.txt")
    # abre o arquivo para a escrita
    open(filename, "w") do file
        println(file,"........................................")
        println(file,"Solução do modelo:$model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon")
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
        println(file,"hiper+beta = ",hiper_up)
        println(file,"hiperplano = ",target)
        println(file,"hiper-beta = ",hiper_down)
        println(file,"............................................")
        println(file,"............................................")
        println(file,"     Taxa de Acerto  |  Taxa de Erro ")
        println(file,"Def Positivo  : ",    TDPA, " |       " , TDPE)
        println(file,"Pro Positivo  : ",    TPPA, "  |       " , TPPE)
        println(file,"Indefindos    : ",    TIA, "  |       " , TIE)
        println(file,"Pro Negativo  : ",    TPNA, " |       " , TPNE)
        println(file,"Def Negativo  : ",    TDNA, "  |       " , TDNE)
        println(file,"............................................................")
        println(file,"--------------------------------------------------------------")
        println(file,"  Matriz de Confusão $model.$variacao($tipo).Par Γ=$gama ϵ=$epsilon ")
        println(file,"--------------------------------------------------------------")
        println(file,"|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN," ||")
        println(file,"|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN," ||") 
        println(file,"---------------------------------------------------------------")
        println(file,"............................................")
        println(file,"    Taxa de Acerto  |  Taxa de Erro ")
        println(file," Positivo   : ",   TPA, "   |    " , TPE)
        println(file," Indefinido : ",   TIA, "  |    " , TIE)
        println(file," Negativo   : ",   TNA, "  |    " , TNE)
        println(file,"............................................")
        println(file,"Acurácia    =  ", accuracy)
        println(file,"precision   =  " , precision)
        println(file,"recall      =  ", recall)
        println(file,"F1Score     =  ", f1_score)
        println(file,"*******************************************")

    end 



    
    
end