# Parâemtros exemplo Robusto Kutcha 

A = [3 7 5;6 5 7;3 6 5;-28 -40 -32]; # matriz A
a = [0.3 0.7 0.5;0.6 0.5 0.7;0.3 0.6 0.5;-2.8 -4.0 -3.2]
b = [200; 200; 200;-1500];         # demanda 
c = [1 1 1 1];  
# parametros 
gama =[1, 1, 1, 1]                # custo 
(m,n) = size(A)

include("modeloMRob.jl")
linear_robusto(A,b,c,m)