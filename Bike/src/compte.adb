                           --*****************************--
                           --**       Projet ADA        **--
                           --**      Package Compte     **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--** Codage Package d'implantation pour la gestion des listes des comptes  **--
--***************************************************************************--




--entrees/sorties put,get
with text_IO; use text_IO;
--Entrees/sorties sur les entiers put,get
with ada.integer_text_IO; use ada.integer_text_IO;
--Entrees/sorties sur les flottants put,get
with ada.float_text_IO; use ada.float_text_IO;

Package body compte is


--***********************************************--
--**      Implantation des sous-programmes     **--
--***********************************************--

--fonction creer_liste_vide
--semantique: creer une liste vide
--parametres: aucun
--type-retour: liste_compte
--pre-condition: aucune
--post-condition: la liste est vide
function creer_liste_vide return liste_compte is
begin
	return(NULL);
end creer_liste_vide;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_compte
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_compte) return boolean is
begin
	return l=NULL;
end est_vide;


--fonction check_identity 
--semantique: verifie les identifiant et mot de passe entres par l'utilisateur
--	      renvoie 0 pour un admin, 1 pour un utilisateur, 2 pour une erreur
--parametres: liste_comp donnee type liste_compte
--	      ident_compte donnee type integer
--	      Mot_de_passe donnee type integer
--pre-condition: aucune
--post-condition: aucune
function check_identity (liste_comp : IN liste_compte; ident_compte : IN integer; Mot_de_passe : IN integer) return integer is
laux : liste_compte; --pointeur de parcours
option_identifiant : integer; --0 : administrateur, 1 : utilisateur, 2 : aucun des deux
begin
	option_identifiant:=2;
	if ident_compte=0 then if Mot_de_passe=789789 then option_identifiant:=0; --=> administrateur
						      else option_identifiant:=2; --=> ni utilisateur ni administrateur
			       end if;
			  else laux:=new compte;
			       laux:=liste_comp;
			       while laux/=NULL and option_identifiant/=1 loop
						--test d'appartenance a la liste
					if laux.ident_compte=ident_compte and laux.Mot_de_passe=Mot_de_passe then option_identifiant:=1; --=>utilisateur
													     else NULL;
					end if;
					laux:=laux.suivant;
			       end loop;
			       --laux=NULL ou option_identifiant=1
	end if;
	return option_identifiant;
end check_identity;
	

--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non vide) 
--parametres: l donnee/resultat type liste_compte
--	      code_postal donnee type integer
--	      Mot_de_passe donnee type integer
--pre-condition: aucune
--post-condition: nouveau appartient a la liste
procedure inserer_en_tete (l : IN OUT liste_compte; code_postal : IN integer; Mot_de_passe : IN integer; ident_compte : OUT integer) is
pins : liste_compte; --pointeur de parcours
begin
	pins:=new compte;
	--definition de l'identificateur de la station (1 ou le precedent incremente)
	if l=NULL then ident_compte:=0;
		  else ident_compte:=l.ident_compte+1;
	end if;
	--afficher l'identifiant
	put("Votre identifiant est : ");
	put(ident_compte,1);
	new_line;
	new_line;
	--creation du contenu de la nouvelle station
	pins.all.ident_compte:=ident_compte;
	pins.all.code_postal:=code_postal;
	pins.all.Mot_de_passe:=Mot_de_passe;
	pins.all.hh:=0;
	pins.all.mm:=0;
	pins.all.credit:=3.0;
	pins.all.caution:=150;
	pins.all.ident_velo:=0;
	pins.all.en_location:=false;
	--insertion en tete de pins
	pins.all.suivant:=l;
	l:=pins;
end inserer_en_tete;


--procedure ajouter_compte
--semantique: cree une nouvelle compte en lui donnant le premier identificateur non utilise
--parametres: l donnee/resultat type liste_compte
--pre-condition: aucune
--post-condition: la liste contient cette nouvelle station
procedure ajouter_compte (l : IN OUT liste_compte) is
code_postal : integer; --code postal du nouveau compte
Mot_de_passe : integer; --mot de passe du nouveau compte
pins : liste_compte; --pointeur de parcours
pecr : liste_compte; --pointeur d'ecriture
ident_compte:integer; --identificateur du nouveau compte
condition_de_choix : boolean; --vrai lorsque les choix pour code postal et mot de passe sont corrects
interieur : boolean; --vrai si il y a un "trou" dans la liste
begin
	pins:=New compte;
	pecr:=New compte;
	interieur:=false;
	new_line;
	ident_compte:=0;
	--acquisition du code postal avec "seconde chance"
	loop
	condition_de_choix:=true;
	put("Entrez votre code postal : ");
	get(code_postal);
	new_line;
	if(code_postal<=1000 or code_postal>99000) then condition_de_choix:=false;
		    				else NULL;
	end if;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
	--acquisition du code postal avec "seconde chance"
	loop
	condition_de_choix:=true;
	put("Entrez un mot de passe de 6 chiffres ne commencant pas par 0");
	get(Mot_de_passe);
	new_line;
	--inserer la station en lui donnant le premier identificateur non utilise

	--cas ou la liste est vide ou ne contient qu'une seule station
	if (Mot_de_passe>999999 or Mot_de_passe<100000) then condition_de_choix:=false;
			    				else --affichage des infos sur le service pour un mot de passe correct
							     put_line("Veuillez noter cet identifiant et ce mot de passe, c'est eux qui vous permettront d'utiliser votre compte lors d'une prochaine utilisation.");
				 			     put_line("Vous possedez maintenant un credit de 3 euros. Lors de la location d'un velo, la premiere demi-heure est gratuite puis vous serez preleve de 50 cts par demi-heure d'utilisation.");
	end if;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
	if l=NULL then inserer_en_tete(l, code_postal, Mot_de_passe, ident_compte); --1er compte pour liste vide
		  else if l.suivant=NULL then --1er compte si ident de la 2eme compte non nul sinon 2eme compte
					      if l.ident_compte=1 then inserer_en_tete(l, code_postal, Mot_de_passe, ident_compte);
							     else inserer_en_tete(l.suivant, code_postal, Mot_de_passe, ident_compte);
					      end if;
		       else --sinon on parcours la liste a la recherche du premier element non utilise
			    pins:=l;
			    pecr:=l;
			    while not (pins=NULL) loop
					if pins.suivant/=NULL then --si il y a un "trou" dans la liste, on change le pointeur d'ecriture
								   if pins.ident_compte-pins.suivant.ident_compte/=1 then pecr:=pins;
															    interieur:=true;
														     else NULL;
								   end if;
							      else --si le dernier element n'est pas nul, idem
								   if pins.ident_compte/=1 then pecr:=pins;
												interieur:=true;
										           else NULL;
								   end if;
					end if;
					pins:=pins.suivant;
			    end loop;
			    --pins=NULL
			    --si il y a un "trou", on insere dans ce trou, sinon en tete
			    if interieur then inserer_en_tete(pecr.suivant, code_postal, Mot_de_passe, ident_compte);
				         else inserer_en_tete(l, code_postal, Mot_de_passe, ident_compte);
			    end if;
		       end if;
	end if;
end ajouter_compte;


--procedure afficher_liste_compte
--semantique: afficher les elements de la liste l de maniere recursive
--parametres: l donnee type liste_compte
--pre-condition: aucune
--post-condition: aucune
procedure afficher_liste_compte (l : IN liste_compte) is
begin
	--test d'existance du compte et affichage des identificateurs
	if not(l=NULL) then put(l.all.ident_compte,1);
			    new_line;
		            afficher_liste_compte(l.all.suivant);
		       else NULL;	
	end if;
end afficher_liste_compte;


--fonction rechercher
--semantique: recherche si ident_compte est present dans la liste l, retourne son adresse ou null
--            si la liste est vide ou si ident_compte n'appartient pas a la liste
--parametres: l donnee type liste_compte
--            ident_compte donnee type entier
--type-retour: liste_compte
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_compte; ident_compte : IN integer) return liste_compte is
courant : liste_compte; --pointeur de parcours
begin
	courant:=new compte;
	courant:=l;
	while not (courant=NULL) and then not (courant.all.ident_compte=ident_compte) loop
		courant:=courant.all.suivant;
	end loop;
	--courant=NULL ou courant.all.ident_compte=ident_compte
	return courant;
end rechercher;


--procedure enlever_compte
--semantique: enlever un element ident_compte de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type liste_compte
--            ident_compte donnee type entier
--pre-condition: aucune
--post-condition: ident_compte n'appartient pas a la liste
procedure enlever_compte (l : IN OUT liste_compte; ident_compte : IN integer) is
pident_compte : liste_compte; --pointeur vers le compte courant
psuppr : liste_compte; --pointeur de suppression
begin
	pident_compte:=New compte;
	pident_compte:=rechercher(l, ident_compte);
	--test d'existance de la station
	if (pident_compte=NULL) then put_line("Le compte n'existe pas");
		     else psuppr:=new compte;
			  psuppr:=l;
			  while not (psuppr.all.suivant.all.ident_compte=ident_compte) loop
				psuppr:=psuppr.all.suivant;
			  end loop;
			  --psuppr.suivant.ident_velo=ident_velo
			  psuppr.all.suivant:=psuppr.all.suivant.all.suivant; --suppression de l'element une fois atteint
	end if;
end enlever_compte;


--procedure changer_mot_de_passe
--semantique: permet de changer le mot de passe d'un compte
--parametres: l donnee de type liste_compte
--	      ident_compte donnee de type entier
--pre-postcondition: aucune
procedure changer_mot_de_passe (l : IN liste_compte; ident_compte : IN integer) is
condition_de_choix : boolean; --vrai si le choix du mot de passe est correct
Mot_de_passe : integer; --mot de passe du compte courant
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=new compte;
	laux:=rechercher(l, ident_compte);
	if laux= NULL then put_line("Le compte n'existe pas");
	else loop
		condition_de_choix:=true;
		--acquisition de l'ancien mot de passe
		put("Entrez votre ancien mot de passe");
		get(mot_de_passe);
		new_line;
	        --test mot de passe
		if not (mot_de_passe=laux.Mot_de_passe) then put_line("Mot de passe incorrect");
							     new_line;
							    condition_de_choix:=false;
						       else --acquisition du nouveau mot de passe
							    put_line("Entrez un mot de passe d'au moins 6 chiffres ne commencant pas par 0");
				     			    get(Mot_de_passe);
							    new_line;
							    --test format du mot de passe
				     			    if Mot_de_passe>999999 then put_line("Mot de passe incorrect");
											new_line;
					 						condition_de_choix:=false;
				    		     				else --affectation
										     laux.Mot_de_passe:=Mot_de_passe;
							  			     put_line("Votre mot de passe a bien ete modifie");
										     new_line;
										     new_line;
		  					    end if;
		end if;
	     exit when condition_de_choix;
	     end loop;
	end if;
	--condition_de_choix
end changer_mot_de_passe;


--procedure changer_code_postal
--semantique: permet de changer le code postal d'un compte
--parametres: l donnee de type liste_compte
--	      ident_compte donnee type entier
--pre-postcondition: aucune
procedure changer_code_postal (l : IN liste_compte; ident_compte : IN integer) is
condition_de_choix : boolean; --vrai si le choix du code postal est correct
code_postal : integer; --code postal du compte courant
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--acquisition du code postal
	if laux=NULL then put_line("Le compte n'existe pas");
	else loop
		condition_de_choix:=true;
		put("Entrez votre code postal : ");
		get(code_postal);
		new_line;
		--test format code postal
		if (code_postal<=1000 or code_postal>99000) then condition_de_choix:=false;
						            else --affectation
								 laux.code_postal:=code_postal;
		end if;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
	end if;
	put_line("Votre code postal a bien ete modifie");
	new_line;
end changer_code_postal;	


--procedure enlever_caution
--semantique: mettre la caution a 0
--parametres: l donnee/resultat type liste_compte
--	      ident_compte donnee entier
--precondition : aucune
--postcondition: la caution est a 0
procedure enlever_caution (l : IN OUT liste_compte; ident_compte : IN integer) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--affectation
	if laux=NULL then put_line("Le compte n'existe pas");
		     else laux.caution:=0;
	end if;
end enlever_caution;


--procedure changer_heure
--semantique: enregistre dans la derniere heure de location de velo
--parametres: l donnee de type liste_compte
--	      ident_compte donnee type entier
--	      hh donnee type entier
--	      mm donnee type entier
--pre-condition: hh et mm de bonne taille
--postcondition: hh et mm enregistrés dans le compte
procedure changer_heure (l : IN OUT liste_compte; ident_compte : IN integer; hh : IN integer; mm : IN integer) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--affectation
	if laux=NULL then put_line("Le compte n'existe pas");
		     else laux.hh:=hh;
	                  laux.mm:=mm;
	end if;
end changer_heure;


--fonction calcule_credit
--semantique: calcule la somme que doit payer l'utilisateur lorrsqu'il rend un velo
--parametres: list_comp donnee resultat liste_compte
--	      ident_compte donnee type entier
--	      hh donnee type entier
--	      mm donnee type entier
--type retour: entier
--pre-condition: hh et mm sont au bon format
--post-condition: aucune
function calcule_credit (l : IN liste_compte; ident_compte : IN integer; hh : IN integer; mm : IN integer) return float is
laux : liste_compte; --pointeur vers le compte courant
credit : float; --credit a ajouter au credit du compte
begin
	credit:=0.0;
	laux:=rechercher(l, ident_compte);
	--test si temps<30 ou >30 minutes
	if laux=NULL then put_line("Le compte n'existe pas");
		     else if (hh-laux.hh)*60+(mm-laux.mm)<=30 then credit:=0.0; --premiere demi-heure gratuite
					    		      else credit:=-0.5*(Float(((hh-laux.hh)*60+(mm-laux.mm))/30)); --0.5euro par demi-heure
			  end if;
	end if;
	return credit;
end calcule_credit;


--procedure crediter_compte
--semantique: permet de crediter un compte de credit
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--	      credit donnee de type float
--pre-postcondition: aucune
procedure crediter_compte (l : IN OUT liste_compte; ident_compte : IN integer; credit : IN float) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--test solvabilité du compte
	if laux=NULL then put_line("Le compte n'existe pas");
		     else if laux.credit+credit<0.0 then put_line("Vous avez garde le velo trop longtemps, votre caution va etre prelevee et votre credit est a zero");
				       			 new_line;
							 laux.credit:=0.0;
				       		   	 enlever_caution(l, ident_compte);
				  		    else laux.credit:=laux.credit+credit;
			  end if;
	end if;
end crediter_compte;


--procedure info_compte
--semantique: permet d'obtenir des info sur le compte
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
procedure info_compte (l : IN liste_compte; ident_compte : IN integer) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	if laux=NULL then put_line("Le compte n'existe pas");
		     else put("Le compte numero ");
			  put(laux.ident_compte,1);
			  put(" de code postal ");
			  put(laux.code_postal,1);
			  put(", a un credit de ");
			  put(laux.credit,1);
			  put_line(".");
			  new_line;
	end if;
end info_compte;


--procedure est_en_location
--semantique: renvoie vrai si la personne est en train de louer un velo
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
function est_en_location (l : IN liste_compte; ident_compte : IN integer) return boolean is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	return laux.en_location;
end est_en_location;


--procedure change_en_location
--semantique: inverse le booleen en_location
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
procedure change_en_location (l : IN liste_compte; ident_compte : IN integer) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--inversion booleen
	if laux=NULL then put_line("Le compte n'existe pas");
		     else laux.en_location:=not laux.en_location;
	end if;
end change_en_location;


--procedure changer_velo
--semantique: rentre dans les info du compte le numero du velo loue
--parametres: l donnee resultat type liste_compte
--	      ident_compte donnee type entier
--	      ident_velo donnee type entier
--pre-postcondition: ident_velo correspond a un velo existant
procedure changer_velo (l : IN OUT liste_compte; ident_compte : IN integer; ident_velo : IN integer) is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	--affectation
	if laux=NULL then put_line("Le compte n'existe pas");
		     else laux.ident_velo:=ident_velo;
	end if;
end changer_velo;


--fonction velo_loue
--semantique: renvoie le numero du velo loue
--parametres: l donnee type liste_compte
--	      ident_compte donnee type entier
--type retour: entier
--pre_condition: un velo a ete loue
--post-condition: aucune
function velo_loue (l : IN liste_compte; ident_compte : IN integer) return integer is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	return laux.ident_velo;
end velo_loue;


--fonction retourne_credit
--semantique: renvoie le credit du compte ident_compte
--parametres: l donnee type liste_compte
--	      ident_compte donnee type entier
--type retour flottant
--pre-postcondition: aucune
function retourne_credit (l : IN liste_compte; ident_compte : IN integer) return float is
laux : liste_compte; --pointeur vers le compte courant
begin
	laux:=rechercher(l, ident_compte);
	return laux.credit;
end retourne_credit;




--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--

--procedure init_compte
--initialise la liste des comptes
--parametres: l resultat type liste_compte
--pre-postconditions: aucune
procedure init_compte (l : OUT liste_compte) is
ident_compte : integer;
begin
	--ajouter 4 comptes
	inserer_en_tete(l, 11111, 789789, ident_compte);
	inserer_en_tete(l, 75000, 789789, ident_compte);
	inserer_en_tete(l, 92260, 424242, ident_compte);
	inserer_en_tete(l, 31200, 170244, ident_compte);
	inserer_en_tete(l, 65310, 15091985, ident_compte);
end init_compte;

end compte;
