library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity Ring_counter is
    Port ( bar_clk : in  std_logic;
           bar_clr : in  std_logic;
           Q : out  std_logic_vector(5 downto 0));
end Ring_counter;
 
architecture Behavioral of Ring_counter is
signal q_tmp: std_logic_vector(5 downto 0):= "000001";
begin
process(bar_clk,bar_clr)
begin
if bar_clr = '0' then
    q_tmp <= "000001";
elsif falling_edge(bar_clk) then
    q_tmp(1) <= q_tmp(0);
    q_tmp(2) <= q_tmp(1);
    q_tmp(3) <= q_tmp(2);
    q_tmp(4) <= q_tmp(3);
    q_tmp(5) <= q_tmp(4);
    q_tmp(0) <= q_tmp(5);
end if;
end process;
Q <= q_tmp;
end Behavioral;
