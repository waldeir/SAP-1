library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- Memory Address Register

entity mar is
  port (
  -- Enable read from W_bus
  bar_Lm     : in std_logic;
  -- Clock
  CLK        : in std_logic; 
  -- Input from W bus
  W_bus      : in std_logic_vector(3 downto 0);
  -- Output to ram
  out_to_ram : out std_logic_vector(3 downto 0)
  );
end entity mar;

architecture behav of mar is

  

begin
  memReg:process(CLK,W_bus)
  begin
    --if (rising_edge(CLK)) then
    if (CLK = '1') then
      if (bar_Lm = '0') then
        out_to_ram <= W_bus;
      end if;
    end if; 
  end process memReg;

end behav;

