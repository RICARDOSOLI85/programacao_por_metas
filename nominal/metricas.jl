# Modelo Robusto  para Problema de Classificação
# Data: 22/ Agosto/2024
# Nome: Ricardo Soares Oliveira 



function calcular_metricas(modelo, C, x, xo, y_real, beta, variacao)
  n = length(x)
  w = x 
  wo = xo 
  FO = JuMP.objective_value(modelo)

  for j = 1:n 
      w[j] = JuMP.value(x[j])
  end 

  w = [w[j] for j in 1:n]
  
  # Calcular o Hiperplano 
  c = Matrix(C)
  y_modelo = c * w 
  y_predito = y_modelo .>= wo 
  y_pred = y_modelo .== wo 

  # Calculando TP, FN, FP, TN 
  TP = sum((y_real .== 1) .& (y_predito .== 1))
  FN = sum((y_real .== 1) .& (y_predito .== 0))
  FP = sum((y_real .== 0) .& (y_predito .== 1))
  TN = sum((y_real .== 0) .& (y_predito .== 0))

  # Calculando a precisão e recall
  accuracy = (TP + TN) / (TP + FN + FP + TN)
  precision = TP / (TP + FP)
  recall = TP / (TP + FN)
  f1_score = 2 * (precision * recall) / (precision + recall)

  # Imprimindo os resultados
  println("=============================================================")
  println("                      Teste do Modelo GP_1 - $variacao                   ")
  println("=============================================================")
  println("Função Objetivo = ", FO)
  println("Variáveis  = ", x)
  println("Hiperplano + beta = ", wo + beta)
  println("Hiperplano       = ", wo)
  println("Hiperplano - beta = ", wo - beta)
  println("--------------------------------------------------------------")
  println("                      Matriz de Confusão                        ")
  println("--------------------------------------------------------------")
  println("|| True Positive  (TP)  = ", TP, " | False Negative (FN)  = ", FN, " ||")
  println("|| False Positive (FP)  = ", FP, " | True Negative  (TN) =  ", TN, " ||") 
  println("---------------------------------------------------------------")
  println("Acurácia    =  ", accuracy)
  println("Precisão    =  " , precision)
  println("Recall      =  ", recall)
  println("F1Score     =  ", f1_score)
  println("==================================================================")

  # Salvando os resultados em um arquivo de texto
  open("resultados_gp1_$variacao.txt", "a") do file
      write(file, "=============================================================\n")
      write(file, "                      Teste do Modelo GP_1 - $variacao                  \n")
      write(file, "=============================================================\n")
      write(file, "Função Objetivo = $FO\n")
      write(file, "Variáveis      = $x\n")
      write(file, "Hiperplano + beta  = $(wo + beta)\n")
      write(file, "Hiperplano      = $wo\n")
      write(file, "Hiperplano - beta  = $(wo - beta)\n")
      write(file, "--------------------------------------------------------------\n")
      write(file, "                      Matriz de Confusão                     \n")
      write(file, "--------------------------------------------------------------\n")
      write(file, "|| True Positive (TP) = $TP  | False Negative (FN) = $FN ||\n")
      write(file, "|| False Positive (FP) = $FP | True Negative (TN) = $TN  ||\n")
      write(file, "--------------------------------------------------------------\n")
      write(file, "Acurácia    = $accuracy\n")
      write(file, "Precisão    = $precision\n")
      write(file, "Recall      = $recall\n")
      write(file, "F1Score     = $f1_score\n")
      write(file, "==================================================================\n")
  end 
end



