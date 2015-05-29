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
    txd : out std_logic
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

component echoUnit is
    port (
      clk, reset : in  std_logic;
		IntR       : in std_logic;
      IntT       : in std_logic;
		data_in    : in  std_logic_vector(7 downto 0);
      cs, rd, wr : out  std_logic;
      addr       : out  std_logic_vector(1 downto 0);
      data_out   : out std_logic_vector(7 downto 0));
end component;

signal nclk : std_logic;
signal IntR, IntT : std_logic;
signal cs, rd, wr : std_logic;
signal addr : std_logic_vector (1 downto 0);
signal d1, d2 : std_logic_vector (7 downto 0);

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
  UARTunit0 : UARTunit
  port map (nclk, not btn(0), cs, rd, wr, RxD, addr, d2, TxD, IntR, IntT, d1);  
  echoUnit0 : echoUnit
  port map (nclk, not btn(0), IntR, IntT, d1, cs, rd, wr, addr, d2);
  
end synthesis;
