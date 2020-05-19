library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- Memory Address Register

entity imar is
  port (
  -- Enable read from w_bus
  bar_lm     : in std_logic;
  -- Clock
  clk        : in std_logic; 
  -- Input from W bus
  w_bus      : in std_logic_vector(3 downto 0);
  -- Output to ram
  out_to_ram : out std_logic_vector(3 downto 0);
  -- Input memory address from switch
  s1      : in std_logic_vector (3 downto 0);
  -- run/prog  1/0
  s2      : in std_logic
  );
end entity imar;

architecture behav of imar is

signal tempReg : std_logic_vector (3 downto 0) := (others => '0');

begin
  memReg:process(clk)
  begin
    if (rising_edge(clk)) then
      if (bar_lm = '0') then
        tempReg <= w_bus;
      end if;
    end if; 
  end process memReg;

  out_to_ram <= tempReg when s2 = '1' else s1;

end behav;

