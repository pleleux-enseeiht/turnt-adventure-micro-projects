Procedure Morpion is
Type CASE est (Vide, Rond, Croix);
Type DAMIER is array(1..9) of CASE;
Type JOUEUR est (Rond, Croix);
Type ETAT_JEU est (EN_COURS, GAGNE, NUL);
le_damier : DAMIER;
le_joueur : JOUEUR;
l_etat : ETAT_JEU;

--DECLARATION DES SOUS-PROGRAMMES

	--s�mantique : initialiser le damier (matrice 3*3) avec des cases vides et permettre au premier joueur de choisir entre croix et rond.
	--Param�tres : Fle_damier : DAMIER r�sultat;  Fle_joueur : JOUEUR r�sultat; le damier et le joueur;
	--type retour : 
	--pr�conditions : 
	--postconditions : 
	
	procedure initialiser_jeu (Fle_damier : OUT DAMIER; Fle_joueur : OUT JOUEUR;) is
	begin
	--initialiser damier
	For i in 1..9 loop
		Fle_damier(i):=Vide;
	End loop;
	--initialiser joueur
	put_line("Que choisit le premier joueur? Rond/Croix");
	get(Fle_joueur);
	end initialiser_jeu;
	
	--s�mantique : afficher le damier gr�ce � des lettres et symboles.
	--Param�tres : Fle_damier : DAMIER donn�e;  Fle_joueur : JOUEUR donn�e; le damier et le joueur;
	--type retour : 
	--pr�conditions : Fle_damier et Fle_joueur sont initialis�
	--postconditions : 
	
	procedure afficher_jeu (Fle_damier : IN DAMIER; Fle_joueur : IN JOUEUR;) is
	begin
	--convertir damier en symboles
	For i in 1..9 loop
		Case Fle_damier(i) is
			Rond => damier_carac(i):='o';
			Croix => damier_carac(i):='x';
			Autres => damier_carac(i):=' ';
		End case;
	End loop
	--afficher ligne par ligne
	For i in 0..2 loop
		--afficher case par case
			For j in 1..3 loop
				put(' ');
				put(damier_carac(i+j));
				put('|');
			End loop
		new_line;
		put("-- - --");
		new_line;
	End loop;
	end afficher_jeu;
	
	--s�mantique : demander au joueur sur quelle case il joue et d�terminer si la partie est termin�e.
	--Param�tres : Fle_damier : DAMIER donn�e/r�sultat;  Fle_joueur : JOUEUR donn�e; Fl_etat : ETAT_JEU donn�e/r�sultat; le damier, le joueur et l'�tat du jeu;
	--type retour : 
	--pr�conditions : Fle_damier et Fle_joueur sont initialis�
	--postconditions : 
	
	procedure jouer (Fle_damier : IN OUT DAMIER; Fle_joueur : IN JOUEUR; Fl_etat : IN OUT ETAT_JEU;) is
	nombre_de_coups : integer; --le nombre de coups jou�s depuis le d�but de la partie
	begin
	--compter le nombre de coups jou�s
	nombre_de_coups:=1; --on compte d�j� le coups qui va etre jou� ensuite
	for i in 1..9 loop
		if not Fle_damier(i)=Vide then nombre_de_coups:=nombre_de_coups+1;
		else NULL;
		end if;
	end loop;
	--demander au joueur sur quelle case il veut jouer
	put("Au tour des");
	put(chaine(le_joueur));
	put("Sur quelle case voulez-vous jouer? Entrez un nombre entre 1 et 9");
	--modifier la case correspondante
	le_damier(lire(case_a_jouer)):=le_joueur;
	--d�terminer l'�tat de la partie
		--�diter l'�tat de la partie si elle est gagn�e
		if ((le_damier(1)/=Vide and le_damier(1)=le_damier(2) and ledamier(2)=le_damier(3))
		or(le_damier(4)/=Vide and le_damier(4)=le_damier(5) and le damier(5)=le_damier(6))
		or(le_damier(7)/=Vide and le_damier(7)=le_damier(8) and le damier(8)=le_damier(9))
		or(le_damier(1)/=Vide and le_damier(1)=le_damier(5) and le damier(5)=le_damier(9))
		or(le_damier(7)/=Vide and le_damier(7)=le_damier(5) and le damier(5)=le_damier(3))
		or(le_damier(1)/=Vide and le_damier(1)=le_damier(4) and le damier(4)=le_damier(7))
		or(le_damier(2)/=Vide and le_damier(2)=le_damier(5) and le damier(5)=le_damier(8))
		or(le_damier(3)/=Vide and le_damier(3)=le_damier(6) and le damier(6)=le_damier(9))) then l_etat:=GAGNE;
		--�diter l'�tat de la partie si elle est nulle
		else if nombre_de_coups=9 then l_etat:=NUL;
			else NULL;
			end if;
		end if;
	--changer de joueur si la partie doit continuer
	if l_etat=EN_COURS then if le_joueur=Rond then le_joueur:=Croix;
						    else le_joueur:=Rond;
				            end if;
	else NULL;
	end if;
	end jouer;
	
begin
	initialiser_jeu(le_damier, le_joueur);
	afficher_jeu(le_damier, le_joueur);
	loop
		jouer(le_damier, le_joueur, l_etat);
		afficher_jeu(le_damier, le_joueur);
	exit when not l_etat=EN_COURS;
	end loop;
	if l_etat=NUL then put("Match nul");
	else put(le_joueur);
         put("a gagn�. F�licitations!");
	end if;
end Morpion;