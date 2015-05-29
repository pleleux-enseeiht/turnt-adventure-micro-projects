package allumettes;

/**
  * Cette exception indique un coup invalide : un joueur tente
  * d'enlever plus d'allumettes qu'il ne peut.
  * @author	Philippe Leleux
  * @version	1.0
  */

public class CoupInvalideException extends Exception {

	/** Initialiser CoupInvalideException à partir du nombre d'allumettes
	 * prises.
	 * @param nb le nombre d'allumettes prises
	 */
	public CoupInvalideException(int nb) {
		super("Prise invalide : " + nb);
	}

}
