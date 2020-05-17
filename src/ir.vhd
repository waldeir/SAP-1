library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ir is
  port (
    -- Enable read from W bus
    bar_li  : in std_logic;
    -- Enable write to W bus and controller sequencer
    bar_ei   : in std_logic;
    -- Clock
    clk     : in std_logic;
    -- Clear instruction register
    clr     : in std_logic;
    -- Send to controller sequencer an instruction code
    out_to_conseq: out std_logic_vector(3 downto 0);
    -- Send and receive data from W bus
    w_bus  : inout std_logic_vector(7 downto 0) -- :="ZZZZZZZZ" 
  );
end entity ir;


architecture behav of ir is
-- TODO usar apenas um registrador para tudo
signal WbusBuffer : std_logic_vector(7 downto 0);

begin
  irProcess: process(clk,clr,w_bus)
  begin
    -- if (rising_edge(clk)) then
    if (clk = '1') then
      if (bar_li = '0' and bar_ei = '1' ) then
        WbusBuffer     <= w_bus;
        out_to_conseq  <= w_bus(7 downto 4);
      elsif (bar_li = '1' and bar_ei = '0') then
        w_bus(7 downto 4) <= "ZZZZ";
        w_bus(3 downto 0) <= WbusBuffer(3 downto 0);
        out_to_conseq  <= WbusBuffer(7 downto 4);
      elsif (bar_li = '1' and bar_ei = '1') then
        w_bus <= "ZZZZZZZZ";
      else
        -- Never enable bar_li and bar_ei at the same time
        w_bus <= "XXXXXXXX";
      end if;
    else
      w_bus <= "ZZZZZZZZ";      
    end if;

    if (clr = '1') then
     WbusBuffer <="00000000";
     w_bus <="ZZZZZZZZ";
    end if;

  end process irProcess;

end behav;

