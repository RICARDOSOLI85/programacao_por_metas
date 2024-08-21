# Modelo Robusto  para Problema de Classificação
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi 


#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function gp_det(C,ca,cb,alpha,beta)
    # leitura 
    (m,n) = size(C);
    n1 = size(ca,1);
    n2 = size(cb,1); 

    println("---------Impressão dados de Entrada--------")
    println("Alpha = ", alpha)
    println("Beta  = ", beta)
    println("Conj. treino (n)  = ", n)
    println("Dados de Teste    = ", n1+n2)
    println("Positivos CA (n1) = ", n1)
    println("Negativos CB (n2) = ", n2)
    println("------------------------------------------------")

    # modelo
    modelo = JuMP.Model(Gurobi.Optimizer)

    #Variáveis 
    @variable(modelo, 0 <= x[j=1:n] <= 1)      #A
    #@variable(modelo, -1 <= x[j=1:n] <= 1)    #B
    #@variable(modelo,x[j=1:n])                #C
    #@variable(modelo,x[j=1:n]<= 9)            #D
    @variable(modelo, x0) 
    @variables(modelo,
    begin 
    n_a[1:n1] >= 0
    n_b[1:n2] >= 0 
    p_a[1:n1] >= 0
    p_b[1:n2] >= 0
    end 
    )

    # função Objetivo 
    @objective(modelo, Min, sum(n_a[i] for i=1:n1) + sum(p_b[i] for i=1:n2))

    # restrições
    @constraints(modelo,
    begin 
    ca[i=1:n1], sum(ca[i,j]*x[j] for j in 1:n) + n_a[i] - p_a[i] == x0 
    cb[i=1:n2], sum(cb[i,j]*x[j] for j in 1:n) + n_b[i] - p_b[i] == x0 
    end
    )
    @constraint(modelo, sum(x[j] for j in 1:n) ==1)

    # solve modelo
    optimize!(modelo)

    # print modelo 

   JuMP.all_variables(modelo)
   num_variables(modelo)
   #println(modelo)
   FO = JuMP.objective_value(modelo)
   xo = JuMP.value(x0)
   x  = JuMP.value.(x)
   println("-------------Imprimindo a Solução do Modelo---------")
   println("F[O] = ",  FO)
   println("x[0] = ",  xo)
   for i=1:n 
   println("x[$i] = ", JuMP.value.(x[i]))
   end
   
   return FO, xo, x, modelo 

end 
  #=         

   #------------Calculando as Métricas---------------------
   w = zeros(n)
   w0 = JuMP.value(x0)
   for j=1:n 
    w[j] = JuMP.value(x[j])
   end 

   w = [w[j] for j in 1:n]
   c = Matrix(C)

   #-------------- Calculando o Hiperlano ----- 
   y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
   y_modelo = c*w
   y_predito = y_modelo.>=  w0
   y_pred = y_modelo .==  w0  
   println("y_predito = ", y_predito)
   println("y_pred = ", y_pred)
   println("w0 = ", w0 )

   # Calculando TP, FN, FP,TN 
   TP = sum((y_real .==1) .& (y_predito .==1))
   FN = sum((y_real .==1) .& (y_predito .==0))
   FP = sum((y_real .==0) .& (y_predito .==1))
   TN = sum((y_real .==0) .& (y_predito .==0))
   println("TP = ", TP)
   println("FN = ", FN)
   println("FP = ", FP)
   println("TN = ", TN)
   ERc1 = sum((y_real .==1) .& (y_pred .==1))
   ERc2 = sum((y_real .==0) .& (y_pred .==1))
   # Estão sobre o hiperplano 
   Indef = ERc1+ERc2 
   println("Erro Classe A = ", ERc1)
   println("Erro Classe B = ", ERc2)
   println("Indefindos    = ", Indef)
   # Correção do Falso Positivo pois ele conta os da classe B que estão na linha 
   # Falso Positivo correto 
   FPc = FP - ERc2
   println("FPc = ", FPc)
   
end


=#