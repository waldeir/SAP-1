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
  bar_HLT     : out std_logic;
  CLK     : in std_logic;
  bar_CLK : in std_logic;
  CLR     : in std_logic;
  bar_CLR : in std_logic;
  sap_out : out std_logic_vector(7 downto 0)
);
end component sap1;

-- Intermediate signals

signal CLK : std_logic;
signal bar_CLK : std_logic;
signal bar_HLT : std_logic;
signal sap_out : std_logic_vector (7 downto 0);
signal CLR : std_logic := '0';
signal bar_CLR : std_logic := '1';

constant CLK_period : time := 10 ns;

signal stop : std_logic := '0';

signal delayEnable: std_logic := '1';

begin
-- Component instantiation
sap: sap1 port map(
      CLK     => CLK,
      bar_CLK => bar_CLK,
      bar_HLT     => bar_HLT,
      sap_out => sap_out,
      CLR     => CLR,
      bar_CLR => bar_CLR
      );

clk_process : process
variable simTime: time := 0 ns;
begin
  bar_CLK <= '1';
	CLK <= '0';
	wait for CLK_period/2;
  bar_CLK <= '0';
	CLK <= '1';
	wait for CLK_period/2;
  simTime := simTime + CLK_period;
	if (bar_HLT = '0') then
		stop <= '1';
		report "Finished";
		wait;		
	end if;
end process clk_process;

process 
begin
	if delayEnable = '1' then
		CLR <= '1';	
		bar_CLR <= '0';
		delayEnable <= '0';
		report "There";
		wait for 30 ns;
	end if; 

	CLR <= '0';
	bar_CLR <= '1';
	wait for 1 ns;

	if stop = '1' then
		wait;
	end if;
	-- wait;

end process;


end behav;

