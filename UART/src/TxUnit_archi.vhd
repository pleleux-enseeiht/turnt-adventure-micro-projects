library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--entity TxUnit is
--  port (
--    clk, reset : in std_logic;
--    enable : in std_logic;
--    ld : in std_logic;
--    txd : out std_logic;
--    regE : out std_logic;
--    bufE : out std_logic;
--    data : in std_logic_vector(7 downto 0));
--end TxUnit;

architecture TxUnit_archi of TxUnit is
  
begin  

  process (clk, reset)
		
	  --t_etat : type de l etat courant de l'emetteur :
			--attente : l'emetteur attend que le buffer soit plein ==> tampon
			--tampon : l'emetteur place la donnee du buffer dans le registre ==> depart
			--depart : envoi le bit de start sur F.M de enable via txd ==> emission
			--emission : envoi bit a bit de la donnee sur F.M de enable via txd ==> parite
			--parite : envoi du bit de parite sur F.M de enable via txd ==> stop
			--stop : envoi du bit de stop sur F.M de enable via txd ==> attente (bufE = regE = 1)
			--																		  ==> tampon (bufE = 0, reg = 1)
			--																		  ==> depart (regE = 0)
			--a tout moment le buffer peut etre rempli s'il est vide et qu'il y a une donnee a transmettre
			--le registre peut etre rempli si le buffer est plein lors de parite et stop
		type t_etat is (attente, tampon, depart, emission, parite, stop);
	  --etat : au depart l'emetteur est en attente
		variable etat : t_etat := attente;
	  --reg : "registre" de l'emetteur, contient la donnee enregistree pour envoi
		variable reg : std_logic_vector(7 downto 0);
	  --buffer : "buffer" de l'emetteur, prend la donnee a envoyer des qu'elle est en entree
		variable buf : std_logic_vector(7 downto 0);
	  --bufEm : suit les variations de bufE : booleen "buffer vide"
		variable bufEm : std_logic := '1';
	  --regEm : suit les variations de regE : booleen "registre vide"
		variable regEm : std_logic := '1';
	  --txdEm : suit les variations de txd : signal d'emission en sortie
		variable txdEm : std_logic := '1';
	  --par : parite de la donnee
		variable par : std_logic := '0';
	  --cpt : compteur remis a 7 lorsque le dernier bit de donnee est transmis
		variable cpt : natural := 7;

  begin
    if reset='0' then
		--au reset, buffer/registre vide
		--				txd au repos et compteur de bit transmis a 7
		--				etat d'attente
      regEm := '1';
      bufEm := '1';
		txdEm := '1';
		etat := attente;
		cpt := 7;
		par := '0';
    elsif(rising_edge(clk)) then
	 
		--a chaque F.M de clk, le buffer peut etre remplie
	   if (ld = '1' and bufEm = '1') then
			buf := data;
			bufEm := '0';
		end if;
		
		case etat is
			when attente =>
				--on attend que buf soit plein (bufEm=0)
				if ((ld = '1' and bufEm = '0')) then
						--==> tampon
						etat := tampon;
				end if;
			when tampon =>
				--on place la donnee de buf dans reg 
					reg := buf;
					bufEm := '1';
					regEm := '0';
					--==> depart
					etat := depart;
			when depart =>
				--on envoie le bit de start (0) sur F.M de enable 
				if (enable = '1') then
					txdEm := '0';
					par := '0';
					--==> emission
					etat := emission;			
				end if;
			when emission =>
			--on envoie bit a bit la donnee (dans reg) sur F.M de enable 
				if (enable = '1') then
					txdEm := reg(cpt);
					--calcul du bit de parite : xor des bits de la donnee
					par := par xor reg(cpt);
					cpt := (cpt - 1) mod 8;			
					if (cpt = 7) then
						--==> parite
						etat := parite;
						regEm := '1';
					end if;
				end if;
			when parite =>
			--on envoie le bit de parite calcule sur F.M de enable 
			
				if (regEm = '1' and bufEm = '0') then
					--donne envoyee, on peut remplir reg
					reg := buf;
					bufEm := '1';
					regEm := '0';						
				end if;
				
				if (enable = '1') then
					txdEm := par;
					--==> stop	
					etat := stop;
				end if;
			when stop =>
			--on envoie le bit de stop (1) sur F.M de enable via txd
				if (regEm = '1' and bufEm = '0') then
					--donne envoyee, on peut remplir reg
					reg := buf;
					bufEm := '1';
					regEm := '0';	
				end if;
				
				if (enable = '1') then
					txdEm := '1';
					--==> attente (bufE = regE = 1)
					if (regEm = '0') then
							etat := tampon;
					--==> tampon (bufE = 0, reg = 1)
					elsif (bufEm = '0') then
							etat := depart;
					--==> depart (regE = 0)
					else
							etat := attente;
					end if;
				end if;
		end case;
	 end if;
	 --on assigne les variables temporaires aux vrais signaux
    regE <= regEm;
    bufE <= bufEm;
	 txd <= txdEm;
  end process;

end TxUnit_archi;
