library IEEE;
use IEEE.std_logic_1164.all;

architecture clkUnit_archi of clkUnit is
  
begin

--si reset a 1, horloge de réception synchronisee avec clk
--sinon horloges au repos
enableRX <= clk when reset = '1' else '0';

  process (clk, reset)

	--compteur de front-montant de clk : 0-15
    variable cpt : integer range 0 to 15 := 0;

  begin
    if reset='0' then
		--au reset, horloge de reception au repos
      enableTX <= '0';
    elsif (rising_edge(clk)) then
	   --front montant de l'horloge de réception tous les 16 fronts montant de clk
      if cpt = 15 then
			enableTX <= '1';
      else
			enableTX <= '0';
      end if;
      cpt:=(cpt+1) mod 16;
    end if;
    
  end process;

end clkUnit_archi;
