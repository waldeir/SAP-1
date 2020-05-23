library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity debounce is
  generic(
    -- How many clock ticks to wait before transfer in_switch to out_switch
    debounce_ticks: integer);
  port (
    -- Clock
    clk        : in  std_logic;
    -- Input from the switch
    in_switch  : in  std_logic;
    -- Debounced signal
    out_switch : out std_logic
    );
end entity debounce;
 
architecture behavioral of debounce is
  -- Size of the counter 
  signal tick_count : integer range 0 to debounce_ticks := 0;
  -- switch initialization
  signal switch_state : std_logic := '0';
 
begin
 
process (clk) is
begin
  if rising_edge(clk) then
    if (in_switch /= switch_state and tick_count < debounce_ticks) then
      tick_count <= tick_count + 1;
    elsif tick_count = debounce_ticks then
      switch_state <= in_switch;
      tick_count <= 0;
    else
      tick_count <= 0;
    end if;
  end if;
end process;
 
  -- Filtered signal
  out_switch <= switch_state;
 
end architecture behavioral;
