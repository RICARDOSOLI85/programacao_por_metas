# Modelo Robusto  para Problema da demanda
# Data: 27/Junho/2024
# Nome: Ricardo Soares Oliveira 

using JuMP
using Gurobi


# Função para resolver o modelo 

function linear_robusto(A,b,c,gama)
    # criar o modelo
    modelo = Model(Gurobi.Optimizer)
    
    # numero de variaveis
    n = length(c); 
    m,n = size(A); 

    # parametros 
    
    # variaveis
    @variable(modelo, x[1:n]>=0)
    @variable(modelo, pos[1:m]>=0)
    @variable(modelo, neg[1:m]>=0)
    @variable(modelo, p[1:m,1:n]>=0)
    @variable(modelo, z[1:m]>=0)
    
   

    # função Objetivo
    @objective(modelo,Min, sum(c[i]*pos[i] for i in 1:m))

    # restrições
    @constraint(modelo, rest1[i in 1:m], 
    sum(A[i,j]*x[j] for j in 1:n)+ 
    sum(p[i,j] for j in 1:n)- 
    pos[i] + 
    neg[i] + 
    gama[i]*z[i] ==b[i])

    @constraint(modelo, rest2[i in 1:m,  j in 1:n],
    z[i] + p[i,j] >=   a[i,j]*x[j])
 
    
 
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
        open(arquivo_resultados, "w") do resultado_arquivo
            println(resultado_arquivo, resultados)
        end
end

  

end 
