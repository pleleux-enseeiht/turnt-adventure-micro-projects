package allumettes;

import java.util.*;

/** La classe JoueurHumain fait entrer au clavier le nombre d'allumettes a prendre
 *
 * @author  Philippe Leleux
 * @version 1.0
 */
public class JoueurHumain implements Joueur{
    
// Attributs

	private String nom;		//Le nom du joueur	

// Constructeur

	/** Créer un joueur à partir de son nom.
	 * @param vnom nom du joueur
	 */
	public JoueurHumain(String vnom) {
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
		System.out.println("Combien prenez vous d'allumettes ? ");
		// initialisation d'un scanner avec en entree System.in
		Scanner sc = new Scanner(System.in);
		// prise prend la premiere entree formatee en entier et renvoie une exception si l'entree n'est pas un entier
		prise = sc.nextInt();
		return prise;
	}

}
