library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--entity RxUnit is
--  port (
--    clk, reset       : in  std_logic;
--    enable           : in  std_logic;
--    rd               : in  std_logic;
--    rxd              : in  std_logic;
--    data             : out std_logic_vector(7 downto 0);
--    Ferr, OErr, DRdy : out std_logic);
--end RxUnit;

architecture RxUnit_archi of RxUnit is

--tmpclk : horloge donnant la cadence de reception (F.M : après 8 F.M de enable puis tous les 16 jusqu'à fin de reception)
signal tmpclk : std_logic;
--tmprxd : signal d'emission temporaire
signal tmprxd : std_logic;
--suit les variations de Ferr : erreur de transmission
signal FerrRe : std_logic := '0';
--suit les variations de OErr : erreur de communication avec le CPU
signal OErrRe : std_logic := '0';

begin  

--process compteur16 : compte le nombre de signaux enable et va transmettre les donnees
-- recuperees sur rxd a la bonne cadence (tmpclk) au second process via tmprxd
  compteur16 : process (enable, reset)
	  --t_etat : type de l'etat courant du process compteur16 :
			--attente : compteur16 attend qu'on transmette une donnee au recepteur et donne le premier F.M de tmpclk après 8 enable ==> reception
			--reception : tpmrxd recoit bit a bit la valeur de rxd sur F.M de tmpclk (tous les 16 enable) jusqu a reception finie ==> attente
  		type t_etat is (attente, reception);
	  --etat : au depart compteur16 est en attente
		variable etat : t_etat := attente;
	  --cpt_enable : compte le nombre de enable pour donner les F.M de tmpclk (cpt_enable = 0)
		variable cpt_enable : natural := 8;
	  --cpt_reception : compte le nombre de F.M de tmpclk et la fin de la reception (cpt_reception = 0)
		variable cpt_reception : natural := 6;
  
  begin
		if reset = '0' then
			--au reset, tmpclk/tmprxd au repos
			--				cpt_enable à 8/cpt_reception a 0
			--				etat d'attente
			tmpclk <= '0';
			tmprxd <= '1';
			cpt_enable := 8;
			cpt_reception := 0;
			etat := attente;
		elsif (rising_edge(enable)) then
			case etat is
				when attente =>
					--on attend la transmission au recepteur (rxd = 0)
					if (rxd = '0' and OErrRe = '0' and FerrRe = '0') then
						cpt_enable := (cpt_enable + 1) mod 16;
						--premier F.M de tmpclk après 8 enable (cpt_enable = 0)
						if (cpt_enable = 0) then
							tmpclk <= '1';
							tmprxd <= rxd;
							--==> reception
							etat := reception;
						else
							tmpclk <= '0';
						end if;
					else
						tmpclk <= '0';
					end if;
				when reception =>
					--tous les 16 enable (cpt_enable = 0) : tpmrxd recoit la valeur de rxd, F.M de tmpclk (tous les 16 enable)
					cpt_enable := (cpt_enable + 1) mod 16;
					if (cpt_enable = 0) then
						tmpclk <= '1';
						tmprxd <= rxd;
						cpt_reception := cpt_reception + 1;
						--on s arrete a la fin de la transmission (cpt_reception = 10)
						if (cpt_reception = 10) then
							cpt_enable := 8;
							cpt_reception := 0;
							--==>attente
							etat := attente;							
						end if;
					else 
						tmpclk <= '0';
					end if;
			end case;
		end if;
  end process;
				
--

  controle : process (enable, reset)

	  --type de l'etat courant du process controle :
			--controle : recoit et stocke la donnee de tmprxd
			--				 controle la parite et le bit de stop a la fin de la reception 
			--				 signale au CPU qu'il peut lire la donnee 							==> envoi
			--envoi : verifie si il n'y a pas eu d'erreur de communication avec le CPU ==> controle
		type t_etat is (controle, envoi);
	  --etat : au depart controle est a l'etat controle
		variable etat : t_etat := controle;
	  --tmpdata : contient la donnee entiere transmise par tmprxd
		variable tmpdata : std_logic_vector(7 downto 0) := (others => '0');
	  --DRdyRe : suit les varitations de DRdyRe : donnee prete a etre lue par le CPU
		variable DRdyRe : std_logic := '0';
	  --par : bit de parite recu
		variable par : std_logic;
	  --parRe : bit de parite calcule (xor des bits de la donnee recue)
		variable parRe : std_logic := '0';
	  --cpt : compte le nombre de F.M de tmpclk pour savoir quand la reception est terminee (cpt = 11)
		variable cpt : natural := 0;

  begin
    if reset='0' then
		--au reset, tmpdata vide
		--			   aucune erreur (Ferr = OErr = 0)
		--				DRdy = parRe = cpt = 0)
		--				etat d'attente : controle
      tmpdata :=  (others => '0');
		FerrRe <= '0';
		OErrRe <= '0';
		DRdyRe := '0';
		etat := controle;
		parRe := '0';
		cpt := 0;
    else
		 if(rising_edge(enable)) then
			case etat is
				when controle =>
					--on recoit et on stocke la donnee de tmprxd dans tmpdata sur F.M de tmpclk
				   FerrRe <= '0';
					OErrRe <= '0';
					if (tmpclk = '1') then
						cpt := cpt + 1;
						--1 < cpt < 10 : tmprxd contient la donnee, on la stocke dans tmpdata et on calcule la parite par xor
						if (cpt > 1 and cpt < 10) then
							tmpdata(8 - cpt + 1) := tmprxd;
							ParRe := ParRe xor tmprxd;
						--cpt = 10 : reception du bit de parite
						elsif (cpt = 10) then
							par := tmprxd;
						--cpt = 11 : reception et controle du bit de stop, controle de la parite
						elsif (cpt = 11) then
							if (par /= parRe or tmprxd = '0') then
								FerrRe <= '1';
							else
								--si tout va bien, on met la donnee en sortie et on le signale (DRdy = 1)
								DRdyRe := '1';
								data <= tmpdata;
								--==> envoi
								etat := envoi;
							end if;
							cpt := 0;
							parRe := '0';							
						end if;
					end if;
				when envoi =>
					--on controle si il n'y a pas eu d'erreur de communication avec le CPU
					DRdyRe := '0';
					if (rd = '0') then
						OErrRe <= '1';
					end if;
					--==> controle
					etat := controle;
			end case;
		 end if;
	 end if;
	 --on assigne les vrais valeurs aux signaux
	 DRdy <= DRdyRe;
  end process;
  
  Ferr <= FerrRe;
  OErr <= OErrRe;
  
end RxUnit_archi;
