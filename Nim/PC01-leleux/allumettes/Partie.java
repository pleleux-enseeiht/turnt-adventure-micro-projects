package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Partie {

	private static JeuTab jeu = new JeuTab(13);	// initialisation de la partie

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 * @throws ConfigurationException si le format en entrée n'est pas correct
	 */
	public static void main(String[] args) {
        String[] nomStrategieJoueur1 = new String[2];	// tableau contenant le nom et la strategie du joueur 1
        String[] nomStrategieJoueur2 = new String[2];	// idem pour le joueur 2
		try {
			// renvoie une ConfigurationException si trop d'arguments
			if (args.length != 2) {
				throw new ConfigurationException("nombre invalide d'arguments : " +
						args.length + " au lieu de 2.");
			}
			else {
			// On découpe les arguments avec @ comme séparation pour obtenir nom et strategie
			nomStrategieJoueur1 = args[0].split("@");
			nomStrategieJoueur2 = args[1].split("@");
			/* initialisation d'un arbitre avec les deux joueurs initialises
			*/
			Arbitre arbitre= new Arbitre(nouveauJoueur(nomStrategieJoueur1), nouveauJoueur(nomStrategieJoueur2));
			// arbitrage de la partie 
                	arbitre.arbitrer(jeu);
			}			
		}
		// Traite le cas d'une erreur d'arguments en donnant le format valide et quittant le jeu
		catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Partie joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Partie Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

	/** Creer un nouveau joueur a partir de son nom et sa strategie (renvoie une ConfigurationException si le
	 * format est incorrect. Ex : ordi@expert@naif)
	 * @param nomStrategieJoueur la description des deux joueurs en tableau de String
	 * @return joueur initialise
	 * @throws ConfigurationException si le format en entrée n'est pas correct
	 */
	public static Joueur nouveauJoueur(String[] nomStrategieJoueur) {
		if (nomStrategieJoueur.length!=2) {
			throw new ConfigurationException("Format de l'entree incorrect");
		}
		else {
    			Joueur joueur;
			if (nomStrategieJoueur[1].equalsIgnoreCase("humain")) {
				joueur = new JoueurHumain(nomStrategieJoueur[0]);
			}
			else if (nomStrategieJoueur[1].equalsIgnoreCase("naif")) {
				joueur = new JoueurNaif(nomStrategieJoueur[0]);        
			} 
			else if (nomStrategieJoueur[1].equalsIgnoreCase("rapide")) {
				joueur = new JoueurRapide(nomStrategieJoueur[0]);        
			} 
			else if (nomStrategieJoueur[1].equalsIgnoreCase("expert")) {
				joueur = new JoueurExpert(nomStrategieJoueur[0]); 
			}
			else if (nomStrategieJoueur[1].equalsIgnoreCase("triche")) {
				joueur = new JoueurTriche(nomStrategieJoueur[0]);
			}
			else {
				throw new ConfigurationException("Nom de strategie incorrect");
			}              
			return joueur;
		}
	}

}
