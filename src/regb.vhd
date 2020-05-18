library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity regb is
    
  port (
  -- Read from W bus 
  bar_lb   : in std_logic;
  -- Clock
  clk      : in std_logic;
  -- The input port from W bus 
  w_bus    : in std_logic_vector(7 downto 0);
  -- The output to the addsub
  out_to_addsub  : out std_logic_vector(7 downto 0)
    
  );
end entity regb;

architecture behav of regb is

signal tempReg : std_logic_vector (7 downto 0) := (others => '0');

begin
  regisB: process(clk)
  begin
    if (rising_edge(clk)) then
      if (bar_lb = '0') then
        tempReg <= w_bus;
      end if;
    end if;
  end process regisB;

  out_to_addsub <= tempReg;

end behav;

