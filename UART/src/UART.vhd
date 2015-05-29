library IEEE;
use IEEE.std_logic_1164.all;

entity UARTunit is
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
end UARTunit;
architecture UARTunit_arch of UARTunit is

component ctrlUnit is  
  port (
    clk, reset       : in  std_logic;
    rd, wr           : in  std_logic;
    DRdy, FErr, OErr : in  std_logic;
    BufE, RegE       : in  std_logic;
    IntR             : out std_logic;
    IntT             : out std_logic;
    ctrlReg          : out std_logic_vector(7 downto 0));
end component;

component clkUnit is  
 port (
   clk, reset : in  std_logic;
   enableTX   : out std_logic;
   enableRX   : out std_logic);
end component;

component TxUnit is
  port (
    clk, reset : in std_logic;
    enable     : in std_logic;
    ld         : in std_logic;
    txd        : out std_logic;
    regE       : out std_logic;
    bufE       : out std_logic;
	 data       : in std_logic_vector(7 downto 0));
end component;

component RxUnit is
  port (
    clk, reset       : in  std_logic;
    enable           : in  std_logic;
    rd               : in  std_logic;
    rxd              : in  std_logic;
    data             : out std_logic_vector(7 downto 0);
    Ferr, OErr, DRdy : out std_logic);
end component;

  signal lecture, ecriture : std_logic;
  signal donnees_recues : std_logic_vector(7 downto 0);
  signal registre_controle : std_logic_vector(7 downto 0);
  signal regE, bufE : std_logic;
  signal DRdy, FErr, OErr : std_logic;
  signal enableTX, enableRX : std_logic;

  begin  -- UARTunit_arch

    lecture <= '1' when cs = '0' and rd = '0' else '0';
    ecriture <= '1' when cs = '0' and wr = '0' else '0';
    data_out <= donnees_recues when lecture = '1' and addr = "00"
                else registre_controle when lecture = '1' and addr = "01"
                else "00000000";
	 ctrUnit0 : ctrlUnit
    port map (clk, reset, rd, wr, DRdy, FErr, OErr, BufE, RegE, IntR, IntT, registre_controle);
	 clkUnit0 : clkUnit
	 port map (clk, reset, enableTX, enableRX);
	 TxUnit0 : TxUnit
	 port map (clk, reset, enableTX, ecriture, txd, regE, bufE, data_in);
	 RxUnit0 : RxUnit
	 port map (clk, reset, enableRX, lecture, rxd, donnees_recues, Ferr, OErr, DRdy);

  end UARTunit_arch;
