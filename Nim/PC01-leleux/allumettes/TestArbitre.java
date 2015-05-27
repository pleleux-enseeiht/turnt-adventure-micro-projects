package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/** Programme de test de la classe Arbitre.
  * Pour tester complètement cette classe il faudrait considérer toutes les parties possibles ce qui,
  * même sans considérer la classe humain nous ramène à 16 cas. On va lancer un arbitrage de chaque 
  * partie normale puis tester les cas où des exceptions doivent être levées pour tricherie.
  * 
  * @author	Philippe Leleux
  * @version	1.0
  */
public class TestArbitre {

// Attributs

	private JeuTab jeu;
	private Arbitre arbitre;
	private Joueur expert1, expert2;
	private Joueur naif1, naif2;
	private Joueur rapide1, rapide2;
	private Joueur triche1, triche2;

// Initialisation du jeu et des differents joueurs

	@Before
	public void setUp() {
		jeu = new JeuTab(13);
		expert1 = new JoueurExpert("expert1");
		expert2 = new JoueurExpert("expert2");
		naif1 = new JoueurNaif("naif1");
		naif2 = new JoueurNaif("naif2");
		rapide1 = new JoueurRapide("rapide1");
		rapide2 = new JoueurRapide("rapide2");
		triche1 = new JoueurTriche("triche1");
		triche2 = new JoueurTriche("triche2");
	}

// Test des parties normales : expert||rapide||naif

	@Test
	public void testArbitrer() {
		arbitre = new Arbitre(expert1, expert2);
		arbitre.arbitrer(jeu);

		arbitre = new Arbitre(expert1, naif1);
		arbitre.arbitrer(jeu);
		arbitre = new Arbitre(naif1, expert1);
		arbitre.arbitrer(jeu);

		arbitre = new Arbitre(expert1, rapide1);
		arbitre.arbitrer(jeu);
		arbitre = new Arbitre(rapide1, expert1);
		arbitre.arbitrer(jeu);

		arbitre = new Arbitre(naif1, naif2);
		arbitre.arbitrer(jeu);

		arbitre = new Arbitre(naif1, rapide1);
		arbitre.arbitrer(jeu);
		arbitre = new Arbitre(rapide1, naif1);
		arbitre.arbitrer(jeu);

		arbitre = new Arbitre(rapide1, rapide2);
		arbitre.arbitrer(jeu);
	}

// Test des tricheries

	@Test(expected = TricheException.class)
	public void testTriche1() throws TricheException {
		arbitre = new Arbitre(triche1, triche2);
		arbitre.arbitrer(jeu);		
	}

	@Test(expected = TricheException.class)
	public void testTriche2() throws TricheException {	
		arbitre = new Arbitre(triche1, expert1);
		arbitre.arbitrer(jeu);
	}
	@Test(expected = TricheException.class)
	public void testTriche3() throws TricheException {	
		arbitre = new Arbitre(expert1, triche1);
		arbitre.arbitrer(jeu);
	}

	@Test(expected = TricheException.class)
	public void testTriche4() throws TricheException {
		arbitre = new Arbitre(triche1, naif1);
		arbitre.arbitrer(jeu);
	}
	@Test(expected = TricheException.class)
	public void testTriche5() throws TricheException {
		arbitre = new Arbitre(naif1, triche1);
		arbitre.arbitrer(jeu);
	}

	@Test(expected = TricheException.class)
	public void testTriche6() throws TricheException {
		arbitre = new Arbitre(triche1, rapide1);
		arbitre.arbitrer(jeu);
	}
	@Test(expected = TricheException.class)
	public void testTriche7() throws TricheException {
		arbitre = new Arbitre(rapide1, triche1);
		arbitre.arbitrer(jeu);
	}

// Main

	public static void main(String[] args) {
		org.junit.runner.JUnitCore.main(TestArbitre.class.getName());
	}	

}
