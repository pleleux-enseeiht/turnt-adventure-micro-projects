library IEEE;
use IEEE.std_logic_1164.all;

entity duplexUnit is
    port (
      clk, reset    : in  std_logic;
      cs1, rd1, wr1 : out  std_logic;
      cs2, rd2, wr2 : out  std_logic;
      IntR1         : in std_logic;
      IntT1         : in std_logic;
      IntR2         : in std_logic;
		IntT2         : in std_logic;
      addr1         : out  std_logic_vector(1 downto 0);
		addr2         : out  std_logic_vector(1 downto 0);
      data_in1      : in  std_logic_vector(7 downto 0);
      data_out1     : out std_logic_vector(7 downto 0);
      data_in2      : in  std_logic_vector(7 downto 0);
      data_out2     : out std_logic_vector(7 downto 0));
end duplexUnit;

architecture duplexUnit_arch of duplexUnit is

  type t_etat is (test_emission, attente, reception1, reception2,
                  attente_emission12, pret_a_emettre12, emission12,
						attente_emission21, pret_a_emettre21, emission21);
  signal etat : t_etat := attente;
  signal donnee : std_logic_vector(7 downto 0) := (others => '0');
	
begin

  process (clk, reset)
  begin
    if reset='0' then
      etat <= test_emission;
    elsif clk='1' and clk'event then
      case etat is
        -- cet etat n'est destine qu a tester l'emission
        -- il suffit de modifier l'etat dans la partie reset
        when test_emission =>
          cs2 <= '1';
          rd2 <= '1';
          wr2 <= '1';
          data_out2 <= (others => '0');
          addr2 <= (others => '0');
          -- donnee = caractere A (0x41) (poids faibles d'abord)
          donnee <= "10000010";
          etat <= pret_a_emettre12;
                        
        when attente => 
          cs1 <= '1';
          rd1 <= '1';
          wr1 <= '1';
          cs2 <= '1';
          rd2 <= '1';
          wr2 <= '1';
          data_out1 <= (others => '0');
			 data_out2 <= (others => '0');
          addr1 <= (others => '0');
          addr2 <= (others => '0');
          if (IntR1='0') then
            -- IntR1=0 -> une nouvelle donnee est recue sur 1
            -- on la lit
            etat <= reception1;
            cs1 <= '0';
            rd1 <= '0';
            wr1 <= '1';
          elsif (IntR2='0') then
            -- IntR2=0 -> une nouvelle donnee est recue sur 2
            -- on la lit
            etat <= reception2;
            cs2 <= '0';
            rd2 <= '0';
            wr2 <= '1';
          end if;

        when reception1 => 
          donnee <= data_in1;
          if (IntR1='1') then
            -- la donnee est lue
            addr1 <= "00";
            etat <= attente_emission12;
          end if;
			 
        when reception2 => 
          donnee <= data_in2;
          if (IntR2='1') then
            -- la donnee est lue
            addr1 <= "00";
            etat <= attente_emission21;
          end if;
                      
        when attente_emission12 =>
          cs1 <= '1';
          rd1 <= '1';
          wr1 <= '1';
          etat <= pret_a_emettre12;

        when attente_emission21 =>
          cs2 <= '1';
          rd2 <= '1';
          wr2 <= '1';
          etat <= pret_a_emettre21;

        when pret_a_emettre12 =>
          -- pour savoir si l unite d emission est prete
          -- on teste le registre de controle
          cs2 <= '0';
          rd2 <= '0';
          wr2 <= '1';
          addr2 <= "01";
          -- le bit 3 correspond a TxRdy=1
          if data_in2(3)='1' then
            cs2 <= '1';
            rd2 <= '1';
            wr2 <= '1';
            -- on positionne la donnee pour l'UART
            data_out2 <= donnee;
            etat <= emission12;
          end if;
			 
        when pret_a_emettre21 =>
          -- pour savoir si l unite d emission est prete
          -- on teste le registre de controle
          cs1 <= '0';
          rd1 <= '0';
          wr1 <= '1';
          addr1 <= "01";
          -- le bit 3 correspond a TxRdy=1
          if data_in1(3)='1' then
            cs1 <= '1';
            rd1 <= '1';
            wr1 <= '1';
            -- on positionne la donnee pour l'UART
            data_out1 <= donnee;
            etat <= emission21;
          end if;
                        
        when emission12 =>
          -- on ecrit la donnee dans le buffer d emission
          cs2 <= '0';
          rd2 <= '1';
          wr2 <= '0';
          donnee <= (others => '0');
          etat <= attente;
			 
        when emission21 =>
          -- on ecrit la donnee dans le buffer d emission
          cs1 <= '0';
          rd1 <= '1';
          wr1 <= '0';
          donnee <= (others => '0');
          etat <= attente;
                   
      end case;
    end if;
  end process;
	
end duplexUnit_arch;
