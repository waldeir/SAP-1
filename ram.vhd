library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity ram is
  port (
    -- Enable read from MAR 
    bar_CE      : in std_logic;
    -- Input from MAR
    in_from_mar : in std_logic_vector(3 downto 0 );
    -- Output to W bus
    W_bus       : out std_logic_vector(7 downto 0 )
  );
end entity ram;


architecture behav of ram is

type RAM_type is array (0 to 15 ) of std_logic_vector(7 downto 0);
constant ram_data: ram_type:=(
    -- Example program
   "00001001",  -- LDA 9H
   "00011010",  -- ADD AH
   "00011011",  -- ADD BH
   "00101100",  -- SUB CH
   "11100000",  -- OUT   
   "11110000",  -- HLT   
   "00011010",
   "00101110",
   "00111100",
   "00011010",
   "00101110",
   "00111100",
   "00111111",
   "00111110",
   "00111110",   
   "00000000" 
  ); 


begin
  retrContent: process(bar_CE)
  begin
    --if (rising_edge(CLK)) then
      if (bar_CE = '0') then
        W_bus <= ram_data(to_integer(unsigned(in_from_mar)));
      else
        W_bus <= "ZZZZZZZZ";
      end if;
    --end if;
  end process retrContent;

end behav;

--    -- Example program
--   "00001001",  -- LDA 9H
--   "00011010",  -- ADD AH
--   "00011011",  -- ADD BH
--   "00101100",  -- SUB CH
--   "11100000",  -- OUT   
--   "11110000",  -- HLT   
--   "00011010",
--   "00101110",
--   "00111100",
--   "00011010",
--   "00101110",
--   "00111100",
--   "00111111",
--   "00111110",
--   "00111110",   
--   "00000000" 

--    -- Example program
--   "00001001",  -- LDA 9H
--   "11100000",  -- OUT 
--   "11110000",  -- HLT 
--   "00101100",  -- 
--   "11100000",  --    
--   "11110000",  --    
--   "00011010",
--   "00101110",
--   "00111100",
--   "00011010",
--   "00101110",
--   "00111100",
--   "00111111",
--   "00111110",
--   "00111110",   
--   "00000000"    
