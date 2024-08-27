# Métricas para o resultado do modelo
# Nome: Ricardo Soares Oliveira
# Data 27/Agosto/2024 

function calcular_metricas(C,y_real,FO,modelo,tar,sol)
    
    # leitura
    n = length(sol)
    
    # Calcular o hiperplano 
    c = Matrix(C); 
    y_modelo = c * sol; 
    println("vetor hiperplano =" , y_modelo)  
    
end