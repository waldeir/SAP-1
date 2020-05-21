library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.math_real.uniform;

-- sap1 testbench
entity isap1_tb is
end entity isap1_tb;


architecture behav of isap1_tb is

-- Component declaration

component isap1 is
	port (
  -- Clock
  in_clk  : in std_logic;
  -- Output of the results
  sap_out : out std_logic_vector(7 downto 0);
  -- Input memory address from switch
  s1      : in std_logic_vector (3 downto 0);
  -- run/prog 1/0
  s2      : in std_logic;
  -- Input data
  s3      : in std_logic_vector (7 downto 0);
  -- read/write 1/0
  s4      : in std_logic;
  -- start/clear  1/0
  s5      : in std_logic;
  -- single step
  s6      : in std_logic;
  -- manual/auto  1/0
  s7      : in std_logic
	);
end component isap1;

-- Signals

signal sap_out : std_logic_vector (7 downto 0);
signal in_clk : std_logic;
signal s1 : std_logic_vector (3 downto 0);
signal s2, s4, s5, s6, s7 : std_logic;
signal s3 : std_logic_vector (7 downto 0);


constant clk_period : time := 10 ns;

signal stop : std_logic := '0';


type RAM_type is array (0 to 15 ) of std_logic_vector(7 downto 0);
type address_type is array (0 to 15 ) of std_logic_vector(3 downto 0);

signal RAM_prog1 : ram_type := (
    -- Example program
   "00001001",  -- LDA 9H
   "00011010",  -- ADD AH
   "00011011",  -- ADD BH
   "00101100",  -- SUB CH
   "11100000",  -- OUT   
   "11110000",  -- HLT   
   "00011010",
   "00101110",
   "00111100",
   "00011010",
   "00101110",
   "00111100",
   "00111111",
   "00111110",
   "00111110",   
   "11110000" 
  );                          

signal RAM_prog2 : ram_type := (
    -- Example program
   "00001001",  -- LDA 9H
   "11100000",  -- OUT 
   "11110000",  -- HLT 
   "00101100",   
   "11100000",      
   "11110000",      
   "00011010",
   "00101110",
   "00111100",
   "00011010",
   "00101110",
   "00111100",
   "00111111",
   "00111110",
   "00111110",   
   "00000000"    
);                          

signal RAM_prog3 : ram_type := (
    -- Example program
   "00001001",  -- LDA 9H
   "00101010",  -- SUB AH
   "00011011",  -- ADD BH
   "00101100",  -- SUB CH
   "00011111",  -- ADD FH
   "11100000",  -- OUT 
   "11110000",  -- HLT 
   "00101110",
   "00111100",
   "10011110",
   "00111110",
   "00001100",
   "00010001",
   "00101100",
   "00110110",   
   "00000001"    
);                          

signal RAM_adresses : address_type := (
   "0000",  
   "0001",  
   "0010",  
   "0011",  
   "0100",  
   "0101",  
   "0110",
   "0111",
   "1000",
   "1001",
   "1010",
   "1011",
   "1100",
   "1101",
   "1110",   
   "1111" 
);

 



begin
-- Component instantiation
sap: isap1 port map(
      in_clk     => in_clk,
      sap_out => sap_out,
      -- Input memory address from switch
      s1 => s1,
      -- run/prog 1/0
      s2 => s2,
      -- Input data
      s3 => s3,
      -- read/write 1/0
      s4 => s4,
      -- start/clear  1/0
      s5 => s5,
      -- single step
      s6 => s6,
      -- manual/auto  1/0
      s7 => s7
      );

clk_process : process
begin
  in_clk <= '1';
	wait for clk_period/2;
	in_clk <= '0';
	wait for clk_period/2;
  if stop = '1' then
    report "Finished";
    wait;
  end if;
end process clk_process;

process 

variable seed1, seed2: positive := 1;
variable randomFactor: real;

begin

-- single step
s6 <= '0';
-- read/write 1/0
s4 <= '1';
-- manual/auto 1/0
s7 <= '0';






-------------------------------
--  Record program 1 to RAM  --
-------------------------------

-- run/prog 1/0
s2 <= '0';
-- start/clear 1/0
s5 <= '0';	


report "Recording program 1";
for i in 0 to 15 loop
  -- Input memory address
  s1 <= RAM_adresses(i);
  -- Input data
  s3 <= RAM_prog1(i);
  wait for 1 ns;
  
  -- Pulse to write

  -- read/write 1/0
  s4 <= '0';
  wait for 1 ns;
  -- read/write 1/0
  s4 <= '1';
  wait for 1 ns;

end loop;


-------------------------
--  Starting program 1 --
-------------------------

report "Starting program 1";

 -- run/prog 1/0
s2 <= '1';
wait for 10 ns;

-- start/clear 1/0
s5 <= '1';	

wait for 500 ns;

if sap_out = "01000101" then
  report "Test passed!";
else
  report "Test failed!";
end if;


-------------------------------
--  Record program 2 to RAM  --
-------------------------------

-- run/prog 1/0
s2 <= '0';
-- start/clear 1/0
s5 <= '0';	


report "Recording program 2";
for i in 0 to 15 loop
  -- Input memory address
  s1 <= RAM_adresses(i);
  -- Input data
  s3 <= RAM_prog2(i);
  wait for 1 ns;
  
  -- Pulse to write

  -- read/write 1/0
  s4 <= '0';
  wait for 1 ns;
  -- read/write 1/0
  s4 <= '1';
  wait for 1 ns;

end loop;


-------------------------
--  Starting program 2 --
-------------------------

report "Starting program 2";

 -- run/prog 1/0
s2 <= '1';
wait for 10 ns;

-- start/clear 1/0
s5 <= '1';	

wait for 500 ns;

if sap_out = "00011010" then
  report "Test passed!";
else
  report "Test failed";
end if;


-------------------------------
--  Record program 3 to RAM  --
-------------------------------

-- run/prog 1/0
s2 <= '0';
-- start/clear 1/0
s5 <= '0';	


report "Recording program 3";
for i in 0 to 15 loop
  -- Input memory address
  s1 <= RAM_adresses(i);
  -- Input data
  s3 <= RAM_prog3(i);
  wait for 1 ns;
  
  -- Pulse to write

  -- read/write 1/0
  s4 <= '0';
  wait for 1 ns;
  -- read/write 1/0
  s4 <= '1';
  wait for 1 ns;

end loop;


-------------------------
--  Starting program 3 --
-------------------------

report "Starting program 3";

 -- run/prog 1/0
s2 <= '1';
wait for 10 ns;

-- start/clear 1/0
s5 <= '1';	

wait for 500 ns;

if sap_out = "01011100" then
  report "Test passed!";
else
  report "Test failed";
end if;





-------------------------------
--  Record program 1 to RAM  --
-------------------------------

-- run/prog 1/0
s2 <= '0';
-- start/clear 1/0
s5 <= '0';	


report "Recording program 1";
for i in 0 to 15 loop
  -- Input memory address
  s1 <= RAM_adresses(i);
  -- Input data
  s3 <= RAM_prog1(i);
  wait for 1 ns;
  
  -- Pulse to write

  -- read/write 1/0
  s4 <= '0';
  wait for 1 ns;
  -- read/write 1/0
  s4 <= '1';
  wait for 1 ns;

end loop;


----------------------------------------
--  Starting program 1 in manual mode --
----------------------------------------

report "Starting program 1";


-- manual/auto 1/0
s7 <= '1';

 -- run/prog 1/0
s2 <= '1';
wait for 10 ns;

-- start/clear 1/0
s5 <= '1';	


-- Clock controled by s6 switch with random steps

for i  in 0 to 35 loop
  s6 <= '1';
  uniform (seed1, seed2, randomFactor);
  wait for 5 ns + 10 ns * randomFactor;
  s6 <= '0';
  uniform (seed1, seed2, randomFactor);
  wait for 5 ns + 10 ns * randomFactor; 
end loop;



if sap_out = "01000101" then
  report "Test passed!";
else
  report "Test failed!";
end if;
 
stop <= '1';
wait;
 

end process;


end behav;

