package allumettes;

/** La classe JoueurNaif fait prendre au joueur un nombre aléatoire d'allumettes a chaque tour
 *
 * @author  Philippe Leleux
 * @version 1.0
 */
public class JoueurNaif implements Joueur{
    
// Attributs

	private String nom;		//Le nom du joueur	

// Constructeur

	/** Créer un joueur à partir de son nom.
	 * @param vnom nom du joueur
	 */
	public JoueurNaif(String vnom) {
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
		int n = 3;	// nombre maximum d'allumettes que l'on peut prendre
		// initialisation d'un Random (generateur de nombres aleatoires)
		java.util.Random generator = new java.util.Random() ;
		if (jeu.getNombreAllumettes()<3) {
			n = jeu.getNombreAllumettes();
		}
		// prise prend un nombre aleatoire compris entre 1 et n
		prise = generator.nextInt(n)+1;
		return prise;
	}

}
