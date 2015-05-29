package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/** Programme de test des classes Jeu et JeuTab.
  * @author	Philippe Leleux
  * @version	1.0
  */
public class TestJeu {

// Attributs

	private JeuTab jeu;

// Initialisation des differents joueurs

	@Before
	public void setUp() {
		jeu = new JeuTab(13);
	}

// Vérification de la constante de classe Jeu.PRISE_MAX

	@Test
	public void testPriseMax() {
		assertEquals(Jeu.PRISE_MAX, 3);
	}

// Test des methodes getNombreAllumettes et retirer

	// Test en fonctionnement normal des méthodes
	@Test
	public void descenteTest() throws CoupInvalideException {
		int i;
		for (i=13; i>0; i--) {
			assertEquals(jeu.getNombreAllumettes(), i);
			jeu.retirer(1);
		}
	}

	// Tests avec des exceptions levées
		// prise > Jeu.PRISE_MAX
		@Test(expected = CoupInvalideException.class)
		public void retirerExceptionSupPRISEMAX() throws CoupInvalideException {	
			jeu.retirer(4);
		}
		
		// prise > Jeu.PRISE_MAX && prise > this.nombreAllumettes
		@Test(expected = CoupInvalideException.class)
		public void retirerExceptionSupNombreAllumettes() throws CoupInvalideException {	
			jeu.retirer(44);
		}

		// prise < 1
		@Test(expected = CoupInvalideException.class)
		public void retirerExceptionInfUn() throws CoupInvalideException {
			jeu.retirer(-1);
		}



// Main

	public static void main(String[] args) {
		org.junit.runner.JUnitCore.main(TestJeu.class.getName());
	}	

}
