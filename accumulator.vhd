  library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;


  entity accumulator is
    port (
    -- When LOW read from W bus
    bar_La : in std_logic;
    -- When HIGH write to the W bus
    Ea     : in std_logic;
    -- Clock signal
    CLK    : in std_logic;
    -- The input and output port to W bus	
    W_bus  : inout std_logic_vector (7 downto 0):= "ZZZZZZZZ";
    -- The output to the addsub
    out_to_addsub: out std_logic_vector (7 downto 0)
    );
  end entity accumulator;

  architecture behav of accumulator is

  signal accRegister: std_logic_vector ( 7 downto 0);	

  begin
    acc: process(CLK, Ea, bar_La, W_bus)
      begin 
        --if (rising_edge(CLK)) then
        if (CLK = '1') then
          if (Ea = '1' and bar_La = '1') then
            W_bus <= accRegister;
          elsif (Ea = '0' and bar_La = '0') then
            accRegister <= W_bus;
            out_to_addsub <= W_bus;
          elsif (Ea = '0' and bar_La = '1') then
            W_bus <= "ZZZZZZZZ";
          else
            -- Never use Ea = '0' and bar_La = '1'
            W_bus <= "XXXXXXXX";
          end if;
        end if;
      end process acc;

  end behav;

