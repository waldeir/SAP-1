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
    w_bus  : inout std_logic_vector (7 downto 0); 
    -- The output to the addsub
    out_to_addsub: out std_logic_vector (7 downto 0)
    );
  end entity accumulator;

  architecture behav of accumulator is

  signal accRegister: std_logic_vector ( 7 downto 0) := (others => '0');	

  begin
    acc: process(clk)
      begin 
        if rising_edge(clk) then
          if bar_la = '0' then
            accRegister <= w_bus;
          end if;
        end if;
      end process acc;
    
    out_to_addsub <= accRegister;
    w_bus <= accRegister when ea = '1' else (others => 'Z');

  end behav;

