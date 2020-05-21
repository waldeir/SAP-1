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
  in_clk     : in std_logic;
  -- start/clear 1/0
  s5      : in std_logic;
  sap_out : out std_logic_vector(7 downto 0)
	);
end component sap1;


-- Intermediate signals

signal in_clk : std_logic;
signal sap_out : std_logic_vector (7 downto 0);
signal s5 : std_logic := '0';

constant clk_period : time := 10 ns;

signal stop : std_logic := '0';


begin
-- Component instantiation

 sap10: sap1 port map (
  in_clk  => in_clk,   
  -- start/clear 1/0
  s5      => s5,
  sap_out => sap_out 
	);

clk_process : process
begin
	in_clk <= '0';
	wait for clk_period/2;
	in_clk <= '1';
	wait for clk_period/2;
	if ( stop = '1') then
		report "Finished";
		wait;		
	end if;
end process clk_process;

process 
begin

  s5 <= '0';
  wait for 10 ns;

  s5 <= '1';
	wait for 500 ns;
  stop <= '1';
	wait;

end process;


end behav;

