library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity pc is
	port (
	-- The output port to W bus
	W_bus   : out std_logic_vector ( 3 downto 0) := "ZZZZ";
	-- Outputs the counter value to W_bus
	Ep      : in  std_logic;
	-- Increment program counter by 1
	Cp      : in std_logic;
	bar_CLK : in std_logic;
	-- Reset counter to 0000 asynchronously
	bar_CLR     : in std_logic
	);
end entity pc;



architecture behav of pc is

    signal counter: unsigned(3 downto 0) := "0000"; -- Internal signal to store counter
begin
    pc_Operation: process(bar_CLK, Ep, Cp)
    begin
  --if (falling_edge(bar_CLK)) then
  if (bar_CLK = '0') then
	    if (Ep = '1' and Cp = '0') then
	        W_bus <= std_logic_vector(counter);
	    elsif (Ep = '0' and Cp = '0') then
          W_bus <= "ZZZZ";
      elsif (Ep = '1' and Cp = '1') then
	    -- Undefined W_bus if Ep = '1' and Cp = '1'
	        W_bus <= "XXXX";	    
	    end if;
	end if;


    end process pc_Operation;

IncrCounter: process (bar_CLK, bar_CLR)
begin
  if (falling_edge(bar_CLK)) then
    if (Ep = '0' and Cp = '1')  then
      counter <= counter + 1;
      W_bus <= "ZZZZ"; -- TODO: Is this line really necessary?
    end if;

    -- Reset the counter
    if (bar_CLR = '0') then
      counter <= "0000";
    end if;
  end if;
  
end process;
		    

end behav;

