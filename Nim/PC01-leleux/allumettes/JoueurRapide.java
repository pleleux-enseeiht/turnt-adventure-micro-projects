package allumettes;

/** La classe JoueurRapide fait prendre au joueur le plus d'allumettes que possible a chaque tour
 *
 * @author  Philippe Leleux
 * @version 1.0
 */
public class JoueurRapide implements Joueur{
    
// Attributs

	private String nom;		//Le nom du joueur	

// Constructeur

	/** Créer un joueur à partir de son nom.
	 * @param vnom nom du joueur
	 */
	public JoueurRapide(String vnom) {
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
		if (jeu.getNombreAllumettes()>2) {
			prise=3;
		} 
		else {
		    	prise=jeu.getNombreAllumettes();
		}
		return prise;
	}

}
