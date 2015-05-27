package allumettes;

/** La classe Arbitre fait respecter les règles du jeu aux deux joueurs. Cette classe possède un
 * constructeur qui prend en paramètre les deux joueurs j1 et j2 qui vont s’affronter. Une partie
 * peut alors être arbitrée entre ces deux joueurs. L’arbitre fait jouer, à tour de rôle, chaque joueur
 * en commençant par le joueur j1. Celui qui prend la dernière allumette a perdu. Faire jouer un
 * joueur consiste à lui demander le nombre d’allumettes qu’il souhaite prendre, puis à les retirer
 * du jeu. Si ceci provoque une violation des règles du jeu (exception CoupInvalideException), le
 * même joueur devra rejouer.
 *
 * @author  Philippe Leleux
 * @version 1.0
 */

public class Arbitre {

// Attributs

	private Joueur joueur1;		//Joueur 1
	private Joueur joueur2;		//Joueur 2

// Constructeur
	
	/** Construire un arbitre à partir des joueurs 1 et 2.
	 * @param vjoueur1 joueur 1
	 * @param vjoueur2 joueur 2
	 */
	public Arbitre(Joueur vjoueur1,Joueur vjoueur2) {
		this.joueur1 = vjoueur1;
		this.joueur2 = vjoueur2;
	}    
	    
// Methodes

	/** arbitrer la partie : faire joueur les joueurs à tour de role en verifiant le respect des regles de la partie.
	 * Il traite les exception dues à un coup invalide ou une erreur au niveau de l'entree au clavier de la prise.
	 * @param jeu le jeu indiquant le nombre d'allumettes restantes
	 * @throws tricheException tentative de triche de la part d'un des joueurs
	 */
	public void arbitrer(JeuTab jeu)  {
		int prise = 3;				// nombre d'allumettes prises, par défaut à 3 (ce cas est inutile en pratique)
		int nombreAllumettesInitial;		// nombre d'allumettes avant qu'un des joueurs ne joue
		int i = 0;				// variable qui permet de changer de joueur à chaque tour
		boolean perdu = false;			// vaut vrai lorsque la partie est terminee
		Joueur joueurs[] = {joueur1, joueur2};	// vecteur de joueur : on switche entre les deux cases à chaque tour
		// perdu est faux		
		while (!perdu) {
			try {
				nombreAllumettesInitial = jeu.getNombreAllumettes();
				System.out.println();
				System.out.println("Nb d'allumettes restantes : " + jeu.getNombreAllumettes());
				System.out.println("Au tour de " + joueurs[i%2].getNom());
				// Recuperation du nombre d'allumettes prises par le joueur
				prise = joueurs[i%2].getPrise(jeu.requete());
				System.out.println(joueurs[i%2].getNom() + " prend " + prise + " allumette(s)");
				// Retrait des allumettes (renvoie une CoupInvalideException si la prise est invalide)
				jeu.retirer(prise);
				// Teste si le jeu est fini, si non alors on change de joueur
				if (jeu.getNombreAllumettes()==0) {
					perdu = true;
				}
				else {
					i++;
				}
			}
			// Traite le cas d'une prise invalide
			catch (CoupInvalideException e) {
				System.out.println();
				System.out.println(e.getMessage());
			}
			// Traite le cas d'une triche en quittant le jeu
			catch (OperationInterditeException e) {
				System.out.println();
				System.out.println("L'arbitre prend le joueur en flagrant délit de tricherie, la partie est terminee");
				System.exit(1);
			}
			// Traite le cas ou l'entree au clavier n'est pas un entier
			catch (java.util.InputMismatchException e) {			
			System.out.println();
			System.out.println("Le nombre d'allumettes que vous entrez est par définition un nombre, entrez un entier!");
			}
			// Traite le cas ou on ne peut plus entrer de nouvel element dans le scanner
			catch (java.util.NoSuchElementException e) {
				System.out.println();
				System.out.println("Erreur scanner : input exhausted");			
			}
			// Traite le cas ou on a libere le scanner
			catch (java.lang.IllegalStateException e) {
				System.out.println();
				System.out.println("Erreur scanner : scanner deja ferme");
			}
		}
		// perdu vaut vrai
		System.out.println(joueurs[i%2].getNom() + " a perdu !");
	}

}
