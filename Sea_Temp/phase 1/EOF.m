function EOF(datafile,doplot,threshold)
% datafile = name of the file containing data or 'gendata' to use the synthetic data generator
% doplot = true if plots are requested
% threshold = threshold for filtering eigenvalues, in terms of percentage of variability to be recovered

if (threshold < 0 || threshold > 100)
    fprintf('Erreur, threshold < 0 ou > 100. threshold est un pourcentage');
    return
end


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
 mydata=gendata(nx,ny,nt,neof,addnoise);
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


[n,p1,p2] = size(F);
X = reshape(F,n,p1*p2);
Xbar= mean(X,1); % vecteur ligne contenant les moyenes de chaque colonne
Xprime = X-ones(n,1)*Xbar; % matrice des ecarts a la moyenne

Sigma = (1/n-1)*transpose(Xprime)*Xprime; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%CALCUL DES VALEURS PROPRES DE SIGMA%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialisations
p = p1*p2;
EOFs = zeros(p);
lambda = zeros(p,1);
sigmabis = Sigma; % on conserve sigma en memoire
somme_lambda = trace(sigmabis);
poids_total = 0;
%poids_total = poids_total

i = 1;
while poids_total < threshold
    
    %calcul de la ieme valeur propre et du vecteur propre associe
    [EOFs(:,i) lambda(i)] = puissance(sigmabis);
    
    %deflation
    W = EOFs(:,i)/norm(EOFs(:,i));
    sigmabis = sigmabis - lambda(i)*W*transpose(W);
    
    %incrementation du poids total
    poids_total = poids_total + (100*lambda(i)/somme_lambda);
    poids_total = poids_total
    i = i+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%FIN CALCUL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
PC =  Xprime*EOFs; %Calcul des PC
norm(PC)
length(PC)
% Animated plot (can be very long, use with care...)
if(doplot)
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
