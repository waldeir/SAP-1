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
	W_bus       : out std_logic_vector(7 downto 0);
	-- When high, performs subtraction and sends the results to
	-- W bus
	Su          : in std_logic ;
	-- When high, adds accumulator and B register contents and
	-- sends the results to W_bus
	Eu          : in  std_logic
	);
end entity addsub;

architecture behav of addsub is

begin
    addsubCalc: process(Eu, Su)
    begin
        if (Eu='1' and Su = '0') then
	    W_bus <= std_logic_vector(unsigned(in_from_acc) + unsigned(in_from_bReg));
        elsif (Eu = '1' and Su ='1' ) then
	    W_bus <= std_logic_vector(unsigned(in_from_acc) - unsigned(in_from_bReg));
        elsif (Eu = '0' and Su = '0') then
	    W_bus <= "ZZZZZZZZ";
        else
	    -- Never use Su = 1 and Eu = 0
	    W_bus <= "XXXXXXXX";
        end if;
     end process addsubCalc;
end behav;

