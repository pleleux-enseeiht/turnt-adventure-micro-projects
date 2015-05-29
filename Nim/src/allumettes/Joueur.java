package allumettes;

/** La classe Joueur modélise un joueur. Un joueur a un nom. On peut demander à un joueur
 * le nombre d’allumettes qu’il veut prendre pour un jeu donné (getPrise). Un joueur détermine
 * le nombre d’allumettes à prendre en fonction de sa stratégie : naïf, rapide, expert ou humain.
 * La stratégie humain signifie que c’est l’utilisateur de l’application qui décide du nombre d’al-
 * lumettes à prendre. Il peut y avoir d’autres stratégies.
 *
 *
 * @author  Philippe Leleux
 * @version 1.0
 */

public interface Joueur {

	/** Obtenir le nom du joueur.
	 * @return nom du joueur
	 */
	public String getNom();

	/** Obtenir le nombre d'alumette que le joueur veut enlever selon sa stratégie.
	 * @param jeu le jeu en cours
	 * @return nombre d'allumettes prises
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'alumettes
	 * @throws ConfigurationException si la stratégie en paramètre n'est pas valide
	 */
	public int getPrise(Jeu jeu) throws OperationInterditeException;
}

