function [v,lambda] = puissance(A)

EPS = 0.00001; % utilise dans la condition d'arret
NMAXIT = 10000; % maximum d'itérations avant que l'on ne considère que l'algorithme ne converge pas

[n m] = size(A);
v = rand(m,1); % vecteur initial arbitraire
               % si l'algorithme ne converge pas, on relance pour avoir un autre v
%initialisations
b1 = 0;
b0 = 1;
nit = 0;

 
% boucle de calcul
while ((nit < NMAXIT) && ((norm(b1-b0)/norm(b0)) > EPS)) 
    y = A*v;
    v = y/norm(y); % les v convergent vers le vecteur propre associe à lambda
    b0 = b1;
    b1 = transpose(v)*A*v;
end

lambda = b1;