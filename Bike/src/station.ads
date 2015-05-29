                           --*****************************--
                           --**       Projet ADA        **--
                           --**    Package Station      **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--**Codage Package de specification pour la gestion des listes de stations **--
--***************************************************************************--




Package station is


type liste_station is private;


--***********************************************--
--**Specification et entete des sous-programmes**--
--***********************************************--


--fonction creer_liste_vide
--semantique: cree une liste vide
--parametres: aucun
--type-retour: liste_station
--pre-condition: aucune
--post-condition: la liste est vide
function creer_liste_vide return liste_station;


--fonction est_vide
--semantique: teste si une liste l est vide
--parametres: l donnee type liste_station
--type retour: booleen
--pre-condition: aucune
--post-condition: aucune
function est_vide (l : IN liste_station) return boolean;


--procedure inserer_en_tete
--semantique: insere en tete de la liste l (liste vide ou non vide) une nouvelle station
--parametres: l donnee/resultat type liste_station
--	      nombre_velos_maximum donnee type entier
--	      nombre_velos donnee type entier
--	      x donnee type float
--	      y donnee type float
--pre-condition: aucune
--post-condition: la liste contient une nouvelle station
procedure inserer_en_tete (l : IN OUT liste_station; nombre_velos_maximum : in integer; nombre_velos : IN integer; x : IN float; y : IN float);


--procedure ajouter_station
--semantique: cree une nouvelle station en lui donnant le premier identificateur non utilise
--parametres: l donnee/resultat type liste_station
--pre-condition: aucune
--post-condition: la liste contient cette nouvelle station
procedure ajouter_station (l : IN OUT liste_station);


--procedure afficher_liste
--semantique: afficher les elements de la liste l
--parametres: l donnee type liste_station
--pre-condition: aucune
--post-condition: aucune
procedure afficher_liste_station (l : IN liste_station);


--fonction rechercher
--semantique: recherche si ident_station est presente dans la liste l, retourne son adresse ou null
--            si la liste est vide ou si ident_station n'appartient pas a la liste
--parametres: l donnee type liste_station
--            ident_station donnee type entier
--type-retour: liste_station
--pre-condition: aucune
--post-condition: aucune
function rechercher (l : IN liste_station; ident_station : IN integer) return liste_station;


--procedure enlever
--semantique: enlever un element ident_station de la liste l (liste vide ou non vide)
--parametres: l donnee/resultat type liste_station
--            ident_station donnee type entier
--pre-condition: aucune
--post-condition: ident_station n'appartient pas a la liste
procedure enlever_station (l : IN OUT liste_station; ident_station : IN integer);


--procedure info_station
--semantique: affiche les informations a propos de la station (coordonnees, velos disponibles, places libres)
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--precondition: aucune
--postcondition: aucune
procedure info_station (l : IN liste_station; ident_station : IN integer);


--procedure info_station_alentours
--semantique: affiche les informations a propos des stations alentours
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--precondition: aucune
--postcondition: aucune
procedure info_station_alentours (l : IN liste_station; ident_station : IN integer);


--procedure stations_moins_x_metres
--semantique: renvoie les numeros des stations distantes de moins de X metres d'une station
--parametres: lstation donnee type liste_station
--	      ident_station donnee type entier
--	      X donnee type integer
--pre-postconditions:
procedure stations_moins_x_metres (l : IN liste_station; ident_station : IN integer; x : IN float);


--fonction nombre_velos
--semantique : renvoie le nombre de velos disponibles
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
function nombre_velos (l : IN liste_station; ident_station : IN integer) return integer;


--fonction dec_nombre_velos
--semantique: decremente le nombre de velos d'une station
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
procedure dec_nombre_velos (l : IN liste_station; ident_station : IN integer);


--fonction inc_nombre_velos
--semantique: incremente le nombre de velos d'une station
--parametres : l donnee type liste_station
--	       ident_station donnee type entier
--pre-postcondition: aucunes
procedure inc_nombre_velos (l : IN liste_station; ident_station : IN integer);


--fonction nombre_places
--semantique : renvoie le nombre de places disponibles
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--pre-postcondition: aucunes
function nombre_places (l : IN liste_station; ident_station : IN integer) return integer;


--procedure changer_station
--semantique: permet de changer la station dans laquelle on se trouve lors de l'exécution du programme
--parametres: l donnee type liste_station
--	      ident_station donnee type entier
--pre-postcondition: aucune
procedure changer_station (l : IN OUT liste_station; ident_station : IN OUT integer);





--***********************************************--
--**         Initialisation de la liste        **--
--***********************************************--



--procedure init_station
--initialise la liste des stations
--parametres: l resultat type liste_station
--pre-postconditions: aucune
procedure init_station (l : OUT liste_station);






--********************************--
--**declaration des types prives**--
--********************************--



PRIVATE
type Station;
type liste_station is access Station;
type Station is record
	ident_station : integer;
	nombre_velos_maximum : integer;
	nombre_velos : integer;
	x : float;
	y : float;
	suivant : liste_station;
end record;

end station;
