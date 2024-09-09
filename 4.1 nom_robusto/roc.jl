using Plots

C = [1 1;2 2;3 1;3 3;6 3;4 1;5 2;7 2;8 4;9 1];
y_real = [1; 1; 1; 1; 1;0 ;0 ;0 ;0 ;0];
ca = C[1:5,:]; 
cb = C[6:10,:]; 


# parâmetros 
alpha =1.0;

# Lista de Modelso e  variações
variacao = "C"

# dados 
C_treino = C 
ca = ca
C_teste = C
# Calcular desvio 
epsilon = 0.1; 
gama = 3.0 
tipo = "sb"

include("matrizes.jl")
ca_desvio,cb_desvio=calcular_desvios(ca::Matrix{Int64},cb::Matrix{Int64},epsilon::Float64)

include("gama.jl")
gama_a, gama_b = cria_vetor_gama(ca::Matrix{Int64},cb::Matrix{Int64},gama::Float64)

# Função para calcular TPR e FPR
function calculate_roc(y_true, y_pred)
    thresholds = sort(unique(y_pred), rev=true)
    TPR, FPR = [], []
    
    for threshold in thresholds
        TP = sum((y_pred .>= threshold) .& (y_true .== 1))
        FP = sum((y_pred .>= threshold) .& (y_true .== 0))
        FN = sum((y_pred .< threshold) .& (y_true .== 1))
        TN = sum((y_pred .< threshold) .& (y_true .== 0))
        
        push!(TPR, TP / (TP + FN))
        push!(FPR, FP / (FP + TN))
    end

    # Calcular a AUC (Área Sob a Curva) usando integração trapezoidal
    auc = sum(diff(FPR) .* (TPR[1:end-1] .+ TPR[2:end]) / 2)
    
    return FPR, TPR, auc 
end

# Valores de beta para testar

betas = [0.1, 0.5, 1.0, 2.0]
cores = [:blue, :green, :red, :purple]  # Cores para diferenciar as curvas

# Inicializa o gráfico
roc_plot = plot(title="Curva ROC: Robusto M2-C3", xlabel="False Positive Rate", ylabel="True Positive Rate",legend=:bottomright)

# Plotar as curvas ROC para diferentes valores de beta
for (i, beta) in enumerate(betas)
    include("RGP_2.jl")
    FO, modelo, tar, sol=robusto_modelo_2(
                                        C_treino::Matrix{Int64},
                                        ca::Matrix{Int64},
                                        cb::Matrix{Int64},
                                        alpha::Float64,
                                        beta::Float64,
                                        ca_desvio::Matrix{Float64},
                                        cb_desvio::Matrix{Float64},
                                        gama_a::Vector{Float64},
                                        gama_b::Vector{Float64},
                                        variacao::String
                                )
    
    # Calcular o vetor de predições
    y_modelo = C * sol
    
    # Calcular FPR e TPR
    #FPR, TPR = calculate_roc(y_real, y_modelo)
    # Calcular FPR, TPR e AUC
    FPR, TPR, auc = calculate_roc(y_real, y_modelo)

    
    # Adicionar a curva ROC ao gráfico
    #plot!(roc_plot, FPR, TPR, label="beta = $beta", color=cores[i], linewidth=2)
    # Adicionar a curva ROC ao gráfico
    # Adicionar a curva ROC ao gráfico
    plot!(roc_plot, FPR, TPR, label="beta = $beta (AUC = $(round(auc, digits=2)))", color=cores[i], linewidth=2)
end



# Adicionar linha diagonal de referência (0,0) a (1,1)
plot!(roc_plot, [0, 1], [0, 1], linestyle=:dash, color=:black, label="Linha de chance")
    


# Mostrar o gráfico final
display(roc_plot)
