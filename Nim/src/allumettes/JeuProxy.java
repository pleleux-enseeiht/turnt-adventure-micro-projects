package allumettes;

/** La classe JeuProxy implante les proxy de jeu
 * @author  Philippe Leleux
 * @version 1.0
 */

public class JeuProxy implements Jeu {

// Attributs

	private int nombreAllumettes;	// nombre d'allumettes restantes

// Constructeur

	/** Construire un jeu en initialisant le nombre d'allumettes a 13.
	 */
	public JeuProxy (Jeu jeu) {
		this.nombreAllumettes = jeu.getNombreAllumettes();
	}

// Methodes

	/** Obtenir le nombre d'allumettes encore en jeu.
	 * @return nombre d'allumettes encore en jeu
	 */
	public int getNombreAllumettes() {
		return this.nombreAllumettes;
	}

	/** Retirer des allumettes.
	 * @param nbPrises nombre d'allumettes prises.  Le nombre d'allumettes
	 * prises doit etre compris entre 1 et PRISE_MAX, dans la limite du nombre
	 * d'allumettes encore en jeu.	XXX
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'alumettes
	 */
	public void retirer(int prise) throws OperationInterditeException {
			throw new OperationInterditeException();
	}

}

