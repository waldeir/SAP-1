library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
-- Controller Sequencer

entity ctrlseq is
  port (
  -- Control words
  microinstruction : out std_logic_vector(11 downto 0);
  -- LDA, ADD, SUB, HLT or OUT in binary form
  macroinstruction : in std_logic_vector(3 downto 0);
  -- clk
  clk              : in std_logic;
  -- CLR
  bar_clr          : in std_logic;
  -- Halt
  HLT              : out std_logic
  );
end entity ctrlseq;



architecture behav of ctrlseq is
-- Using microprogramming to store microinstructions, i.e. using a rom to
-- retrieve control words from. This is the same as the Table 10.6 of "Malvino -
-- Digital Computer Electronics - 3rd Edition" shows.

type ROM_type is array (0 to 15 ) of std_logic_vector(11 downto 0);
constant rom_data: ROM_type:=(
   ----------------Fetch Cycle-----------------------
   -- T1 - crtlWord: 5E3H - Active Bits: Ep, bar_Lm 
   "010111100011",  
   -- T2 - crtlWord: BE3H - Active Bits: Cp 
   "101111100011", 
   -- T3 - crtlWord: 263H - Active Bits: bar_CE, bar_Li 
   "001001100011", 

   ---------------Execution Cycle--------------------
   -- LDA 
   -- T4 - crtlWord: 1A3H - Active Bits: bar_Lm, bar_Ei
   "000110100011",
   -- T5 - crtlWord: 2C3H - Active Bits: bar_CE, bar_La
   "001011000011",
   -- T6 - crtlWord: 3E3H - Active Bits: None
   "001111100011",

   -- ADD 
   -- T4 - crtlWord: 1A3H - Active Bits: bar_Lm, bar_Ei
   "000110100011",
   -- T5 - crtlWord: 2E1H - Active Bits: bar_CE, bar_Lb
   "001011100001",
   -- T6 - crtlWord: 3C7H - Active Bits: bar_La, Eu
   "001111000111",

   -- SUB 
   -- T4 - crtlWord: 1A3H - Active Bits: bar_Lm, bar_Ei
   "000110100011",
   -- T5 - crtlWord: 2E1H - Active Bits: bar_CE, bar_Lb
   "001011100001",
   -- T6 - crtlWord: 3CFH - Active Bits: bar_La, Su, Eu
   "001111001111",

   -- OUT 
   -- T4 - crtlWord: 3F2H - Active Bits: Ea, bar_Lo
   "001111110010",
   -- T5 - crtlWord: 3E3H - Active Bits: None
   "001111100011",
   -- T6 - crtlWord: 3E3H - Active Bits: None
   "001111100011",   

   -- Last address not used
   "000000000000"
  );
  
signal t_state: std_logic_vector(5 downto 0);
signal rom_addr : integer range 0 to 15 := 0 ;
 

  component Ring_counter is
    Port ( bar_clk : in  std_logic;
           bar_clr : in  std_logic;
           t_state : out  std_logic_vector(5 downto 0));
  end component;



begin
-- Ring counter instantiation
ring_counter0: ring_counter port map (bar_clk => clk,
                           bar_clr => bar_clr,
                           t_state   => t_state);

process (t_state)
begin
    case (t_state) is
      ----------------Fetch Cycle-----------------------
      -- T1
      when "000001" => rom_addr <= 0;   -- 0H

      ---------------Execution Cycle--------------------
      -- T4
      when "001000" =>
        case (macroinstruction) is
          -- LDA
          when "0000" => rom_addr <= 3; -- 3H 
          -- ADD
          when "0001" => rom_addr <= 6; -- 6H 
          -- SUB
          when "0010" => rom_addr <= 9; -- 9H 
          -- OUT
          when "1110" => rom_addr <= 12; -- CH
          -- HLT
          when others => HLT <= '1';
        end case;
      
      when others   => 
        rom_addr <= rom_addr + 1;
    end case;

end process;

microinstruction <= rom_data(rom_addr);

end behav;
 




