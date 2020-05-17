library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity pc is
	port (
	-- The output port to W bus
	w_bus   : out std_logic_vector ( 3 downto 0);
	-- Outputs the counter value to w_bus
	ep      : in  std_logic;
	-- Increment program counter by 1
	cp      : in std_logic;
	-- Clock signal
	bar_clk : in std_logic;
	-- Reset counter to 0000 asynchronously
	bar_clr     : in std_logic
	);
end entity pc;




architecture structure of pc is

component jk_ff is
	port(
  j        : in std_logic;
  k        : in std_logic;
  bar_clk  : in std_logic;
  bar_clr  : in std_logic;
  q        : inout std_logic;
  bar_q    : inout std_logic
      );
end component jk_ff;

signal counter: std_logic_vector(3 downto 0); -- Internal signal to store counter value
signal ff_clk: std_logic_vector(4 downto 0); -- Clock input for each flipflop, position 4 is not used
 

begin
    
ff_clk(0) <= bar_clk;

counter_ffs: for h in 0 to 3 generate 
		jk_instance: jk_ff port map(
			j => cp,
			k => cp,
			bar_clk => ff_clk(h),
			bar_clr => bar_clr,
			q => counter(h)
      --bar_q is not used, see fig. 10-12 from Malvino - Digital Computer Electronics 3rd - Edition
  		);
      ff_clk(h+1) <= counter(h);
 end generate counter_ffs;

w_bus <= counter when (ep = '1') else (others => 'Z');
    

end structure;

