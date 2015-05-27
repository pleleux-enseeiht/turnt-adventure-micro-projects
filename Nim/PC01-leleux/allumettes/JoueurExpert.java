package allumettes;

/** La classe JoueurExpert permet au joueur de gagner a coup sur si c'est possible
 *
 * @author  Philippe Leleux
 * @version 1.0
 */
public class JoueurExpert implements Joueur{
    
// Attributs

	private String nom;		//Le nom du joueur	

// Constructeur

	/** Créer un joueur à partir de son nom.
	 * @param vnom nom du joueur
	 */
	public JoueurExpert(String vnom) {
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
	public int getPrise(Jeu jeu) {
		int prise;	// nombre d'allumettes prises par le joueur
		// le nombres d'allumettes restantes doit etre 4n+1. Si impossible, on prend 1
		switch (jeu.getNombreAllumettes()%4) {
			case 0	: prise = 3;
				  break;
			case 3	: prise = 2;
				  break;
			default	: prise = 1;
				  break;
		}
		return prise;
	}

}
