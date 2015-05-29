                           --*****************************--
                           --**       Projet ADA        **--
                           --**      Package Velo       **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--**   Codage Package d'implantation pour la gestion des listes de velo    **--
--***************************************************************************--




--entrees/sorties put,get
with text_IO; use text_IO;
--Entrees/sorties sur les entiers put,get
with ada.integer_text_IO; use ada.integer_text_IO;
--Entrees/sorties sur les flottants put,get
with ada.float_text_IO; use ada.float_text_IO;


Package body velo is



--***********************************************--
--**      Implantation des sous-programmes     **--
--***********************************************--


--fonction creer_liste_vide
--semantique: cree une liste vide
--parametres: aucun
--type-retour: liste_velos
--pre-condition: aucune
--post-condition: l est vide
function creer_liste_vide return liste_velos is
begin
	return(NULL);
end creer_liste_vide;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_velos
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_velos) return boolean is
begin
	return l=NULL;
end est_vide;	


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non) un nouveau velo
--parametres: l donnee/resultat type liste_velos
--	      ident_station donnee type entier
--pre-condition: aucune
--post-condition: la liste a un nouveau velo en tete
procedure inserer_en_tete (l : IN OUT liste_velos; ident_station : IN integer) is
pins : liste_velos; --pointeur permettant d'inserer le nouveau velo
ident_velo : integer; --identificateur du nouveau velo
begin
	pins:=new velo;
	--definition de l'identificateur du velo : 0 ou le precedent incremente
	if l=NULL then ident_velo:=0;
		  else ident_velo:=l.ident_velo+1;
	end if;
	--creation du contenu du nouveau velo
	pins.all.ident_velo:=ident_velo;
	pins.all.ident_station:=ident_station;
	pins.all.ident_compte:=0;
	--insertion en tete de pins
	pins.all.suivant:=l;
	l:=pins;
end inserer_en_tete;


--procedure ajouter_velo
--semantique: ajoute un velo u la liste de velo en lui donnant le premier 
--identificateur non utilise
--parametres: l donnee/resultat type liste_velos
--pre-condition: aucune
--post-condition: la liste comporte un velo de plus
procedure ajouter_velo (l : IN OUT liste_velos) is
pins : liste_velos; --pointeur de parcours
pecr : liste_velos; --pointeur d'ecriture
ident_station : integer; --identificateur de la station du velo
interieur : boolean; --vrai si il y a un "trou" dans la liste
begin
	pins:=new velo;
	pecr:=new velo;
	interieur:=false;
	--acquisition de la station du velo
	put("Quel est le numero de la station dans laquelle le velo est depose? ");
	get(ident_station);
	new_line;
	--inserer le velo en lui donnant le premier identificateur non utilise

	--cas ou la liste est vide ou ne contient qu'un seul velo
	if l=NULL then inserer_en_tete(l, ident_station); --1er velo pour liste vide
		  else if l.suivant=NULL then --1er velo si ident du 2eme velo non nul sinon 2eme velo
					      if l.ident_velo=0 then inserer_en_tete(l, ident_station);
							        else inserer_en_tete(l.suivant, ident_station);
					      end if;
		       else --sinon on parcours la liste a la recherche du premier element non utilise
			    pins:=l; 
			    pecr:=l;
			    while not (pins=NULL) loop
					if pins.suivant/=NULL then --si il y a un "trou" dans la liste, on change le pointeur d'ecriture
								   if pins.ident_velo-pins.suivant.ident_velo/=1 then pecr:=pins;
														      interieur:=true;
														 else NULL;
								   end if;
							      else --si le dernier element n'est pas nul, idem
								   if pins.ident_velo/=0 then pecr:=pins;
											      interieur:=true;
										         else NULL;
								   end if;
					end if;
					pins:=pins.suivant;
			    end loop;
			    --pins=NULL
			    --si il y a un "trou", on insere dans ce trou, sinon en tete
			    if interieur then inserer_en_tete(pecr.suivant, ident_station);
				         else inserer_en_tete(l, ident_station);
			    end if;
		       end if;
	end if;
	--afficher le numero du nouveau velo
	put("Le nouveau velo est bien cree, c'est le numero ");
	put(pecr.ident_velo,1);
	new_line;
end ajouter_velo;		


--procedure afficher_liste_velo
--semantique: affiche les identifiants des velos de la liste
--parametres: lcourant donnee/resultat liste_velos
--pre-postcondition: aucune
procedure afficher_liste_velo (l : IN OUT liste_velos) is
begin
	--test cas terminal
	if l/=NULL then	put(l.ident_velo,1);
			new_line;
			afficher_liste_velo(l.suivant);
		   else NULL;
	end if;
end afficher_liste_velo;


--procedure afficher_liste_velo_dispo
--semantique: afficher les velos de la liste l present dans la station ident_station
--parametres: lcourant donnee type liste_velos
--	      ident_station donnee type entier
--pre-postcondition: aucune
procedure afficher_liste_velo_dispo (lcourant : IN liste_velos; ident_station : IN integer) is
begin
	--parcours de liste avec test d'appartenance du velo a chaque station
	if not(lcourant=NULL) then if lcourant.all.ident_station=ident_station then put(lcourant.all.ident_velo,1);
			   							    new_line;
									       else NULL;
				   end if;
				   afficher_liste_velo_dispo(lcourant.all.suivant, ident_station);
			      else NULL;	
	end if;
end afficher_liste_velo_dispo;


--fonction rechercher
--semantique: recherche si ident_velo est present dans la liste l et retourne son adresse ou null
--            si la liste est vide ou si e n'appartient pas u la liste
--parametres: l donnee type liste_velos
--            ident_velo donnee type entier
--type-retour: liste_velos
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_velos; ident_velo : IN integer) return liste_velos is
lcourant : liste_velos; --pointeur de parcours
begin
	lcourant:=new velo;
	lcourant:=l;
	while not (lcourant=NULL) and then not (lcourant.all.ident_velo=ident_velo) loop
		lcourant:=lcourant.all.suivant;
	end loop;
	--courant=NULL ou courant.all.ident=ident_velo
	return lcourant;
end rechercher;


--procedure enlever_velo
--semantique: enlever un element ident_velo de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type liste_velos
--            ident_velo donnee type entier
--pre-condition: aucune
--post-condition: ident_velo n'appartient pas u la liste
procedure enlever_velo (l : IN OUT liste_velos; ident_velo : IN integer) is
point : liste_velos; --pointeur vers le velo courant
psuppr : liste_velos; --pointeur de suppression
begin
	point:=New velo;
	point:=rechercher(l, ident_velo);
	--test d'existance du velo
	if (point=NULL) then put_line("Ce velo n'existe pas");
		     else psuppr:=new velo;
			  psuppr:=l;
			  while not (psuppr.all.suivant.all.ident_velo=ident_velo) loop
				psuppr:=psuppr.all.suivant;
			  end loop;
			  --psuppr.suivant.ident_velo=ident_velo
			  psuppr.all.suivant:=psuppr.all.suivant.all.suivant;--suppression de l'element une fois atteint
	end if;
end enlever_velo;


--procedure retirer_velo
--semantique: donner au velo 0 comme emplacement et le compte de l'utilisateur
--parametres: l donnee/resultat type liste_velos
--	      ident_velo donnee type entier
--	      ident_station_courante donnee type entier
--	      ident_compte donnee type entier
--pre-condition: aucune
--post-condition: l'emplacement du velo est 0
procedure retirer_velo (l : IN OUT liste_velos; ident_velo : IN integer; ident_station : IN integer; ident_compte : IN integer) is
laux : liste_velos; --pointeur vers le velo courant
begin
	laux:=rechercher(l, ident_velo);
	--test d'existance du velo
	if laux=NULL then put_line("Ce velo n'existe pas");
			   --test d'emplacement du velo (loue ou ailleurs)
		      else if laux.ident_station=0 or not (laux.ident_station=ident_station)
						then put_line("Ce velo n'est pas dans cette station");
						     new_line;
			   --sinon changement de l'emplacement et de l'utilisateur du velo
			   else laux.ident_station:=0;
				laux.ident_compte:=ident_compte;
			   end if;
	end if;
end retirer_velo;


--procedure deposer_velo
--semantique: donner au velo la station comme emplacement et 0 comme compte d'utilisateur
--parametres: l donnee/resultat type liste_velos
--	      ident_velo donnee type entier
--	      ident_station donnee type entier
--	      ident_compte donnee type entier
--pre-condition: aucune
--post-condition: l'emplacement du velo est la station courante
procedure deposer_velo (l : IN OUT liste_velos; ident_velo : IN integer; ident_station : IN integer; ident_compte : IN integer) is
laux : liste_velos; --pointeur vers le velo courant
begin
	laux:=new velo;
	laux:=rechercher(l, ident_velo);
	--test d'existance du velo
	if laux=NULL then put_line("Ce velo n'existe pas");
			   --test la location du velo     --test l'identite de l'utilisateur du velo
		      else if (laux.ident_station=0) then if not (laux.ident_compte=ident_compte)
										then put_line("Vous n'etes pas l'utilisateur qui a loue ce velo");
										     new_line;
										--sinon changement de l'emplacement du velo
										else laux.ident_station:=ident_station;
							  end if;
						
						     else put_line("Ce velo n'a pas ete loue");
							  new_line;
			   end if;
	end if;
end deposer_velo;






--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--



--procedure init_velo
--initialise la liste des velos
--parametres: l resultat type liste_velos
--pre-postconditions: aucune
procedure init_velo (l : OUT liste_velos) is
begin
--4 velos dans la station 1
	for i in 1..4 loop
		inserer_en_tete(l, 1);
	end loop;
--5 velos dans la station 2
	for i in 1..5 loop
		inserer_en_tete(l, 2);
	end loop;
--0 velos dans la station 3
--1 velos dans la station 4
	inserer_en_tete(l, 4);
end init_velo;

end velo;
