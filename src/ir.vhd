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
    w_bus  : inout std_logic_vector(7 downto 0)
  );
end entity ir;


architecture behav of ir is

signal irReg: std_logic_vector(7 downto 0) := (others => '0');

begin
  irProcess: process(clk,clr)
  begin
    if (clr = '1') then
     irReg <= (others => '0');

    elsif (rising_edge(clk)) then
      if (bar_li = '0') then
        irReg <= w_bus;
      end if;
    end if;

  end process irProcess;

  out_to_conseq  <= irReg(7 downto 4);
  w_bus(3 downto 0) <= irReg(3 downto 0) when bar_ei = '0' else (others => 'Z');

end behav;

