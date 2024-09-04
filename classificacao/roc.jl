using Plots

# Exemplo de dados
include("dados.jl")
arquivo = "exames.csv"
df = ler_csv(arquivo)

# 2. Dividir
include("dividir.jl")
df_treino, df_teste, C_teste, y_real_df = dividir_dados(df, 0.7)

# 3. Categorias
include("filtro.jl")
C_treino_a, ca_fil, cb_fil = dividir_categorias(df_treino)
include("balancear.jl")
C_treino_b, ca_bal, cb_bal = balancear_categorias(C_treino_a, ca_fil, cb_fil)

# Escolher o conjunto de dados (balanceado ou não)
#ca = ca_fil  # ou ca_bal
#cb = cb_fil  # ou cb_bal
ca = ca_bal;
cb = cb_bal;
C_df = C_teste

# Converter DataFrames para matrizes
C = Matrix(C_df)
y_real = Matrix(y_real_df)

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
roc_plot = plot(title="Curva ROC: Modelo2-D(cb)", xlabel="False Positive Rate", ylabel="True Positive Rate",legend=:bottomright)

# Plotar as curvas ROC para diferentes valores de beta
for (i, beta) in enumerate(betas)
    include("GP_2D.jl")
    FO, modelo, x_vals, xo_val = gp_det2D(C, ca, cb, 1.0, beta)  # alpha = 1.0
    
    # Calcular o vetor de predições
    y_modelo = C * x_vals
    
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



