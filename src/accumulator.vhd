  library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;


  entity accumulator is
    port (
    -- When LOW read from W bus
    bar_la : in std_logic;
    -- When HIGH write to the W bus
    ea     : in std_logic;
    -- Clock signal
    clk    : in std_logic;
    -- The input and output port to W bus	
    w_bus  : inout std_logic_vector (7 downto 0); -- := "ZZZZZZZZ";
    -- The output to the addsub
    out_to_addsub: out std_logic_vector (7 downto 0)
    );
  end entity accumulator;

  architecture behav of accumulator is

  signal accRegister: std_logic_vector ( 7 downto 0);	

  begin
    acc: process(clk, ea, bar_la)
      begin 
        --if (rising_edge(clk)) then
        if (clk = '1') then
          if (ea = '1' and bar_la = '1') then
            w_bus <= accRegister;
          elsif (ea = '0' and bar_la = '0') then
            accRegister <= w_bus;
            out_to_addsub <= w_bus;
          elsif (ea = '0' and bar_la = '1') then
            w_bus <= "ZZZZZZZZ";
          else
            -- Never use ea = '0' and bar_la = '1'
            w_bus <= "XXXXXXXX";
          end if;
        end if;
      end process acc;

  end behav;

