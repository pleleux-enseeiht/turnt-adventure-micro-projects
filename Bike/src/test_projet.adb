                           --*****************************--
                           --**       Projet ADA        **--
                           --**    Programme de test    **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--




--entrees/sorties put,get
with text_IO; use text_IO;
--Entrees/sorties sur les entiers put,get
with ada.integer_text_IO; use ada.integer_text_IO;
--Entrees/sorties sur les flottants put,get
with ada.float_text_IO; use ada.float_text_IO;
--Paquet d'utilisation des listes de vélos
with velo; use velo;
--Paquet d'utilisation des listes de stations
with station; use station;
--Paquet d'utilisation des listes de comptes
with compte; use compte;



procedure test_projet is



--***********************************************--
--**           Declaration des types           **--
--***********************************************--


type noeud;
type liste is access noeud;
type noeud is record
	identificateur : integer;
	element : integer;
	suivant : liste;
end record;

--***********************************************--
--**   Implantation des fonctions génériques   **--
--***********************************************--

--fonction creer_liste_vide
--semantique: cree une liste vide
--parametres: aucun
--type-retour: liste
--pre-condition: aucune
--post-condition: l est vide
function creer_liste_vide return liste is
begin
	return(NULL);
end creer_liste_vide;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste) return boolean is
begin
	return l=NULL;
end est_vide;	


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non) un nouvel element
--parametres: l donnee/resultat type liste
--	      identificateur donnee type entier
--pre-condition: aucune
--post-condition: la liste a un nouvel element en tete
procedure inserer_en_tete (l : IN OUT liste; element : IN integer) is
pins : liste; --pointeur permettant d'inserer le nouvel element
identificateur : integer; --identificateur du nouvel element
begin
	pins:=new noeud;
	--definition de l'identificateur du element : 0 ou le precedent incremente
	if l=NULL then identificateur:=0;
		  else identificateur:=l.identificateur+1;
	end if;
	--creation du contenu du nouvel element
	pins.all.identificateur:=identificateur;
	pins.all.element:=element;
	--insertion en tete de pins
	pins.all.suivant:=l;
	l:=pins;
end inserer_en_tete;


--procedure ajouter_element
--semantique: ajoute un element a la liste de element en lui donnant le premier 
--identificateur non utilise
--parametres: l donnee/resultat type listes
--pre-condition: aucune
--post-condition: la liste comporte un element de plus
procedure ajouter (l : IN OUT liste) is
pins : liste; --pointeur de parcours
pecr : liste; --pointeur d'ecriture
element : integer; --element
interieur : boolean; --vrai si il y a un "trou" dans la liste
begin
	pins:=new noeud;
	pecr:=new noeud;
	interieur:=false;
	--acquisition d'element
	put("Quel est l'element? ");
	get(element);
	new_line;
	--inserer le element en lui donnant le premier identificateur non utilise

	--cas ou la liste est vide ou ne contient qu'un seul element
	if l=NULL then inserer_en_tete(l, element); --1er element pour liste vide
		  else if l.suivant=NULL then --1er element si ident du 2eme element non nul sinon 2eme element
					      if l.identificateur=0 then inserer_en_tete(l, element);
							        else inserer_en_tete(l.suivant, element);
					      end if;
		       else --sinon on parcours la liste a la recherche du premier element non utilise
			    pins:=l; 
			    pecr:=l;
			    while not (pins=NULL) loop
					if pins.suivant/=NULL then --si il y a un "trou" dans la liste, on change le pointeur d'ecriture
								   if pins.identificateur-pins.suivant.identificateur/=1 then pecr:=pins;
														      interieur:=true;
														 else NULL;
								   end if;
							      else --si le dernier element n'est pas nul, idem
								   if pins.identificateur/=0 then pecr:=pins;
											      interieur:=true;
										         else NULL;
								   end if;
					end if;
					pins:=pins.suivant;
			    end loop;
			    --pins=NULL
			    --si il y a un "trou", on insere dans ce trou, sinon en tete
			    if interieur then inserer_en_tete(pecr.suivant, element);
				         else inserer_en_tete(l, element);
			    end if;
		       end if;
	end if;
	--afficher le numero du nouvel element
	put("Le nouvel element est bien cree, c'est le numero ");
	put(pecr.identificateur,1);
	new_line;
end ajouter;		


--procedure afficher_liste
--semantique: affiche les identifiants des elements de la liste
--parametres: lcourant donnee/resultat listes
--pre-postcondition: aucune
procedure afficher_liste (l : IN OUT liste) is
laux : liste;
begin
	laux:=new noeud;
	laux:=l;
	if est_vide(l)  then put_line("La liste est vide");
			else while laux/=NULL loop
					put(l.identificateur,1);
			     		new_line;
					laux:=laux.suivant;
			     end loop;
	end if;
end afficher_liste;


--fonction rechercher
--semantique: recherche si identificateur est present dans la liste l et retourne son adresse ou null
--            si la liste est vide ou si e n'appartient pas u la liste
--parametres: l donnee type listes
--            identificateur donnee type entier
--type-retour: listes
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste; identificateur : IN integer) return liste is
lcourant : liste; --pointeur de parcours
begin
	lcourant:=new noeud;
	lcourant:=l;
	while not (lcourant=NULL) and then not (lcourant.all.identificateur=identificateur) loop
		lcourant:=lcourant.all.suivant;
	end loop;
	--courant=NULL ou courant.all.ident=identificateur
	return lcourant;
end rechercher;


--procedure enlever_element
--semantique: enlever un element identificateur de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type listes
--            identificateur donnee type entier
--pre-condition: aucune
--post-condition: identificateur n'appartient pas a la liste
procedure enlever (l : IN OUT liste; identificateur : IN integer) is
point : liste; --pointeur vers le element courant
psuppr : liste; --pointeur de suppression
begin
	point:=New noeud;
	point:=rechercher(l, identificateur);
	--test d'existance du element
	if (point=NULL) then put_line("Ce noeud n'existe pas");
		     	else psuppr:=new noeud;
			  psuppr:=l;
			  while not (psuppr.all.suivant.all.identificateur=identificateur) loop
				psuppr:=psuppr.all.suivant;
			  end loop;
			  --psuppr.suivant.identificateur=identificateur
			  psuppr.all.suivant:=psuppr.all.suivant.all.suivant;--suppression de l'element une fois atteint
	end if;
end enlever;


--fonction retourner_element
--semantique : renvoie l'element
--parametres : l donnee type liste
--	       identificateur donnee type entier
--pre-postcondition: aucunes
function retourner_element (l : IN liste; identificateur : IN integer) return integer is
paux : liste; --pointeur vers la station courante
element : integer; --element
begin
	paux:=rechercher(l, identificateur);
	--test d'existance de la station
	if paux=NULL then put_line("Ce noeud n'existe pas");
			  new_line;
		     --affectation
		     else element:=paux.element;
	end if;	
	return element;
end retourner_element;


--procedure modifier_element
--semantique: modifie l'element
--parametres: l donnee/resultat type liste
--	      identificateur donnee entier
--precondition : aucune
--postcondition: l'element est modifie
procedure modifier_element (l : IN OUT liste; identificateur : IN integer; element : IN integer) is
laux : liste; --pointeur vers le noeud courant
begin
	laux:=rechercher(l, identificateur);
	--affectation
	if laux=NULL then put_line("Le noeud n'existe pas");
		     else laux.element:=element;
	end if;
end modifier_element;


--procedure init_noeud
--initialise la liste des noeuds
--parametres: l resultat type liste
--pre-postconditions: aucune
procedure init_liste (l : OUT liste) is
begin
--2 noeuds avec l'element 1
	for i in 1..2 loop
		inserer_en_tete(l, 1);
	end loop;
--1 noeud dans la station 2
	inserer_en_tete(l, 2);
--0 noeud dans la station 3
--1 noeud dans la station 4
	inserer_en_tete(l, 4);
end init_liste;





--***********************************************--
--**         Declaration des variables         **--
--***********************************************--


liste_vide : liste;
list : liste;
liste_vel : liste_velos;
liste_stat : liste_station;
liste_comp : liste_compte;
laux : liste;


begin

--***********************************************--
--**         Tests du package element          **--
--***********************************************--
	
	--test de la fonction creer_liste_vide
	liste_vide:=creer_liste_vide;
	list:=creer_liste_vide;
	laux:=creer_liste_vide;

	--test de la procedure init_liste
	init_liste(list);

	--test de la fonction est_vide sur une liste vide et une liste non vide
	if est_vide(liste_vide) then put_line("La liste de elements est vide");
				    else put_line("La liste de elements n'est pas vide");
	end if;
	if est_vide(list) then put_line("La liste de elements est vide");
				    else put_line("La liste de elements n'est pas vide");
	end if;

	--test de la fonction afficher_liste sur une liste non vide et vide
	--	c'est grâce à cette fonction que l'on va vérifier le résultat des autres tests
	afficher_liste(liste_vide);
	afficher_liste(list);
	
	--test de la fonction inserer_en_tete sur une liste vide et une liste non vide
	inserer_en_tete(liste_vide, 1);
	afficher_liste(liste_vide);

	inserer_en_tete(list, 1);
	afficher_liste(list);

	liste_vide:=creer_liste_vide;

	--test de la fonction rechercher sur une liste vide puis une liste non vide avec élément présent ou non
	laux:=rechercher(liste_vide, 3);
	afficher_liste(laux);
	laux:=rechercher(list, 3);
	afficher_liste(laux);
	laux:=rechercher(list, 50);
	afficher_liste(laux);

	--test de la fonction enlever sur liste où le nœud n'est pas présent et une où il est présent
	enlever(list, 30);
	enlever(list, 3);

	--test de la fonction ajouter sur une liste vide, une liste à un nœud dont l'identificateur est ou n'est pas 0, testée sur une liste à plus d'un nœud avec trou (à la fin ou non) et sans trou
	ajouter(liste_vide);
	ajouter(liste_vide);
	ajouter(liste_vide);
	enlever(liste_vide, 0);
	ajouter(liste_vide);
	afficher_liste(liste_vide);

	ajouter(list);
	enlever(list, 0);
	ajouter(list);
	afficher_liste(list);
	enlever(list, 2);
	ajouter(list);
	afficher_liste(list);

	--test de la fonction retourner_element
	put(retourner_element(list, 1));
	new_line;

	--test de la fonction modifier_element
	modifier_element(list, 1, 150);
	put(retourner_element(list, 1));


--***********************************************--
--**         Tests du package station          **--
--***********************************************--

	--initialiser la liste de stations :
	--	identificateur : 1   nombre_velos_maximum :  4   nombre_velos :  4   x :    0.0    y :    0.0
	--			 2			    10		         5       1147.6        1129.2
	--			 3			    20			 0 	   98.4	        -63.5
	--			 4			   255			 1	 -210.0	        -36.5 			
	init_station(liste_stat);

	--test de la fonction info_station sur une liste où la station est présente ou non
	info_station(liste_stat, 1);
	info_station(liste_stat, 40);

	--test de la fonction info_station_alentours sur une liste où la station n'est pas présente, sur une liste où la station est présente et n'a pas de station à proximité et sur une liste avec des stations à proximité.
	info_station_alentours(liste_stat, 40);
	info_station_alentours(liste_stat, 2);
	info_station_alentours(liste_stat, 1);

	--test de la fonction stations_moins_x_metres sur une liste où la station n'est pas présente, sur une liste où la station est présente et n'a pas de station à proximité et sur une liste avec des stations à proximité.
	stations_moins_x_metres(liste_stat, 40, 80000.0);
	stations_moins_x_metres(liste_stat, 1, 10000.0);
	stations_moins_x_metres(liste_stat, 1, 120.1);


--***********************************************--
--**          Tests du package compte          **--
--***********************************************--

	--initialiser la liste de comptes :
	--	identificateur : 0   code_postal : 11111   Mot_de_passe :   789789
	--			 1		   75000		    789789
	--			 2		   92260		    424242
	--			 3		   31200		    170244
	--			 4		   65310		  15091985
	init_compte(liste_comp);

	--test de la fonction check_identity dans le cas où l'identifiant est 0 mais le mot de passe est faux, dans le cas où les deux sont bon, dans le cas où on a un utilisateur enregistré ou non.
	put(check_identity(liste_comp, 0, 680000));
	new_line;
	put(check_identity(liste_comp, 0, 789789));
	new_line;
	put(check_identity(liste_comp, 1, 789789));
	new_line;
	put(check_identity(liste_comp, 12, 23492582));
	new_line;

	--test de la fonction calcule_credit sur une liste où le compte n'est pas présent et sur une liste où il est présent avec comme durée moins d'une demi-heure puis plus d'une demi-heure
	put(calcule_credit(liste_comp, 23, 0, 2));
	new_line;
	put(calcule_credit(liste_comp, 2, 0, 2));
	new_line;
	put(calcule_credit(liste_comp, 2, 1, 2));
	new_line;
	
	--test de la fonction info_compte sur une liste où le compte est présent ou non
	info_compte(liste_comp, 1);
	info_compte(liste_comp, 40);

end test_projet;
