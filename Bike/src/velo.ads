                           --*****************************--
                           --**       Projet ADA        **--
                           --**      Package Velo       **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--**  Codage Package de specification pour la gestion des listes de velo   **--
--***************************************************************************--



Package velo is

type liste_velos is private;


--***********************************************--
--**Specification et entete des sous-programmes**--
--***********************************************--

--fonction creer_liste_vide
--semantique: cree une liste vide
--parametres: aucun
--type-retour: liste
--pre-condition: aucune
--post-condition: l est vide
function creer_liste_vide return liste_velos;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_velos
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_velos) return boolean;


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non) un nouveau velo
--parametres: l donnee/resultat type liste_velos
--	      ident_station donnee type entier
--pre-condition: aucune
--post-condition: la liste a un nouveau velo en tete
procedure inserer_en_tete (l : IN OUT liste_velos; ident_station : IN integer);


--procedure ajouter_velo
--semantique: ajoute un velo a la liste de velo en lui donnant le premier 
--identificateur non utilise
--parametres: l donnee/resultat type liste_velos
--pre-condition: aucune
--post-condition: la liste comporte un velo de plus
procedure ajouter_velo (l : IN OUT liste_velos);


--procedure afficher_liste_velo
--semantique: affiche les identifiants des velos de la liste
--parametres: lcourant donnee/resultat liste_velos
--pre-postcondition: aucune
procedure afficher_liste_velo (l : IN OUt liste_velos);


--procedure afficher_liste
--semantique: afficher les elements de la liste l
--parametres: lcourant donnee type liste_velos
--	      ident_station donnee type entier
--pre-condition: aucune
--post-condition: aucune
procedure afficher_liste_velo_dispo (lcourant : IN liste_velos; ident_station : IN integer);


--fonction rechercher
--semantique: recherche si ident_velo est present dans la liste l et retourne
--  son adresse ou null si la liste est vide ou si e n'appartient pas a la liste
--parametres: l donnee type liste_velos
--            ident_velo donnee type entier
--type-retour: liste_velos
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_velos; ident_velo : IN integer) return liste_velos;


--procedure enlever_velo
--semantique: enlever un element ident_velo de la liste l (liste vide ou non)
--parametres: l donnee/resultat type liste_velos
--            ident_velo donnee type entier
--pre-condition: aucune
--post-condition: e n'appartient pas a la liste
procedure enlever_velo (l : IN OUT liste_velos; ident_velo : IN integer);


--procedure retirer_velo
--semantique: donner au velo 0 comme emplacement
--parametres: l donnee/resultat type liste_velos
--	      ident_velo donnee type entier
--	      ident_station_courant donnee type entier
--	      ident_compte donnee type entier
--pre-condition: aucune
--post-condition: l'emplacement du velo est 0
procedure retirer_velo (l : IN OUT liste_velos; ident_velo : IN integer; ident_station : IN integer; ident_compte : IN integer);


--procedure deposer_velo
--semantique: donner au velo la station comme emplacement
--parametres: l donnee/resultat type liste_velos
--	      ident_station_courante donnee type entier
--	      ident_compte donnee type entier
--pre-condition: le velo est loue par l'utilisateur
--post-condition: l'emplacement du velo est la station courante
procedure deposer_velo (l : IN OUT liste_velos; ident_velo : IN integer; ident_station : IN integer; ident_compte : IN integer);




--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--

--procedure init_velo
--initialise la liste des velos
--parametres: l resultat type liste_velos
--pre-postconditions: aucune
procedure init_velo (l : OUT liste_velos);




--********************************--
--**declaration des types prives**--
--********************************--

PRIVATE
type velo;
type liste_velos is access velo;
type velo is record
	ident_velo : integer;
	ident_station : integer;
	ident_compte : integer;
	suivant : liste_velos;
end record;

end velo;
