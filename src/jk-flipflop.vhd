library ieee;
use ieee.std_logic_1164.all;

entity jk_ff is
	port(
  j        : in std_logic;
  k        : in std_logic;
  bar_clk  : in std_logic;
  bar_clr  : in std_logic;
  q        : inout std_logic;
  bar_q    : inout std_logic
      );
end entity jk_ff;


architecture behavioral of jk_ff is
begin
  process(bar_clk,bar_clr)
  begin

    if (bar_clr = '0') then

        q <= '0';
        bar_q <= '1'; 

    elsif (falling_edge(bar_clk)) then

        if(j = '0' and k = '1') then
            q <= '0';
            bar_q <= '1';
        elsif (j='1' and k='0') then
            q <= '1';
            bar_q <= '0';
        elsif (j='0' and k='0') then
            q <= q;
            bar_q <= not q;
        else
            q <= not q;
            bar_q <= q;
        end if;

    end if;

  end process;
end behavioral;
