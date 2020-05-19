library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity iram is
  port (
    -- Enable read from MAR 
    bar_ce      : in std_logic;
    -- Input from MAR
    in_from_mar : in std_logic_vector(3 downto 0 );
    -- Output to W bus
    w_bus       : out std_logic_vector(7 downto 0 );
    -- Input data
    s3      : in std_logic_vector (7 downto 0);
    -- read/write 1/0
    s4      : in std_logic
  );
end entity iram;


architecture behav of iram is

type RAM_type is array (0 to 15 ) of std_logic_vector(7 downto 0);

signal ram_data : RAM_type;


signal tempReg : std_logic_vector (7 downto 0) := (others => '0');

begin
  retrContent: process(bar_ce)
  begin
      if (bar_ce = '0') then
        tempReg <= ram_data(to_integer(unsigned(in_from_mar)));
      else
        tempReg <= "ZZZZZZZZ";
      end if;
  end process retrContent;
  
write_memory: process (s4)
begin
  if falling_edge(s4) then 
    ram_data(to_integer(unsigned(in_from_mar))) <= s3 ;
  end if;
end process;

w_bus <= tempReg;

end behav;
