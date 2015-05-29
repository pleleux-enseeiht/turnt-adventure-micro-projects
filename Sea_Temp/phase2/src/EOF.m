function EOF(datafile,doplot,threshold,version)
% datafile = name of the file containing data or 'gendata' to use the synthetic data generator
% doplot = true if plots are requested
% threshold = threshold for filtering eigenvalues, in terms of percentage of variability to be recovered

!ifort -c -O -fPIC -vec-report0 m_subspace_iter.f90
mex mex_subspace_iter.F90 subspace_iter.f90 m_subspace_iter.f90  FC="ifort" FFLAGS="-O -fPIC -vec-report0" CC="" LD="ifort" FLIBS="-L/applications/matlabr2011a/bin/glnxa64 -lmx -lmex -lmat -lm -L/mnt/n7fs/ens/tp_guivarch/opt/OpenBLAS/ -lopenblas";

close all;


if(~strcmp(datafile,'gendata'))
 % Load data file; the field is in F, coordinates are in lat and lon
 fprintf('Loading data...\n');
 load(datafile);
else
 % Use the synthetic data generator
 nx=24;
 ny=24;
 nt=200;
 neof=4;
 addnoise=0;
 mydata=gendata(nx,ny,nt,neof,0);
 lon=1:nx;
 lat=1:ny;
 time=1:nt;
end

nx=length(lon);
ny=length(lat);
nt=length(time);

%% 1/ EOF on the whole data minus last year.
F=mydata(1:nt-12,:);

% Remove undefined values
F(F==-32768)=0;

% Animated plot (can be very long, use with care...)
if(1==0)
  figure; 
  fprintf('ENTER to go on\n');
  pause;
  fprintf('Displaying...\n');
  for i=1:nt-12
    mi=min(min(F(i,:)));
    ma=max(max(F(i,:)));
    if(mi~=ma)
      myfig = reshape(F(i,:),ny,nx);
      %contour(lon,lat,myfig,mi:(ma-mi)/30:ma);
      imagesc(myfig(end:-1:1,:),[mi ma]);
      drawnow;
    end
    if(mod(i,100)==0)
      stopplot=input('0 to stop, ENTER to go on.\n');
      if(stopplot==0)
        break;
      end
    end
  end
  fprintf('ENTER to go on\n');
  pause;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Initialisations%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Formatage de F en 2D --> X
[n,p1,p2] = size(F);
X = reshape(F,n,p1*p2); 
Xbar= mean(X,1); % vecteur ligne contenant les moyennes de chaque colonne

% Compute the anomaly matrix Z from F
Z = X-ones(n,1)*Xbar;

%Compute the covariance matrix
S = transpose(Z)*Z;

%initialisations
V = zeros(p);
D = zeros(p,1);
maxit = 10000;
epsilon=1e-5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Calcul des EOFs, des PCs et de n_ev%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


		if version == 3

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%Version Matlab V0%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fprintf('Computing EOFs with version Matlab\n');
		tic;
		[v0, d0] = eig(S);
		v0 = flipdim(v0,2);
		d0 = flipdim(d0,2);
		d0 = flipdim(d0,1);
		%Calcul du nombre d'EOFS a conserver en fonction du seuil
		n_ev = 0;
		somme = 0;
		traceS = trace(S);
		while (somme<threshold)
			n_ev = n_ev+1;
			somme = somme + 100*(d0(n_ev,n_ev)/traceS); 
		end
		%On garde les n_ev premiers vecteurs propres et premieres valeurs propres
		V = v0(:,1:n_ev);
		D = d0(1:n_ev,1:n_ev);
		D= diag(D);
		toc;
		end


		if version == 0

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%Version Fortran V0%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fprintf('Computing EOFs with version V0\n');
		%CrÃ©ation d'une famille de vecteurs alÃ©atoire
		v0=rand(nx*ny,10);
		tic;
		%appel de la fonction fortran V0
		[V, D, res_ev, it_ev, it, n_ev] = mex_subspace_iter(0, S, 1, v0, threshold, maxit, epsilon);
		toc;
		pause;
		end


		if version == 1		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%Version Fortran V1%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fprintf('Computing EOFs with version V1\n');
		%CrÃ©ation d'une famille de vecteurs alÃ©atoire
		v0=rand(nx*ny,10);
		tic;
		%appel de la fonction fortran V1
		[V, D, res_ev, it_ev, it, n_ev] = mex_subspace_iter(1, S, 1, v0, threshold, maxit, epsilon);
		toc;
		end

		if version == 2
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%Version Fortran V2%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		fprintf('Computing EOFs with version V2\n');
		%CrÃ©ation d'une famille de vecteurs alÃ©atoire
		v0=rand(nx*ny,10);
		tic;
		%appel de la fonction fortran V2
		[V, D, res_ev, it_ev, it, n_ev] = mex_subspace_iter(2, S, 1, v0, threshold, maxit, epsilon);
		toc;
		end

		%Calcul des PCs	
		PC=Z*V;

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%Affichage des EOFs et PCs%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(doplot)
		fprintf ('\nAffichage des EOFs et PCs significatifs\n');
		figure;

		%On affiche 4 EOFs maximum
		if (n_ev < 4)
			nbEOF = n_ev;
		else
			nbEOF = 4;
		end 		

		for i=1:nbEOF

			% affichage d'une EOF
			subplot (nbEOF,3,3*i-2);
			mi=min(min(V(:,i)));
			ma=max(max(V(:,i)));
			if(mi~=ma)
				myfigEOF = reshape(V(:,i),ny,nx);
				imagesc(myfigEOF(end:-1:1,:),[mi ma]);
				drawnow;
			end

			% affichage d'un PC	
			subplot (nbEOF,3,3*i-1);
			plot (PC(:,i));

			% zoom sur le PC
			subplot (nbEOF,3,3*i); 
			plot (PC(1500:1600,i));

		end
	end
	fprintf('ENTER to go on\n');
	pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Controle de la qualite des EOFs%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nQualite des EOFS\n');
erreureof = norm(Z*V*V'-Z, 2)/ norm(Z, 2);
fprintf('L erreur est %d', erreureof);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Comparaison avec une base alÃ©atoire%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Comparaison avec une base aleatoire : \n');
 %On genere une base aleatoire de rang >= n_ev
randV = rand(nx*ny,n_ev);
while rank(randV)<n_ev
	randV = rand(nx*ny,n_ev);
end 
randerreur = norm(Z*randV*randV'-Z, 2)/ norm(Z, 2)

if (erreurEof<randerreur)
	fprintf('L erreur avec une autre base est plus importante\n')
else
	fprintf('L erreur sur les EOFs est plus importante. Ce n est pas normal')
end

fprintf('\nENTER to go on with the predictions');
pause;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Prediction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%RÃ©cupÃ©ration des 12 derniers mois%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%on recupere les 12 derniers mois!!!!!!!!!!!
annee12 = mydata(nt-11:nt,:);
annee12(annee12==-32768)=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Suppression des donnÃ©es inconnues%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

percent = input('Entrez le pourcentage du nombre de colonnes a enlever : ');
colonnes_gardees = floor((percent/100)*nx*ny);

donneesConnues = annee12;
Vconnues = V;
for i=1:colonnes_gardees
	randColonne=ceil((nx*ny-i)*rand(1));
	donneesConnues(:,randColonne)=[];
	Vconnues(randColonne, :)=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%RÃ©solution d'une Ã©quation Ax=b pour trouver alpha%%%%%%%
%%%%%%%%%%%%%%et reconstruction de la solution%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars alpha;
alpha=Vconnues\donneesConnues';

%Reconstruction de la matrice de donnÃ©es en considÃ©rant alpha valable sur 
%les colonnes inconnues
prediction = alpha'*V';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Controle de la qualite des EOFs%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('QualitÃ© de la prÃ©diction : ');
erreurPrediction = norm(prediction-annee12, 'fro')/ norm(annee12,'fro')
fprintf('L erreur calculee est %d', erreurPrediction);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Comparaison avec une base alÃ©atoire%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Comparaison avec une base aleatoire : \n');
%On genere une base aleatoire de rang >= n_ev
randV = rand(nx*ny,n_ev); 
while rank(randV)<n_ev
	randV = rand(nx*ny,n_ev);
end

%On supprime les colonnes inconnues
randVconnues = randV;
for i=1:colonnes_gardees
	randColonne=ceil((nx*ny-i)*rand(1));
	randVconnues(randColonne, :)=[];
end

clearvars alpha;
alpha=randVconnues\donneesConnues';

%Reconstruction de la matrice de donnÃ©es en considÃ©rant alpha valable sur 
%les colonnes inconnues
randPrediction = alpha'*V';

randErreurPrediction = norm(randPrediction-annee12, 'fro')/ norm(annee12,'fro')
fprintf('L erreur calculee est %d', randErreurPrediction);
if (erreurPrediction<randErreurPrediction)
	fprintf('L erreur avec une autre base est plus importante')
else
	fprintf('L erreur sur les EOFs est plus importante. Ce n est pas normal')
end

end
