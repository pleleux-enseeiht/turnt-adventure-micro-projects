package allumettes;

/** Vérifier que l'arbitre détecte la tricherie d'un joueur.
  * @author	Xavier Crégut
  * @version	$Revision: 1.5 $
  */
public class ExempleTriche {

	public static void main(String[] args) {
			String[] argumentsExempleTriche = new String[2];
			argumentsExempleTriche[0] = "joueur1@triche";
			argumentsExempleTriche[1] = "joueur2@expert";
			Partie.main(argumentsExempleTriche);
	}

}
