package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/** Programme de test de la classe Partie.
  * @author	Philippe Leleux
  * @version	1.0
  */
public class TestPartie {

// Attributs

	private JeuTab jeu;
	private String expert[] = {"e", "expert"};
	private String naif[] = {"n", "naif"};
	private String humain[] = {"h", "humain"};
	private String rapide[] = {"r", "rapide"};
	private String triche[] = {"t", "triche"};
	private String exception1[] = {"toto", "toto", "humain"};
	private String exception1bis[] = {};
	private String exception2[] = {"toto", "exception"};


// Initialisation du jeu et des différents joueurs

	@Before
	public void setUp() {
		jeu = new JeuTab(13);
	}

// Test de la methode Partie.nouveauJoueur en fonctionnement normal

	@Test
	public void TestNouveauJoueur() {
		Joueur e, r, h, n, t;

		e = Partie.nouveauJoueur(expert);
		assertEquals(e.getNom(), "e");
		e = new JoueurExpert("expert");

		r = Partie.nouveauJoueur(rapide);
		assertEquals(r.getNom(), "r");	
		r = new JoueurRapide("rapide");	

		h = Partie.nouveauJoueur(humain);
		assertEquals(h.getNom(), "h");
		h = new JoueurHumain("humain");

		n = Partie.nouveauJoueur(naif);
		assertEquals(n.getNom(), "n");
		n = new JoueurNaif("naif");

		t = Partie.nouveauJoueur(triche);
		assertEquals(t.getNom(), "t");
		t = new JoueurTriche("triche");	
	}


// Test de la methode Partie.nouveauJoueur avec levée d'exception

	// Exception trop d'arguments
	@Test(expected = ConfigurationException.class)
	public void TestNouveauJoueurException() {
		Joueur ex;		
		ex = Partie.nouveauJoueur(exception1);
	}

	// Exception pas assez d'arguments
	@Test(expected = ConfigurationException.class)
	public void TestNouveauJoueurException1() {
		Joueur ex;		
		ex = Partie.nouveauJoueur(exception1bis);
	}

	// Exception Stratégie incorrecte
	@Test(expected = ConfigurationException.class)
	public void TestNouveauJoueurException2() {
		Joueur ex;		
		ex = Partie.nouveauJoueur(exception2);
	}

/* La fonction main n'a pas besoin d'être testée, en effet elle ne fait que faire appel
 * à d'autres fonction que l'on teste dans les autres classes de test.
*/ 

		

// Main

	public static void main(String[] args) {
		org.junit.runner.JUnitCore.main(TestPartie.class.getName());
		}	

}
