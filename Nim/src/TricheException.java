package allumettes;

/**
  * Cette exception indique un cas de triche : un joueur tente d'enlever un 
  * nombre d'allumettes différent de la prise qu'il indique.
  * @author	Philippe Leleux
  * @version	1.0
  */

public class TricheException extends Exception {

	/** Initialiser TricheException avec le message "Cas de triche"
	 * prises.
	 * @param nb le nombre d'allumettes prises
	 */
	public TricheException() {
		super("Cas de triche");
	}

}
