                           --*****************************--
                           --**       Projet ADA        **--
                           --**      Package Compte     **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--**Codage Package de specification pour la gestion des listes des comptes **--
--***************************************************************************--




Package compte is

type liste_compte is private;


--***********************************************--
--**Specification et entete des sous-programmes**--
--***********************************************--

--fonction creer_liste_vide
--semantique: creer une liste vide
--parametres: aucun
--type-retour: liste_compte
--pre-condition: aucune
--post-condition: la liste est vide
function creer_liste_vide return liste_compte;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_compte
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_compte) return boolean;


--fonction check_identity 
--semantique: verifie les identifiant et mot de passe entres par l'utilisateur
--	      renvoie 0 pour un admin, 1 pour un utilisateur, 2 pour une erreur
--parametres: liste_comp donnee type liste_compte
--	      ident_compte donnee type integer
--	      Mot_de_passe donnee type integer
--pre-condition: aucune
--post-condition: aucune
function check_identity (liste_comp : IN liste_compte; ident_compte : IN integer; Mot_de_passe : IN integer) return integer;


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non vide) 
--parametres: l donnee/resultat type liste_compte
--	      code_postal donnee type integer
--	      Mot_de_passe donnee type integer
--pre-condition: aucune
--post-condition: nouveau appartient a la liste
procedure inserer_en_tete (l : IN OUT liste_compte; code_postal : IN integer; Mot_de_passe : IN integer; ident_compte : OUT integer);


--procedure ajouter_compte
--semantique: cree un nouvelle compte en lui donnant le premier identificateur non utilise
--parametres: l donnee/resultat type liste_compte
--pre-condition: aucune
--post-condition: la liste contient ce nouveau compte
procedure ajouter_compte (l : IN OUT liste_compte);


--procedure afficher_liste_compte
--semantique: afficher les elements de la liste l de maniere recursive
--parametres: l donnee type liste_compte
--pre-condition: aucune
--post-condition: aucune
procedure afficher_liste_compte (l : IN liste_compte);


--fonction rechercher
--semantique: recherche si ident_compte est present dans la liste l, retourne son adresse ou null
--            si la liste est vide ou si ident_compte n'appartient pas a la liste
--parametres: l donnee type liste_compte
--            ident_compte donnee type entier
--type-retour: liste_compte
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_compte; ident_compte : IN integer) return liste_compte;


--procedure enlever_compte
--semantique: enlever un element ident_compte de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type liste_compte
--            ident_compte donnee type entier
--pre-condition: aucune
--post-condition: ident_compte n'appartient pas a la liste
procedure enlever_compte (l : IN OUT liste_compte; ident_compte : IN integer);


--procedure changer_mot_de_passe
--semantique: permet de changer le mot de passe d'un compte
--parametres: l donnee de type liste_compte
--	      ident_compte donnee de type entier
--pre-postcondition: aucune
procedure changer_mot_de_passe (l : IN liste_compte; ident_compte : IN integer);


--procedure changer_code_postal
--semantique: permet de changer le code postal d'un compte
--parametres: l donnee de type liste_compte
--	      ident_compte donnee type entier
--pre-postcondition: aucune
procedure changer_code_postal (l : IN liste_compte; ident_compte : IN integer);


--procedure changer_heure
--semantique: enregistre dans la derniere heure de location de velo
--parametres: l donnee de type liste_compte
--	      ident_compte donnee type entier
--	      hh donnee type entier
--	      mm donnee type entier
--pre-condition: hh et mm de bonne taille
--postcondition: hh et mm enregistrés dans le compte
procedure changer_heure (l : IN OUT liste_compte; ident_compte : IN integer; hh : IN integer; mm : IN integer);


--fonction calcule_credit
--semantique: calcule la somme que doit payer l'utilisateur lorrsqu'il rend un velo
--parametres: list_comp donnee resultat liste_compte
--	      ident_compte donnee type entier
--	      hh donnee type entier
--	      mm donnee type entier
--type retour: entier
--pre-condition: hh et mm sont au bon format
--post-condition: aucune
function calcule_credit (l : IN liste_compte; ident_compte : IN integer; hh : IN integer; mm : IN integer) return float;


--procedure crediter_compte
--semantique: permet de crediter un compte de credit
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--	      credit donnee de type float
--pre-postcondition: aucune
procedure crediter_compte (l : IN OUT liste_compte; ident_compte : IN integer; credit : IN float);


--procedure enlever_caution
--semantique: mettre la caution a 0
--parametres: l donnee/resultat type liste_compte
--	      ident_compte donnee entier
--precondition : aucune
--postcondition: la caution est a 0
procedure enlever_caution (l : IN OUT liste_compte; ident_compte : IN integer);


--procedure info_compte
--semantique: permet d'obtenir des info sur le compte
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
procedure info_compte (l : IN liste_compte; ident_compte : IN integer);


--procedure est_en_location
--semantique: renvoie vrai si la personne est en train de louer un velo
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
function est_en_location (l : IN liste_compte; ident_compte : IN integer) return boolean;


--procedure change_en_location
--semantique: inverse le booleen en_location
--parametres: l donnee de type liste_compte
--	      ident donnee de type entier
--pre-postcondition: aucune
procedure change_en_location (l : IN liste_compte; ident_compte : IN integer);




--procedure changer_velo
--semantique: rentre dans les info du compte le numero du velo loue
--parametres: l donnee resultat type liste_compte
--	      ident_compte donnee type entier
--	      ident_velo donnee type entier
--pre-postcondition: ident_velo correspond a un velo existant
procedure changer_velo (l : IN OUT liste_compte; ident_compte : IN integer; ident_velo : IN integer);


--fonction velo_loue
--semantique: renvoie le numero du velo loue
--parametres: l donnee type liste_compte
--	      ident_compte donnee type entier
--type retour: entier
--pre_condition: un velo a ete loue
--post-condition: aucune
function velo_loue (l : IN liste_compte; ident_compte : IN integer) return integer;


--fonction retourne_credit
--semantique: renvoie le credit du compte ident_compte
--parametres: l donnee type liste_compte
--	      ident_compte donnee type entier
--type retour flottant
--pre-postcondition: aucune
function retourne_credit (l : IN liste_compte; ident_compte : IN integer) return float;



--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--

--procedure init_compte
--initialise la liste des comptes
--parametres: l resultat type liste_compte
--pre-postconditions: aucune
procedure init_compte (l : OUT liste_compte);



--********************************--
--**declaration des types prives**--
--********************************--

PRIVATE
type Compte;
type liste_compte is access compte;
type Compte is record
	ident_compte : integer;
	code_postal : integer;
	Mot_de_passe : integer;
	credit : float;
	caution : integer;
	en_location : boolean;
	ident_velo : integer;
	hh : integer;
	mm : integer;
	suivant : liste_compte;
end record;



end compte;
