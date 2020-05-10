library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity regb is
    
  port (
  -- Read from W bus 
  bar_Lb   : in std_logic;
  -- Clock
  CLK      : in std_logic;
  -- The input port from W bus 
  W_bus    : in std_logic_vector(7 downto 0);
  -- The output to the addsub
  out_to_addsub  : out std_logic_vector(7 downto 0)
    
  );
end entity regb;

architecture behav of regb is

begin
  regisB: process(CLK, W_bus)
  begin
  if (rising_edge(CLK)) then
    if (bar_Lb = '0') then
      out_to_addsub <= W_bus;
    end if;
  end if;
  end process regisB;

end behav;

