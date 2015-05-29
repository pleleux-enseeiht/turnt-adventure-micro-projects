                           --*****************************--
                           --**       Projet ADA        **--
                           --**  Interface Utilisateur  **--
                           --*****************************--
			   --**Ecrit par Philippe LELEUX**--
			   --*****************************--



--***************************************************************************--
--** Codage implantation de l'interface utilisateur                        **--
--***************************************************************************--




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

Procedure interface_utilisateur is


--***********************************************--
--**      Implantation des sous-programmes     **--
--***********************************************--

--procedure info_service
--semantique: affiche les info a propos des tarifs etc..
--parametres : aucun
--pre-postcondition : aucune
procedure info_service is
begin
	put_line("Ce service permet à des utilisateurs abonnés de pouvoir utiliser un vélo disponible dans une station pour se déplacer dans la ville. Puis le deposer dans n'importe quelle station du reseau.");
	new_line;
	put_line("Lors de la création d'un compte, un identifiant vous est fourni et vous pouvez choisir un mot de passe qui vous permettront ensuite de pouvoir vous identifier à chaque utilisation.");
	new_line;	
	put_line(" Vous disposez d'un crédit de 3 Euros à l'origine ainsi qu'une caution de 150 Euros utilisée en cas de détérioration, de perte ou de vol de vélo. Le crédit est débité de 50 centimes par demi heure d'utilisation au delà de la première demi-heure qui est gratuite.");
	new_line;	
	put_line("Lorsque votre crédit est nul, vous ne pouvez pas prendre de vélo sans créditer de nouveau votre compte. De plus, si vous ne disposez pas d'assez de crédit sur votre compte en rendant le velo, la caution sera prelevee");
	new_line;
end info_service;


--fonction menu_utilisateur_sans_compte
--semantique: menu permettant a un utilisateur non abonne de s'abonner (renvoie 1) et/ou d'obtenir des info sur le service (renvoie 0)
--parametres: liste_comp donnee/resultat type liste_compte
--type retour: entier
--pre-postcondition: aucun
--exception : aucune
procedure menu_utilisateur_sans_compte (liste_comp : IN OUT liste_compte; option_identifiant : IN OUT integer; ident_compte : IN OUT integer) is
choix : character; --choix d'action de l'utilisateur
continuerAEffectuerDesActions : boolean; --vrai tant que l'on souhaite rester dans ce menu
condition_de_choix : boolean; --vrai tant que le choix du menu est correct
code_postal : integer; --code postal du nouveau compte
Mot_de_passe : integer; --mot de passe du nouveau compte
condition_de_choix1 : boolean; --vrai si le code postal puis le mot de passe sont corrects
begin
	continuerAEffectuerDesActions:=true;
	loop 
		loop
			--acquisition choix
			condition_de_choix:=true; 
			put_line("Souhaitez vous :");
			put_line("(1)  Créer un compte");
			put_line("(2)  Obtenir des informations sur le service Velo-toulouse");
			put_line("(q)  Revenir au menu principal");
			get(choix);
			new_line;
			CASE choix is
				when '1' => --Creer compte
					    loop
							condition_de_choix1:=true;
							--acquisition code postal
							put("Entrez votre code postal : ");
							get(code_postal);
							new_line;
							--test format code postal
							if(code_postal<=1000 or code_postal>99000) then condition_de_choix1:=false;
			    									   else NULL;
							end if;
					    exit when condition_de_choix1;
					    end loop;
					    --condition_de_choix1
					    loop	
							condition_de_choix1:=true;
							--acquisition mot de passe
							put("Entrez un mot de passe de 6 chiffres ne commencant pas par 0");
							get(Mot_de_passe);
							new_line;
							--test format mot de passe
							if (Mot_de_passe>999999 or Mot_de_passe<100000) then condition_de_choix1:=false;
									    				else NULL;
							end if;
					    exit when condition_de_choix1;
					    end loop;
					    --condition_de_choix1
					    inserer_en_tete(liste_comp, code_postal, Mot_de_passe, ident_compte);
					    option_identifiant:=1;
				when '2' => --Info service
					    info_service;
					    option_identifiant:=2;
				when 'q' => --Retour menu principal
					    option_identifiant:=2;
					    continuerAEffectuerDesActions:=false;							  
				when OTHERS => --seconde chance
					       put_line("nous n'avons pas compris votre choix.");
					       new_line;
					       condition_de_choix:=false;
			end case;
		exit when condition_de_choix;
		end loop;
		--condition_de_choix
	exit when (not continuerAEffectuerDesActions) or option_identifiant=1;
	end loop;
	--not continuerAEffectuerDesActions ou option_identifiant=1
end menu_utilisateur_sans_compte;


--fonction identification
--semantique: renvoie 0 pour un administrateur, 1 pour un utilisateur et 2 pour quitter
--parametres: liste_comp donnee/resultat liste_compte
--	      identifiant resultat entier
--	      code_postal resultat entier
--	      Mot_de_passe resultat entier
--type retour: entier
--pre-postcondition: aucune
--exception: aucune
procedure identification (liste_comp : IN OUT liste_compte; ident_compte : OUT integer; option_identifiant : OUT integer) is
choix : character; --choix dans la fonction
Mot_de_passe : integer; --mot de passe du compte utilisateur ou administrateur
condition_de_choix : boolean; --vrai si le choix est correct
begin
	put_line("Bienvenue sur le service de location de velos Velo-Toulouse!");
	new_line;
	loop
		condition_de_choix:=true;
		--acquisition choix
		put_line("Possedez vous deja un compte?  o/n");
		put_line("(Tapez q si vous souhaitez revenir au menu principal.)");
		get(choix);
		new_line;
		CASE choix is
			when 'o' => --Avec compte
				    put_line("Pour acceder a nos services, veuillez vous identifier.");
				    --acquisition identifiant
				    put("Identifiant : ");
				    get(ident_compte);
				    --acquisition mot de passe
				    put("Mot de Passe : ");
				    get(Mot_de_passe);
				    new_line;
				    --traitement identification
				    option_identifiant:=check_identity(liste_comp, ident_compte, Mot_de_passe);
			when 'n' => --Sans compte
				    menu_utilisateur_sans_compte(liste_comp, option_identifiant, ident_compte);
			when 'q' => --Retour menu principal
				    option_identifiant:=2;
			when OTHERS => --Seconde chance
				       put_line("nous n'avons pas compris votre choix.");
				       new_line;
				       condition_de_choix:=false;
		end case;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
end identification;


--procedure consulter_modifier_compte
--semantique: permet de consulter le compte (ident, code postal, credit)
--			modifier le compte (code postal, mot de passe, credit)
--parametres: ident donnee type entier
--pre-postcondition:  aucune
--exception: Exception_compte_inexistant : le compte n'existe pas
procedure consulter_modifier_compte (liste_comp : IN OUT liste_compte; ident_compte : IN integer) is
choix : character; --choix d'action de l'utilisateur
condition_de_choix : boolean; --vrai tant que le choix est correct
credit : float; --somme a ajouter au credit du compte
continuerAEffectuerDesActions : boolean; --vrai tant que l'on veut rester dans le menu
begin
	continuerAEffectuerDesActions:=true;	
	loop
		loop
			condition_de_choix:=true;
			put_line("Que voulez-vous faire?");
			put_line("(1)  Consulter compte");
			put_line("(2)  Modifier votre code postal");
			put_line("(3)  Modifier votre mot de passe");
			put_line("(4)  Crediter votre compte");
			put_line("(5)  Cloturer votre compte");
			put_line("(q)  revenir au menu principal");
			get(choix);
			CASE choix is
				when '1' => --consulter compte
					    info_compte(liste_comp, ident_compte);
				when '2' => --modifier code postal
					    changer_code_postal(liste_comp, ident_compte);
				when '3' => --modifier mot de passe
					    changer_mot_de_passe(liste_comp, ident_compte);
				when '4' => --crediter compte
					    loop
					    --acquisition credit
					    put_line("De combien voulez-vous crediter votre compte? (valeur au format flottant");
					    get(credit);
					    new_line;
					    --test solvabilite
					    if credit<0.0 then put_line("Vous ne pouvez pas entrer une valeur negative");
							       new_line;
							  else --crediter
							       crediter_compte(liste_comp, ident_compte, credit);
					    end if;
					    exit when credit>=0.0;
					    end loop;
					    --credit>=0
				when '5' => --cloturer compte
					    enlever_compte(liste_comp, ident_compte);
					    Put_line("Votre compte est maintenant cloture. Vous ne pourrez plus recuperer le credit restant.");
					    new_line;
				when 'q' => --retour menu
					    continuerAEffectuerDesActions:=false;
				when OTHERS => --seconde chance
					       put_line("nous n'avons pas compris votre choix.");
					       new_line;
					       condition_de_choix:=false;
			end case;
		exit when condition_de_choix;
		end loop;
		--condition_de_choix
	exit when not continuerAEffectuerDesActions;
	end loop;
	--not continuerAEffectuerDesActions
end consulter_modifier_compte;	


--procedure heure
--semantique: demande l'heure et modifie hh et mm
--parametres: hh resultat type entier
--	      mm resultat type entier
--pre-postcondition : aucune
--exception : aucune
procedure heure (hh : OUT integer; mm : OUT integer) is
condition_de_choix : boolean; --vrai tant que le format de hh puis de mm est correct
begin
	put_line("Quelle heure est-t-il? (hh:mm)");
	loop
		condition_de_choix:=true;
		--acquisition hh
		put_line("hh : ");
		get(hh);
		--test format hh
		if hh<0 or hh>23 then condition_de_choix:=false;
				      put_line("hh incorrect");
				 else NULL;
		end if;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
	loop
		condition_de_choix:=true;
		--acquisition mm
		put_line("mm : ");
		get(mm);
		--test format mm
		if mm<0 or mm>59 then condition_de_choix:=false;
				      put_line("mm incorrect");
				 else NULL;
		end if;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
	new_line;
end heure;


--procedure menu_utilisateur
--semantique: menu permettant d'obtenir des infos, de louer/rendre un velo, de consulter/modifier un compte, obtenir le nombre de place et de velos de la stations et des stations environnantes
--parametres: liste_vel donnee/resultat type liste_velo
--	      liste_stat donnee type liste_station
--	      liste_comp donnee/resultat type liste_compte
--	      ident_station donnee type entier
--	      ident_compte donnee type entier
--pre-postcondition: aucune
--exception: aucune
procedure menu_utilisateur (liste_vel : IN OUT liste_velos; liste_stat : IN OUT liste_station; liste_comp : IN OUT liste_compte; ident_station : IN OUT integer; ident_compte : IN integer) is
choix : character; --choix d'action de l'utilisateur
ident_velo : integer; --identificateur du compte courant
credit : float; --somme a retirer du credit du compte
hh : integer; --heure de retrait et de depot d'un velo
mm : integer; --minutes de retrait et de depot d'un velo
condition_de_choix : boolean; --vrai tant que le choix est correct
continuerAEffectuerDesActions : boolean; --vrai tant que l'on veut rester dans le menu
x : float; --distance en metre
begin
continuerAEffectuerDesActions:=true;
loop
	loop
	condition_de_choix:=true;
	--acquisition choix
	put_line("Que voulez vous faire? ");
	put_line("(1)  Obtenir des informations sur le service Velo-toulouse");
	put_line("(2)  Louer un velo");
	put_line("(3)  Rendre un velo");
	put_line("(4)  Consulter/Modifier votre compte");
	put_line("(5)  Obtenir le nombre de places et de vélos de la station");
	put_line("(6)  Obtenir le nombre de places et de vélos des stations proches");
	put_line("(7)  Obtenir le nombre de places et de vélos des stations distantes de moins de X metres");
	put_line("(8)  Declarer le vol, la degradation ou la perte d'un velo");
	put_line("(9)  Changer de station");
	put_line("(q)  Quitter");
	get(choix);
	CASE choix is
		when '1' => --Info service
			    info_service;
		when '2' => --Louer un velo
				--test velos disponibles
			    if nombre_velos(liste_stat, ident_station)=0 then put_line("Il n'y a plus de velos dans cette station, consultez les stations proches");
									      new_line;
								     --test solvabilite
						    		else if retourne_credit(liste_comp, ident_compte)<=0.0 then Put_line("Vous etes ruiné.");
															new_line;
											     --test utilisateur deja en location
											else if est_en_location(liste_comp, ident_compte) then put_line("Vous etes deja en train de louer un velo");
														       			       new_line;
									    
									else --sinon afficher velos dispos
									     put_line("Les velos disponibles sont : ");
									     afficher_liste_velo_dispo(liste_vel, ident_station);
									     --acquisition ident_velo
									     put_line("Quel velo voulez vous louer? ");
									     get(ident_velo);
									     new_line;
									     --demander heure
									     heure(hh, mm);
									     --enregistrer heure dans le compte
									     changer_heure(liste_comp, ident_compte, hh, mm);
									     Put_line("Vous pouvez retirer le velo.");
									     new_line;
									     --modifier parametres velo (emplacement) 
									     --		   	   station (nombre de velos)
									     --			   compte (velo, en_location)
									     retirer_velo(liste_vel, ident_velo, ident_station, ident_compte);
									     dec_nombre_velos(liste_stat, ident_station);
									     changer_velo(liste_comp, ident_compte, ident_velo);
									     change_en_location(liste_comp, ident_compte);
								     end if;
							end if;
								
			    end if;
		when '3' => --Rendre un velo
				--test nombre places disponibles
			    if nombre_places(liste_stat, ident_station)=0 then put_line("Il n'y a plus de places dans cette station, consultez les stations proches");
									       new_line;
								      --test utilisateur pas en location
						    		 else if not est_en_location(liste_comp, ident_compte) then put("Vous n'avez loue aucun velo");
										else put_line("Vous pouvez deposer le velo a un emplacement libre.");
										     new_line;
										     --demander heure
								     		     heure(hh, mm);
										     --calculer la somme due et la retirer
								     		     credit:=calcule_credit(liste_comp, ident_compte, hh, mm); 
								     		     crediter_compte(liste_comp, ident_compte, credit);
								     		     Put_line("Vous pouvez deposer le velo.");
										     new_line;
										     --modifier parametres velo (station, compte) 
										     --		   	   station (nombre de velos)
										     --			   compte (en_location)
							 	     		     deposer_velo(liste_vel, ident_velo, ident_station, ident_compte);
									             inc_nombre_velos(liste_stat, ident_station);
										     change_en_location(liste_comp, ident_compte);
			    					      end if;
			    end if;
		when '4' => --Consulter/Modifier compte
			    consulter_modifier_compte(liste_comp, ident_compte);
		when '5' => --Info station courante
			    info_station(liste_stat, ident_station);
		when '6' => --Info station a moins de 1000m
			    info_station_alentours(liste_stat, ident_station);
		when '7' => --Info stations a moins de x metres
				--acquisition x
			    put_line("Entrez la distance X au format flottant :");
			    get(X);
			    new_line;
			    stations_moins_x_metres(liste_stat, ident_station, x);
		when '8' => --declarer perte, vol, deter
			    Put_line("Nous avons bien pris en compte votre declaration, la caution sera prelevee. Merci de votre sincerite.");
			    new_line;
			    enlever_caution(liste_comp, ident_compte);
		when '9' => --Changer station
			    changer_station(liste_stat, ident_station);
			    new_line;
			    --afficher nouvelle station
			    Put_line("Vous etes dans la station : ");
			    put(ident_station);
			    new_line;
		when 'q' => --Retour menu principal
			    ContinuerAEffectuerDesActions:=false;
		when OTHERS => --Seconde chance
			       put_line("nous n'avons pas compris votre choix.");
			       new_line;
			       condition_de_choix:=false;
	end case;
	exit when condition_de_choix;
	end loop;
	--condition_de_choix
exit when not continuerAEffectuerDesActions;
end loop;
--continuerAEffectuerDesActions
end menu_utilisateur;


--procedure menu_administrateur
--semantique: permet a l'admi d'ajouter/supprimer une station, des velos, de supprimer un compte et d'eteindre la station
--parametres: continuerAEffectuerDesActions resultat type booleen
--pre-postcondition: aucune
--exception: aucune
procedure menu_administrateur (ContinuerAEffectuerDesActions : OUT boolean; liste_vel : IN OUT liste_velos; liste_stat : IN OUT liste_station; liste_comp : IN OUT liste_compte) is
choix : character; --choix d'action de l'utilisateur
ident : integer; --identificateur de compte/velo/station
condition_de_choix : boolean; --vrai tant que le choix est correct
continuerAEffectuerDesActions_menu : boolean; --vrai tant qu'on souhaite rester dans ce menu
begin
	continuerAEffectuerDesActions_menu:=true;
	loop
		loop
			condition_de_choix:=true;
			--acquisition de choix
			put_line("Que voulez vous faire? ");
			put_line("(1)  Ajouter une station");
			put_line("(2)  Supprimer une station");
			put_line("(3)  Ajouter des velos");
			put_line("(4)  Supprimer des velos");
			put_line("(5)  Supprimer un utilisateur");
			put_line("(6)  Eteindre la station");
			put_line("(7)  Afficher l'ensemble des stations");
			put_line("(q)  Revenir au menu principal");
			get(choix);
			CASE choix is
				when '1' => --ajouter une station
					    ajouter_station(liste_stat);
				when '2' => --supprimer une station
						--acquisition ident
					    put("Quelle station voulez-vous supprimer? ");
					    get(ident);
					    new_line;
					    enlever_station(liste_stat, ident);
				when '3' => --ajouter un velo
					    ajouter_velo(liste_vel);
				when '4' => --supprimer un velo
						--acquisition ident
					    put("Quel velo voulez-vous supprimer?");
					    get(ident);
					    new_line;
					    enlever_velo(liste_vel, ident);
				when '5' => --supprimer un utilisateur
						--acquisition ident
					    put("Quel compte voulez-vous supprimer?");
					    get(ident);
					    new_line;
					    enlever_compte(liste_comp, ident);
				when '6' => --Eteindre la station
					    continuerAEffectuerDesActions_menu:=false;
					    continuerAEffectuerDesActions:=false;
				when '7' => --Afficher les stations
					    put_line("Ensemble des stations :");
					    afficher_liste_station(liste_stat);
					    NEW_LINE;
				when 'q' => --revenir menu principal
					    continuerAEffectuerDesActions_menu:=false;
				when OTHERS => --seconde chance
					       put_line("nous n'avons pas compris votre choix.");
					       condition_de_choix:=false;
			end case;
		exit when condition_de_choix;
		end loop;
		--condition_de_choix
	exit when not continuerAEffectuerDesActions_menu;
	end loop;
	--continuerAEffectuerDesActions_menu
end menu_administrateur;




--***********************************************--
--**         Declaration des variables         **--
--***********************************************--


liste_vel : liste_velos; --liste de tous les velos du systeme
liste_stat : liste_station; --liste de toutes les stations du systeme
liste_comp : liste_compte; --liste de tous les comptes du systeme
ident_station : integer; --identificateur de la station courante
ident_compte : integer;	--identificateur du compte courant
option_identifiant : integer; --0 : administrateur, 1 : utilisateur, 2 : aucun des deux
ContinuerAEffectuerDesActions : boolean; --vrai si l'on continue a effectuer des actions




--***********************************************--
--**    Implantation du programme principal    **--
--***********************************************--


Begin
	--initialisation des listes (velos, stations, comptes)
	init_velo(liste_vel);
	init_station(liste_stat);
	init_compte(liste_comp);
	--choix de la station courante
	put_line("Station courante : ");
	get(ident_station);
	new_line;
	--menu principal (dure jusqu'a ce que l'administrateur éteigne la station : ContinuerAEffectuerDesActions faux)
	ContinuerAEffectuerDesActions:=true;	
	loop			
		identification(liste_comp, ident_compte, option_identifiant);
		CASE option_identifiant is
			when 0 => menu_administrateur(ContinuerAEffectuerDesActions, liste_vel, liste_stat, liste_comp);
			when 1 => menu_utilisateur(liste_vel, liste_stat, liste_comp, ident_station, ident_compte);
			when 2 => NULL;
			when OTHERS => NULL;
		end case;
	exit when not ContinuerAEffectuerDesActions;
	end loop;
	--ContinuerAEffectuerDesActions est faux
end interface_utilisateur;
