function [v,lambda] = puissance_iteree(A,m)

% A matrice dont on cherche les valeurs propres
% m nombre de couples (vecteur, valeur) recherches

%initialisations
a = length(A);
v = ones(a);
lambda = ones(a,1);


[v(:,1) lambda(1)] = puissance(A);
W = v(:,1)/norm(v(:,1));
A = A - lambda(1)*W*transpose(W);
for i = 2:m
    
    A = A - lambda(i)*W*transpose(W);
   [v(:,i) lambda(i)] = puissance(A);
   
    W = v(:,i)/norm(v(:,i));
  
end

