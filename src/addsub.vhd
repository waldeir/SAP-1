library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity addsub is
	port (
	-- Input from accumulator register
	in_from_acc : in std_logic_vector ( 7 downto 0);
	-- Input from B register
	in_from_bReg     : in std_logic_vector (7 downto 0);
	-- The output port to the W bus
	w_bus       : out std_logic_vector(7 downto 0);
	-- When high, performs subtraction and sends the results to
	-- W bus
	su          : in std_logic ;
	-- When high, adds accumulator and B register contents and
	-- sends the results to w_bus
	eu          : in  std_logic
	);
end entity addsub;

architecture behav of addsub is

begin
--    addsubCalc: process(eu, su)
--    begin
--        if (eu='1' and su = '0') then
--	    w_bus <= std_logic_vector(unsigned(in_from_acc) + unsigned(in_from_bReg));
--        elsif (eu = '1' and su ='1' ) then
--	    w_bus <= std_logic_vector(unsigned(in_from_acc) - unsigned(in_from_bReg));
--        else
--	    w_bus <= "ZZZZZZZZ";
--        end if;
--    end process addsubCalc;

    w_bus <= std_logic_vector(unsigned(in_from_acc) + unsigned(in_from_bReg))
             when eu='1' and su = '0'
             else 
             std_logic_vector(unsigned(in_from_acc) - unsigned(in_from_bReg))
             when eu = '1' and su ='1' else (others => 'Z');
end behav;

