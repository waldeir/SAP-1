library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- sap1 testbench
entity sap1_tb is
end entity sap1_tb;


architecture behav of sap1_tb is

-- Component declaration

component sap1 is
port (
  bar_hlt     : out std_logic;
  clk     : in std_logic;
  bar_clk : in std_logic;
  clr     : in std_logic;
  bar_clr : in std_logic;
  sap_out : out std_logic_vector(7 downto 0)
);
end component sap1;

-- Intermediate signals

signal clk : std_logic;
signal bar_clk : std_logic;
signal bar_hlt : std_logic;
signal sap_out : std_logic_vector (7 downto 0);
signal clr : std_logic := '0';
signal bar_clr : std_logic := '1';

constant clk_period : time := 10 ns;

signal stop : std_logic := '0';

signal delayEnable: std_logic := '1';

begin
-- Component instantiation
sap: sap1 port map(
      clk     => clk,
      bar_clk => bar_clk,
      bar_hlt     => bar_hlt,
      sap_out => sap_out,
      clr     => clr,
      bar_clr => bar_clr
      );

clk_process : process
variable simTime: time := 0 ns;
begin
  bar_clk <= '1';
	clk <= '0';
	wait for clk_period/2;
  bar_clk <= '0';
	clk <= '1';
	wait for clk_period/2;
  simTime := simTime + clk_period;
	if (bar_hlt = '0') then
		stop <= '1';
		report "Finished";
		wait;		
	end if;
end process clk_process;

process 
begin
	if delayEnable = '1' then
		clr <= '1';	
		bar_clr <= '0';
		delayEnable <= '0';
		report "There";
		wait for 30 ns;
	end if; 

	clr <= '0';
	bar_clr <= '1';
	wait for 1 ns;

	if stop = '1' then
		wait;
	end if;
	-- wait;

end process;


end behav;

