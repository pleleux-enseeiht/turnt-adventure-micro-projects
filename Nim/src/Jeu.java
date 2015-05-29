package allumettes;

/** L'interface Jeu définit le jeu des 13 allumettes, y compris les règles sur la prise des
 * allumettes : le nombre maximum d'allumettes que l'on peut prendre (la constante PRISE_MAX, 
 * identique pour toutes les parties)
 *
 * @author  Philippe Leleux
 * @version 1.0
 */

public interface Jeu {

// Attributs

	int PRISE_MAX = 3;	//Nombre maximal d'allumettes pouvant etre prises.

// Entêtes des méthodes

	/** Obtenir le nombre d'allumettes encore en jeu.
	 * @return nombre d'allumettes encore en jeu
	 */
	public int getNombreAllumettes();

	/** Retirer des allumettes.
	 * @param nbPrises nombre d'allumettes prises.  Le nombre d'allumettes
	 * prises doit etre compris entre 1 et PRISE_MAX, dans la limite du nombre
	 * d'allumettes encore en jeu.	XXX
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'alumettes
	 */
	public void retirer(int nbPrises) throws CoupInvalideException, OperationInterditeException;

}

