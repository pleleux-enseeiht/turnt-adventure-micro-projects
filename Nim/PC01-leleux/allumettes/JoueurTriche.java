package allumettes;

/** La classe JoueurExpert permet au joueur d'enlever toutes les allumettes sauf 2 en faisant 
 * directement appel à la méthode jeu.retirer et de demander une prise de seulement 1 à l'arbitre : 
 * c'est à dire gagner en un coup
 *
 * @author  Philippe Leleux
 * @version 1.0
 */
public class JoueurTriche implements Joueur{
    
// Attributs

	private String nom;		//Le nom du joueur	

// Constructeur

	/** Créer un joueur à partir de son nom.
	 * @param vnom nom du joueur
	 */
	public JoueurTriche(String vnom) {
		this.nom = vnom;
	}
       
// Methodes

	/** Obtenir le nom du joueur.
	 * @return nom du joueur
	 */
	public String getNom() {
		return this.nom;
	}

	/** Obtenir le nombre d'allumette que le joueur veut enlever
	 * @param jeu le jeu en cours
	 * @return nombre d'allumettes prises
	 */
	public int getPrise(Jeu jeu) throws OperationInterditeException {
		/* Faire appel directement à la méthode jeu.retirer peut lever une exception CoupInvalideException
		 * qui ne serait pas traiter par la méthode qui l'appelle. Il faut la lever et la traiter ici.
		 */
		try {
			//Retrait de toutes les allumettes sauf deux
			while (jeu.getNombreAllumettes()>2) {
				jeu.retirer(1);
			}			
		}
		//Cas d'un coup invalide
		catch (CoupInvalideException e) {
			System.out.println();
			System.out.println("Vous êtes un mauvais tricheur.");
		}
		// Prise de la pénultième allumette
		return 1;
	}

}
