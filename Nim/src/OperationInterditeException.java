package allumettes;

/**
  * Cette exception indique que la classe 
  * d'enlever plus d'allumettes qu'il ne peut.
  * @author	Philippe Leleux
  * @version	1.0
  */

public class OperationInterditeException extends Exception {

	/** Initialiser OperationInterditeException
	 * @param nb le nombre d'allumettes prises
	 */
	public OperationInterditeException() {
		super("Les classes Joueur n'ont pas droit d'accès au jeu");
	}

}
