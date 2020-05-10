 library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity regout is
    
  port (
  -- Read from W bus 
  bar_Lo   : in std_logic;
  -- Clock
  CLK      : in std_logic;
  -- The input port from W bus 
  W_bus    : in std_logic_vector(7 downto 0);
  -- The output of the sap
  sap_out  : out std_logic_vector(7 downto 0)
    );
end entity regout;

architecture behav of regout is

begin
  regisOut: process(CLK,bar_Lo, W_bus)
  begin
  -- if (rising_edge(CLK)) then
    if (bar_Lo = '0') then
      sap_out <= W_bus;
    end if;
  -- end if;
  end process regisOut;

end behav;
 
