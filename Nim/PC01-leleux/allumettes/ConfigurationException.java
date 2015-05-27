package allumettes;

/** Levée pour indiquer que la configuration d'une partie est incorrecte.
 * @author	Xavier Crégut
 * @version	$Revision: 1.3 $
 */
public class ConfigurationException extends RuntimeException {

	/** Initaliser une ConfigurationException avec le message précisé.
	  * @param message le message explicatif
	  */
	public ConfigurationException(String message) {
		super(message);
	}

}
