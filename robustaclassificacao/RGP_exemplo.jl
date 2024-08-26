# Parâemtros exemplo Robusto Kutcha 

ca = [3 7 5;6 5 7;3 6 5;-28 -40 -32]; # matriz A
ca_hat = [0.3 0.7 0.5;0.6 0.5 0.7;0.3 0.6 0.5;2.8 4.0 3.2]
#b = [200; 200; 200;-1500];         # demanda 
#c = [1 1 1 1];  
#....................................
C = [3 7 5;6 5 7;3 6 5;-28 -40 -32];
ca = [3 7 5;6 5 7];
cb = [3 6 5;-28 -40 -32]; 
ca_hat = [0.3 0.7 0.5;0.6 0.5 0.7]
cb_hat = [0.3 0.6 0.5;2.8 4.0 3.2]
alpha = 1 
gama = 2 
include("RGP_M1.jl")
gp_rob_1(ca,ca_hat,alpha,gama)

# parametros 
Gamma = [1,2,5,7,10,13]
for gama in Gamma 
    include("RGP_M1.jl")
    gp_rob_1(C,ca,cb,ca_hat,cb_hat,alpha,gama)
end 