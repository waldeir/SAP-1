library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ir is
  port (
    -- Enable read from W bus
    bar_Li  : in std_logic;
    -- Enable write to W bus and controller sequencer
    bar_Ei   : in std_logic;
    -- Clock
    CLK     : in std_logic;
    -- Clear instruction register
    CLR     : in std_logic;
    -- Send to controller sequencer an instruction code
    out_to_conseq: out std_logic_vector(3 downto 0);
    -- Send and receive data from W bus
    W_bus  : inout std_logic_vector(7 downto 0):="ZZZZZZZZ" 
  );
end entity ir;


architecture behav of ir is
-- TODO usar apenas um registrador para tudo
signal WbusBuffer : std_logic_vector(7 downto 0);

begin
  irProcess: process(CLK,CLR,W_bus)
  begin
    -- if (rising_edge(CLK)) then
    if (clk = '1') then
      if (bar_Li = '0' and bar_Ei = '1' ) then
        WbusBuffer     <= W_bus;
        out_to_conseq  <= W_bus(7 downto 4);
      elsif (bar_Li = '1' and bar_Ei = '0') then
        W_bus(7 downto 4) <= "ZZZZ";
        W_bus(3 downto 0) <= WbusBuffer(3 downto 0);
        out_to_conseq  <= WbusBuffer(7 downto 4);
      elsif (bar_Li = '1' and bar_Ei = '1') then
        W_bus <= "ZZZZZZZZ";
      else
        -- Never enable bar_Li and bar_Ei at the same time
        W_bus <= "XXXXXXXX";
      end if;
    else
      W_bus <= "ZZZZZZZZ";      
    end if;

    if (CLR = '1') then
     WbusBuffer <="00000000";
     W_bus <="ZZZZZZZZ";
    end if;

  end process irProcess;

end behav;

