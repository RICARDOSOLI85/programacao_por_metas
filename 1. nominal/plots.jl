using Plots

# Dados fornecidos
x1_blue = [1, 2, 3]
x2_blue = [1, 2, 1]

x1_red = [3, 6]
x2_red = [3, 3]

# Criação do gráfico com duas séries de cores diferentes
scatter(x1_blue, x2_blue, color = :blue, label = "Azul", markersize = 8)
scatter!(x1_red, x2_red, color = :red, label = "Vermelho", markersize = 8)

# Exibir o gráfico
display(plot!)