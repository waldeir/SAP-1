 library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity regout is
    
  port (
  -- Read from W bus 
  bar_lo   : in std_logic;
  -- Clock
  clk      : in std_logic;
  -- The input port from W bus 
  w_bus    : in std_logic_vector(7 downto 0);
  -- The output of the sap
  sap_out  : out std_logic_vector(7 downto 0)
    );
end entity regout;

architecture behav of regout is

signal tempReg : std_logic_vector (7 downto 0) := (others => '0');

begin
  regisOut: process(clk)
  begin
    if (rising_edge(clk)) then
      if (bar_lo = '0') then
        tempReg <= w_bus;
      end if;
    end if;
  end process regisOut;

  sap_out <= tempReg;

end behav;
 
