# Modelo Robusto  para Problema Saúde 
# Data: 26/Agosto/2024 
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi


#=======================================================#
#  Modelo de programação de Metas #
#======================================================#

function gp_rob_1(C,ca,cb,ca_hat,cb_hat,alpha,gama)
       
    # numero de variáveis
    (n,m) = size(C); 
    n1 = size(ca,1);
    n2 = size(cb,1); 

    # parametros 
    alpha = alpha; 
    gama = gama; 

    # criando duas variantes de gama
    gama_a = gama[1:n1]; 
    gama_b = gama[1:n2]; 

    # criar o modelo
    modelo = JuMP.Model(Gurobi.Optimizer)
    
    # Variaveis
    @variable(modelo, 0 <= x[1:n] <=1) 
    @variable(modelo, xo_target)              
    @variables(modelo,                
    begin
        pos_a[1:n1] >= 0 
        pos_b[1:n2] >= 0
        neg_a[1:n1] >= 0 
        pos_b[1:n2] >= 0
    end)
    # variáveis do modelo Robusto
    @variables(modelo, 
    begin
        p_a[1:n1,1:m] >= 0 
        p_b[1:n2,1:m] >= 0 
        z_a[1:n1]     >= 0
        z_b[1:n2]     >= 0
    end)
    
   

    # função Objetivo
    @objective(modelo,Min, sum(neg_a[i] for i=1:n1) + sum(pos_b[i] for i=1:n2))

    # Restrições
    @constraint(modelo, rest1[i in 1:m], 
    sum(A[i,j]*x[j] for j in 1:n)+ 
    sum(p[i,j] for j in 1:n)- 
    pos[i] + 
    neg[i] + 
    gama[i]*z[i] ==b[i])

    # restrições 
    @constraints(modelo, 
    begin
    rest1[i=1:n1], sum(ca[i,j]*x[j] for j in 1:m) + 
    sum(p_a[i,j] for j in 1:m) + 
    neg_a[i] - pos_a[i] + 
    gama_a[i] * z_a[i] == xo_target
    rest2[i=1:n2], sum(cb[i,j]*x[j] for j in 1:m)+
    sum(p_b[i:j] for j in 1:m) +
    neg_b[i] - pos_b[i] + 
    gama_b[i] * z_b[i] == xo_target  
    end
    )

    @constraints(modelo, 
    begin
        rest3[i in 1:n1, j in 1:m], z_a[i] + p_a[i,j] >= ca_hat[i,j] * x[j]
        rest4[i in 1:n2, j in 1:m], z_b[i] + p_b[i,j] >= cb_hat[i,j] * x[j]
    end)

    @constraint(modelo, rest5[1:m], sum(x[j] for j in 1:m) ==1)
   
    # resolver 
    optimize!(modelo)

    # Função para salvar os arquivos 

     function salvar_resultados(resultados, arquivo_resultados)
        resultado_arquivo = open(arquivo_resultados,"a")
        println(resultado_arquivo,resultados)
        close(resultado_arquivo)        
     end

     # Verificar a solução
    resultados = "Impresão dos resultados \n"
    resultados *= "Modelo : RGP \n"
    resultados *= "Valores de Gamma = $gama \n"
    resultados *= "--------Status da Solução-------\n"

    if termination_status(modelo) == MOI.OPTIMAL
        println("Solução ótima encontrada")
        println("Status = ", termination_status(modelo))
        println("Objetivo = ", objective_value(modelo)) 
        
        #resultados *= "Status: Solução Ótima\n" 
        resultados *= "[Objetivo] = $(objective_value(modelo))\n"
        resultados *= "---------------------------------------\n"
        resultados *= "Status =  $(termination_status(modelo))\n"
        resultados *= "Tempo Solução  = $(solve_time(modelo))\n" 
        

        println("")
        
        for i in 1:n
            println("x[$i] = ", value(x[i]))
            resultados *= "x[$i] = $(value(x[i]))\n"
        end
        resultados *= "...................................\n"
        for j in 1:m
            println("pos[$j] = ", value(pos[j]))
            println("neg[$j] = ", value(neg[j]))
            resultados *= "pos[$j] = $(value(pos[j]))\n"
            resultados *= "neg[$j] = $(value(neg[j]))\n"
            
        end
         resultados *= "*-Fim do resultados do Teste-*\n "
      
    else
        println("Solução não ótima ou erro")
        return nothing, nothing, nothing, nothing

        salvar_resultados(resultados, "resultados_1.txt")
    end
    
    
    salvar_resultados(resultados, "resultados_1.txt")

    # Função para salvar os resultados em um arquivo
    function salvar_resultados(resultados, arquivo_resultados)
        open(arquivo_resultados, "a") do resultado_arquivo
            println(resultado_arquivo, resultados)
        end
end

  

end 
