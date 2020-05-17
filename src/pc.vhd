library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity pc is
	port (
	-- The output port to W bus
	w_bus   : out std_logic_vector ( 3 downto 0); --:= "ZZZZ";
	-- Outputs the counter value to w_bus
	ep      : in  std_logic;
	-- Increment program counter by 1
	cp      : in std_logic;
	bar_clk : in std_logic;
	-- Reset counter to 0000 asynchronously
	bar_clr     : in std_logic
	);
end entity pc;



architecture behav of pc is

    signal counter: unsigned(3 downto 0)  := "0000"; -- Internal signal to store counter
begin
    pc_Operation: process(bar_clk, ep, cp)
    begin
  --if (falling_edge(bar_clk)) then
  if (bar_clk = '0') then
      if (ep = '1' and cp = '0') then
          w_bus <= std_logic_vector(counter);
      elsif (ep = '1' and cp = '1') then
          w_bus <= "ZZZZ";	    
      end if;
  else
      if (ep = '0' and cp = '0') then
          w_bus <= "ZZZZ";
      end if;
  end if;


    end process pc_Operation;

IncrCounter: process (bar_clk, bar_clr)
begin
  if (falling_edge(bar_clk)) then
    if (ep = '0' and cp = '1')  then
      counter <= counter + 1;
      w_bus <= "ZZZZ"; -- TODO: Is this line really necessary?
    end if;

    -- Reset the counter
    if (bar_clr = '0') then
      counter <= "0000";
      w_bus <= "ZZZZ";
    end if;
  end if;
  
end process;
		    

end behav;

