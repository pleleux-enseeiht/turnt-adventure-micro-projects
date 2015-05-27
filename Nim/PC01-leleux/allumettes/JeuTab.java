package allumettes;

/** La classe Jeu définit le nombre d'allumettes restantes.
 * On peut retirer des allumettes du jeu tant que l'on respecte les regles :
 * 1 < prise <= PRISE_MAX
 * prise <= nombreAllumettes
 *
 * @author  Philippe Leleux
 * @version 1.0
 */

public class JeuTab implements Jeu {

// Attributs

	private int nombreAllumettes;	// nombre d'allumettes restantes

// Constructeur

	/** Construire un jeu en initialisant le nombre d'allumettes a 13.
	 */
	public JeuTab (int nombreInitialAllumettes) {
		this.nombreAllumettes = nombreInitialAllumettes;
	}

// Methodes

	/** Obtenir une copie en proxy du jeu
	 * @return jeuProxy la copie du jeu
	 */
	public JeuProxy requete() {
		return new JeuProxy(this);
	} 

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
	public void retirer(int prise) throws CoupInvalideException {
		if ((prise > Jeu.PRISE_MAX) || (prise > this.nombreAllumettes) || prise < 1) {
			throw new CoupInvalideException(prise);
                }
		else {
			this.nombreAllumettes -= prise;
		}
	}

}

