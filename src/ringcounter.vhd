library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity ring_counter is
    Port ( bar_clk : in  std_logic;
           bar_clr : in  std_logic;
           t_state : out  std_logic_vector(5 downto 0));
end ring_counter;
 
architecture Behavioral of Ring_counter is
signal t_tmp: std_logic_vector(5 downto 0):= "000001";
begin
process(bar_clk,bar_clr)
begin
if bar_clr = '0' then
    t_tmp <= "000001";
elsif falling_edge(bar_clk) then
    t_tmp(1) <= t_tmp(0);
    t_tmp(2) <= t_tmp(1);
    t_tmp(3) <= t_tmp(2);
    t_tmp(4) <= t_tmp(3);
    t_tmp(5) <= t_tmp(4);
    t_tmp(0) <= t_tmp(5);
end if;
end process;
t_state <= t_tmp;
end Behavioral;
