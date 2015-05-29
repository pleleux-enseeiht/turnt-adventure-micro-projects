library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys2 is
  port (
    -- les 8 switchs
    swt : in std_logic_vector (7 downto 0) ;
    -- les anodes pour sélectionner l'afficheur 7 segments
    an : out std_logic_vector (3 downto 0) ;
    -- afficheur 7 segments
    ssg : out std_logic_vector (7 downto 0) ;
    -- horloge
    mclk : in std_logic ;
    -- les 4 boutons
    btn : in std_logic_vector (3 downto 0) ;
    -- les 8 leds
    led : out std_logic_vector (7 downto 0) ;
    -- ligne RS232
    rxd : in std_logic ;
    txd : out std_logic ;
	 rxd2 : in std_logic ;
	 txd2 : out std_logic
  );
end Nexys2;

architecture synthesis of Nexys2 is

component diviseurClk is
  port (
    clk, reset : in  std_logic;
    nclk       : out std_logic);
end component;

component UARTunit is
  port (
    clk, reset : in  std_logic;
    cs, rd, wr : in  std_logic;
    RxD        : in  std_logic;
	 addr       : in  std_logic_vector(1 downto 0);
    data_in    : in  std_logic_vector(7 downto 0);
    TxD        : out std_logic;
    IntR       : out std_logic;        
    IntT       : out std_logic;         
    data_out   : out std_logic_vector(7 downto 0));
end component;

component duplexUnit is
    port (
      clk, reset           : in  std_logic;
      cs1, rd1, wr1        : out  std_logic;
      cs2, rd2, wr2        : out  std_logic;
      IntR1, intT1         : in std_logic;
      IntR2, intT2         : in std_logic;
      addr1, addr2         : out  std_logic_vector(1 downto 0);
      data_in1				   : in  std_logic_vector(7 downto 0);
		data_out1				: out std_logic_vector(7 downto 0);
      data_in2				   : in  std_logic_vector(7 downto 0);
      data_out2 				: out std_logic_vector(7 downto 0));
end component;

signal nclk : std_logic;
signal IntR1, IntT1, intR2, intT2 : std_logic;
signal cs1, rd1, wr1, cs2, rd2, wr2 : std_logic;
signal addr1, addr2 : std_logic_vector (1 downto 0);
signal data_in1, data_in2 : std_logic_vector (7 downto 0);
signal data_out1, data_out2 : std_logic_vector (7 downto 0);

begin

  -- valeurs des sorties (à modifier)

  -- convention afficheur 7 segments 0 => allumé, 1 => éteint
  ssg <= (others => '1');
  -- aucun afficheur sélectionné
  an(3 downto 0) <= "1111";
  -- 8 leds éteintes
  led(7 downto 0) <= (others => '0');

  diviseurClk0 : diviseurClk
  port map (mclk, not btn(0), nclk);
  UARTunit1 : UARTunit
  port map (nclk, not btn(0), cs1, rd1, wr1, RxD, addr1, data_out1, TxD, IntR1, IntT1, data_in1);
  UARTunit2 : UARTunit
  port map (nclk, not btn(0), cs2, rd2, wr2, RxD2, addr2, data_out2, TxD2, IntR2, IntT2, data_in2);  
  duplexUnit0 : duplexUnit
  port map (nclk, not btn(0), cs1, rd1, wr1, cs2, rd2, wr2, IntR1, IntT1, IntR2, IntT2, addr1, addr2, data_in1, data_out1, data_in2, data_out2);

end synthesis;
