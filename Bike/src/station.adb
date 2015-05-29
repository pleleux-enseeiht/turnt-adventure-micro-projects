                           --*****************************--
                           --**       Projet ADA        **--
                           --**    Package Station      **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--** Codage Package d'implantation pour la gestion des listes des stations **--
--***************************************************************************--




--entrees/sorties put,get
with text_IO; use text_IO;
--Entrees/sorties sur les entiers put,get
with ada.integer_text_IO; use ada.integer_text_IO;
--Entrees/sorties sur les flottants put,get
with ada.float_text_IO; use ada.float_text_IO;
--Fonctions mathematiques usuelles pour les flottants
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

Package body station is


--***********************************************--
--**      Implantation des sous-programmes     **--
--***********************************************--

--fonction creer_liste_vide
--semantique: cree une liste vide
--parametres: aucun
--type-retour: liste_station
--pre-condition: aucune
--post-condition: la liste est vide
function creer_liste_vide return liste_station is
begin
	return(NULL);
end creer_liste_vide;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_station
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_station) return boolean is
begin
	return l=NULL;
end est_vide;


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non vide) une nouvelle station
--parametres: l donnee/resultat type liste_station
--	      nombre_velos_maximum donnee type entier
--	      nombre_velos donnee type entier
--	      x donnee type float
--	      y donnee type float
--pre-condition: aucune
--post-condition: la liste contient une nouvelle station
procedure inserer_en_tete (l : IN OUT liste_station; nombre_velos_maximum : in integer; nombre_velos : IN integer; x : IN float; y : IN float) is
pins : liste_station; --pointeur permettant d'inserer la nouvelle station
ident_station : integer; --identificateur de la nouvelle station
begin
	pins:=new station;
	--definition de l'identificateur de la station (1 ou le precedent incremente)
	if l=NULL then ident_station:=1;
		  else ident_station:=l.ident_station+1;
	end if;
	--creation du contenu du nouveau velo
	pins.all.ident_station:=ident_station;
	pins.all.nombre_velos_maximum:=nombre_velos_maximum;
	pins.all.nombre_velos:=nombre_velos;
	pins.all.x:=x;
	pins.all.y:=y;
	--insertion en tete de pins
	pins.all.suivant:=l;
	l:=pins;
	--afficher le numero du nouveau velo
	put("La nouvelle station est bien creee, c'est la numero ");
	put(ident_station,1);
	new_line;
	new_line;
end inserer_en_tete;


--procedure ajouter_station
--semantique: cree une nouvelle station en lui donnant le premier identificateur non utilise
--parametres: l donnee/resultat type liste_station
--pre-condition: aucune
--post-condition: la liste contient cette nouvelle station
procedure ajouter_station (l : IN OUT liste_station) is
nombre_velos_maximum : integer; --nombre maximum de velos de la nouvelle station
nombre_velos : integer; --nombre de velos initialement dans la station
x : float; --abscisse de la station
y : float; --coordonnees de la station
pins : liste_station; --pointeur de parcours
pecr : liste_station; --pointeur d'ecriture
interieur : boolean; --vrai si il y a un "trou" dans la liste
begin
	pins:=New station;
	pecr:=New station;
	--acquisition nu nombre de velos maximum
	put("Combien de velos y aura-t-il dans la station au maximum?");
	get(nombre_velos_maximum);
	new_line;
	--acquisition du nombre de velos => forcement inferieur au nombre de velos maximum	
	put("Combien de velos a l'installation?");
	get(nombre_velos);
	new_line;
	--acquisition des coordonnees de la station
	put_line("Quelles sont ses coordonnees?");
	put("coordonnees en x :");
	get(x);
	new_line;
	put("coordonnees en y :");
	get(y);
	new_line;
	interieur:=false;
	--inserer la station en lui donnant le premier identificateur non utilise

	--cas ou la liste est vide ou ne contient qu'une seule station
	if l=NULL then inserer_en_tete(l, nombre_velos_maximum, nombre_velos, x, y); --1ere station pour liste vide
		  else if l.suivant=NULL then --1ere station si ident de la 2eme station non nul sinon 2eme station
					      if l.ident_station=1 then inserer_en_tete(l, nombre_velos_maximum, nombre_velos, x, y);
							     else inserer_en_tete(l.suivant, nombre_velos_maximum, nombre_velos, x, y);
					      end if;
		       else --sinon on parcours la liste a la recherche du premier element non utilise
			    pins:=l;
			    pecr:=l;
			    while not (pins=NULL) loop
					if pins.suivant/=NULL then --si il y a un "trou" dans la liste, on change le pointeur d'ecriture
								   if pins.ident_station-pins.suivant.ident_station/=1 then pecr:=pins;
															    interieur:=true;
														       else NULL;
								   end if;
							      else --si le dernier element n'est pas nul, idem
								   if pins.ident_station/=1 then pecr:=pins;
												 interieur:=true;
										      else NULL;
								   end if;
					end if;
					pins:=pins.suivant;
			    end loop;
			    --pins=NULL
			    --si il y a un "trou", on insere dans ce trou, sinon en tete
			    if interieur then inserer_en_tete(pecr.suivant, nombre_velos_maximum, nombre_velos, x, y);
				         else inserer_en_tete(l, nombre_velos_maximum, nombre_velos, x, y);
			    end if;
		       end if;
	end if;
end ajouter_station;


--procedure afficher_liste_station
--semantique: afficher les elements de la liste l
--parametres: l donnee type liste_station
--pre-condition: aucune
--post-condition: aucune
procedure afficher_liste_station (l : IN liste_station) is
begin
	--test d'existance de la station et affichage des identificateurs
	if not(l=NULL) then put(l.all.ident_station,1);
			    new_line;
		            afficher_liste_station(l.all.suivant);
		       else NULL;	
	end if;
end afficher_liste_station;


--fonction rechercher
--semantique: recherche si ident_station est presente dans la liste l, retourne son adresse ou null
--            si la liste est vide ou si ident_station n'appartient pas a la liste
--parametres: l donnee type liste_station
--            ident_station donnee type entier
--type-retour: liste_station
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_station; ident_station : IN integer) return liste_station is
pins : liste_station; --pointeur de parcours
begin
	pins:=new station;
	pins:=l;
	while not (pins=NULL) and then not (pins.all.ident_station=ident_station) loop
		pins:=pins.all.suivant;
	end loop;
	--pins=NULL ou pins.all.ident_station=ident_station
	return pins;
end rechercher;


--procedure enlever
--semantique: enlever un element ident_station de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type liste_station
--            ident_station donnee type entier
--pre-condition: aucune
--post-condition: ident_station n'appartient pas a la liste
procedure enlever_station (l : IN OUT liste_station; ident_station : IN integer) is
pident_station : liste_station; --pointeur vers la station courante
psuppr : liste_station; --pointeur de suppression
begin
	pident_station:=New station;
	pident_station:=rechercher(l, ident_station);
	--test d'existance de la station
	if (pident_station=NULL) then put_line("Cette station n'existe pas");
		     else psuppr:=new station;
			  psuppr:=l;
			  while not (psuppr.all.suivant.all.ident_station=ident_station) loop
				psuppr:=psuppr.all.suivant;
			  end loop;
			  --psuppr.suivant.ident_velo=ident_velo
			  psuppr.all.suivant:=psuppr.all.suivant.all.suivant; --suppression de l'element une fois atteint
	end if; 
end enlever_station;


--procedure info_station
--semantique: affiche les informations a propos de la station (coordonnees, velos disponibles, places libres)
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--precondition: aucune
--postcondition: aucune
procedure info_station (l : IN liste_station; ident_station : IN integer) is
laux : liste_station; --pointeur vers la station courante
begin
	laux:=rechercher(l, ident_station);
	if laux=NULL then put("Cette station n'existe pas");
		     else put("La station ");
			  put(ident_station,1);
			  put(" a pour coordonnees ");
			  put(laux.x,1);
			  put(" ");
			  put(laux.y,1);
			  new_line;
			  put("Elle a ");
			  put(laux.nombre_velos,1);
			  put(" velos disponibles et ");
			  put(laux.nombre_velos_maximum-laux.nombre_velos,1);
			  put_line(" places libres.");
			  new_line;
	end if;
end info_station;


--procedure info_station_alentours
--semantique: affiche les informations a propos des stations alentours
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--precondition: aucune
--postcondition: aucune
procedure info_station_alentours (l : IN liste_station; ident_station : IN integer) is
paux : liste_station; --pointeur permettant de parcourir la liste
pcourant : liste_station; --pointeur vers la station courante
begin
	paux:=l;
	pcourant:=rechercher(l, ident_station);
	--test d'existance de la station
	if pcourant=NULL then put_line("Cette station n'existe pas");
			      new_line;
			 else while not (paux=NULL) loop
					--test de proximite entre les stations et la station courante
					if (sqrt((paux.x-pcourant.x)**2+(paux.y-pcourant.y)**2))<1000.0 and paux/=pcourant
							then info_station(l, paux.ident_station);
							else NULL;
					end if;
					paux:=paux.suivant;
			      end loop;
			      --paux=NULL
	end if;
end info_station_alentours;


--procedure stations_moins_x_metres
--semantique: renvoie les numeros des stations distantes de moins de X metres d'une station
--parametres: lstation donnee type liste_station
--	      ident_station donnee type entier
--	      X donnee type integer
--pre-postconditions: aucune
procedure stations_moins_x_metres (l : IN liste_station; ident_station : IN integer; x : IN float) is
paux : liste_station; --pointeur permettant de parcourir la liste 
pcourant : liste_station; --pointeur vers la station courante
begin
	paux:=new station;
	paux:=l;
	pcourant:=new station;
	pcourant:=rechercher(l, ident_station);
	--test d'existance de la station
	if pcourant=NULL then put("Cette station n'existe pas");
			 else while not (paux=NULL) loop
					--test de proximite entre les stations et la station courante
					if sqrt(((paux.x)-(pcourant.x))**2+((paux.y)-(pcourant.y))**2)<=X and not (paux=pcourant)
						then info_station(l, paux.ident_station);
						     new_line;
						else NULL;
					end if;
					paux:=paux.suivant;
			      end loop;
			      --paux=NULL
	end if;
end stations_moins_x_metres;


--fonction nombre_velos
--semantique : renvoie le nombre de velos disponibles
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
function nombre_velos (l : IN liste_station; ident_station : IN integer) return integer is
paux : liste_station; --pointeur vers la station courante
nombre_velos : integer; --nombre de velos disponibles
begin
	paux:=rechercher(l, ident_station);
	--test d'existance de la station
	if paux=NULL then put_line("Cette station n'existe pas");
			  new_line;
		     --affectation
		     else nombre_velos:=paux.nombre_velos;
	end if;	
	return nombre_velos;
end nombre_velos;


--fonction dec_nombre_velos
--semantique: decremente le nombre de velos d'une station
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
procedure dec_nombre_velos (l : IN liste_station; ident_station : IN integer) is
laux : liste_station; --pointeur vers la station courante
begin
	laux:=rechercher(l, ident_station);
	--decrementation
	if laux=NULL then put_line("Cette station n'existe pas");
		     else laux.nombre_velos:=laux.nombre_velos+1;
	end if;
end dec_nombre_velos;


--fonction inc_nombre_velos
--semantique: incremente le nombre de velos d'une station
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
procedure inc_nombre_velos (l : IN liste_station; ident_station : IN integer) is
laux : liste_station; --pointeur vers la station courante
begin
	laux:=rechercher(l, ident_station);
	--incrementation
	if laux=NULL then put_line("Cette station n'existe pas");
		     else laux.nombre_velos:=laux.nombre_velos-1;
	end if;
end inc_nombre_velos;


--fonction nombre_places
--semantique : renvoie le nombre de places disponibles
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--pre-postcondition: aucune
function nombre_places (l : IN liste_station; ident_station : IN integer) return integer is
paux : liste_station; --pointeur vers la station
nombre_places : integer; --nombre de places disponibles
begin
	paux:=rechercher(l, ident_station);
	--test d'existance de la station
	if paux=NULL then put("Cette station n'existe pas");
		     --affectation
		     else nombre_places:=(paux.nombre_velos_maximum)-(paux.nombre_velos);
	end if;
	return nombre_places;
end nombre_places;


--procedure changer_station
--semantique: permet de changer la station dans laquelle on se trouve lors de l'exécution du programme
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--pre-postcondition: aucune
procedure changer_station (l : IN OUT liste_station; ident_station : IN OUT integer) is
laux : liste_station; --pointeur vers la station courante
begin
	laux:=rechercher(l, ident_station);
	--acquisition de l'identificateur de la station
	Put_line("Dans quelle station voulez-vous aller?");
	get(ident_station);
end changer_station;




--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--

--procedure init_station
--initialise la liste des stations
--parametres: l resultat type liste_station
--pre-postconditions: aucune
procedure init_station (l : OUT liste_station) is
begin
	--ajouter 4 stations
	inserer_en_tete(l, 4, 4, 0.0, 0.0);
	inserer_en_tete(l, 10, 5, 147.6, 129.2);
	inserer_en_tete(l, 20, 0, 98.4, -63.5);
	inserer_en_tete(l, 255, 1, -210.0, -36.5);
end init_station;

end station;
