%% Constantes
L = 2.3 * 10 ^(-3);
R = 1.2;
Km = 60 * 10^(-3);
Kfem = 60 * 10^(-3);
J = 9.2 * 10^(-5);
f0 = 4.2*10^(-4);
f1 = 3 * 10^(-4);
Valim = 35;
H = 0.2;
Iref = 2;
Fd=4000;
Td = 250 * 10^(-6);
wbpc=2*pi*Fd/sqrt(10);
Kic=L*wbpc;
Tic=(sqrt(10))/wbpc;
Borne_saturation=Valim;
E = Valim;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paramètres du système (séance 2) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = -f0/J;
B = Km/J;
C = 1;

wpb = -40;

Kinterm = acker([A, 0;-C, 0], [B;0], [wpb, wpb]);
Kt = Kinterm(1);
Kr = Kinterm(2);

g1 = Kr / wpb;
g2 = 1/(-C*(A-B*Kt)^(-1)*B);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paramètres du système (séance 2 - partie 2) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K2emepart = acker([-R/L, -Kfem/L, 0; Km/J, -f0/J, 0; 0, -C, 0], [2*Valim/L;0;0], -[400, 40, 40]);
Kt2 = K2emepart(1:2);
Kr2 = K2emepart(3);

g12 = Kr2 / -400;
g22 = 1/([0, -C]*([-R/L, -Kfem/L; Km/J, -f0/J]-[2*Valim/L;0]*Kt2)^(-1)*[2*Valim/L;0]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paramètres du système (séance 3) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Te = 250*10^(-6);
Fe = 1/Te;

wbp3 = 15;
zbp3 = exp(-wbp3*Te);

[F3, G3, C3, D3] = c2dm(A, B, C, [0], Te);
K3 = acker([F3, 0; -C3, 1], [G3; 0], [zbp3, zbp3]);

Kt3 = K3(1);
Kr3 = K3(2);

g13 = Kr3 / (zbp3 - 1);
g23 = 1/(C3*((1-(F3-G3*Kt3))^(-1))*G3);