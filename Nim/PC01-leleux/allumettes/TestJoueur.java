package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/** Programme de test des classes Joueur, JoueurExpert, JoueurNaif, JoueurHumain, JoueurRapide et JoueurTriche.
  * @author	Philippe Leleux
  * @version	1.0
  */
public class TestJoueur {

// Attributs

	private JeuProxy jeuProxy;
	private Joueur expert, naif, humain, rapide, triche;

// Initialisation des differents joueurs

	@Before
	public void setUp() {
		jeuProxy = new JeuProxy(new JeuTab(13));
		expert = new JoueurExpert("expert");
		naif = new JoueurNaif("naif");
		humain = new JoueurHumain("humain");
		rapide = new JoueurRapide("rapide");
		triche = new JoueurTriche("triche");
	}

// Test des getNom()

	@Test
	public void testGetNom() {
		assertTrue(expert.getNom().equals("expert"));
		assertTrue(naif.getNom().equals("naif"));
		assertTrue(humain.getNom().equals("humain"));
		assertTrue(rapide.getNom().equals("rapide"));
		assertTrue(triche.getNom().equals("triche"));
	}

// Test Complet des getPrise()
	// Joueur Expert
	@Test
	public void testGetPriseJoueurExpert() throws OperationInterditeException {
		// 13 allumettes restantes --> prise = 1
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 12 allumettes restantes --> prise = 3
		jeuProxy = new JeuProxy(new JeuTab(12));
		assertEquals(expert.getPrise(jeuProxy), 3);
		// 11 allumettes restantes --> prise = 2
		jeuProxy = new JeuProxy(new JeuTab(11));
		assertEquals(expert.getPrise(jeuProxy), 2);	
		// 10 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(10));
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 9 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(9));
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 8 allumettes restantes --> prise = 3
		jeuProxy = new JeuProxy(new JeuTab(8));
		assertEquals(expert.getPrise(jeuProxy), 3);
		// 7 allumettes restantes --> prise = 2
		jeuProxy = new JeuProxy(new JeuTab(7));
		assertEquals(expert.getPrise(jeuProxy), 2);
		// 6 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(6));
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 5 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(5));
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 4 allumettes restantes --> prise = 3
		jeuProxy = new JeuProxy(new JeuTab(4));
		assertEquals(expert.getPrise(jeuProxy), 3);
		// 3 allumettes restantes --> prise = 2
		jeuProxy = new JeuProxy(new JeuTab(3));
		assertEquals(expert.getPrise(jeuProxy), 2);
		// 2 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(2));
		assertEquals(expert.getPrise(jeuProxy), 1);
		// 1 allumette restante --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(1));
		assertEquals(expert.getPrise(jeuProxy), 1);
	}

	// Joueur Naif
	@Test
	public void testGetPriseJoueurNaif() throws OperationInterditeException {
		// 13 à 3 allumettes restantes --> 1 <= prise <= 3
		//ex : jeuProxy.getNombreAllumettes() = 13
		int prise = naif.getPrise(jeuProxy);
		assertTrue((naif.getPrise(jeuProxy)>=1) && (naif.getPrise(jeuProxy)<=3));
		//ex : jeuProxy.getNombreAllumettes() = 3
		jeuProxy = new JeuProxy(new JeuTab(3));
		prise = naif.getPrise(jeuProxy);
		assertTrue((naif.getPrise(jeuProxy)>=1) && (naif.getPrise(jeuProxy)<=3));
		// 2 allumettes restantes --> 0 <= prise = 2
		jeuProxy = new JeuProxy(new JeuTab(2));
		prise = naif.getPrise(jeuProxy);
		assertTrue((naif.getPrise(jeuProxy)>=1) && (naif.getPrise(jeuProxy)<=2));
		// 1 allumettes restantes --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(1));
		prise = naif.getPrise(jeuProxy);
		assertEquals(naif.getPrise(jeuProxy), 1);					
	}

	// Joueur Rapide
	@Test
	public void testGetPriseJoueurRapide() throws OperationInterditeException {				
		// 3 à 13 allumettes restantes --> prise = 3
		int i;
		for (i=13 ; i>2; i--) { 
			jeuProxy = new JeuProxy(new JeuTab(i));
			assertEquals(rapide.getPrise(jeuProxy), 3);
		}
		// 2 allumettes restantes --> prise = 2
		jeuProxy = new JeuProxy(new JeuTab(2));
		assertEquals(rapide.getPrise(jeuProxy), 2);
		// 1 allumette restante --> prise = 1
		jeuProxy = new JeuProxy(new JeuTab(1));
		assertEquals(rapide.getPrise(jeuProxy), 1);
	}

	// Joueur Triche
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche13() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(13));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche12() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(12));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche11() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(11));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche10() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(10));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche9() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(9));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche8() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(8));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche7() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(7));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche6() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(6));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche5() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(5));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche4() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(4));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche3() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(3));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche2() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(2));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 2);
	}	
	@Test(expected = OperationInterditeException.class)
	public void testGetPriseJoueurTriche1() throws OperationInterditeException {
		jeuProxy = new JeuProxy(new JeuTab(1));
		assertEquals(triche.getPrise(jeuProxy), 1);
		assertEquals(jeuProxy.getNombreAllumettes(), 1);
	}					

// Main

	public static void main(String[] args) {
		org.junit.runner.JUnitCore.main(TestJoueur.class.getName());
	}	

}
