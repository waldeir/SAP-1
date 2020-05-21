library IEEE;
use IEEE.std_logic_1164.ALL;

-- Switches s1 to s6 are described in 
-- Malvino - Digital Computer Electronics - 3rd Edition
entity isap1 is
	port (
  -- Clock
  in_CLK  : in std_logic;
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
end entity isap1;

architecture structure of isap1 is

------------------------------
--  Components declaration  --
------------------------------
  
 component pc is
	port (
	-- The output port to W bus
	W_bus   : out std_logic_vector ( 3 downto 0);
	-- Outputs the counter value to W_bus
	Ep      : in  std_logic;
	-- Increment program counter by 1
	Cp      : in std_logic;
	bar_CLK : in std_logic;
	-- Reset counter to 0000 asynchronously
	bar_CLR     : in std_logic
	);
end component pc;
 
component regb is
    
  port (
  -- Read from W bus 
  bar_Lb   : in std_logic;
  -- Clock
  CLK      : in std_logic;
  -- The input port from W bus 
  W_bus    : in std_logic_vector(7 downto 0);
  -- The output to the addsub
  out_to_addsub  : out std_logic_vector(7 downto 0)
    
  );
end component regb;


component regout is
    
  port (
  -- Read from W bus 
  bar_Lo   : in std_logic;
  -- Clock
  CLK      : in std_logic;
  -- The input port from W bus 
  W_bus    : in std_logic_vector(7 downto 0);
  -- The output of the sap
  sap_out  : out std_logic_vector(7 downto 0)
  );
end component regout;



component iram is
  port (
    -- Enable read from MAR 
    bar_ce      : in std_logic;
    -- Input from MAR
    in_from_mar : in std_logic_vector(3 downto 0 );
    -- Output to W bus
    w_bus       : out std_logic_vector(7 downto 0 );
    -- Input data
    s3      : in std_logic_vector (7 downto 0);
    -- read/write 1/0
    s4      : in std_logic
  );
end component iram;


component ir is
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
    W_bus  : inout std_logic_vector(7 downto 0)
  );
end component ir;


component ctrlseq is
  port (
  -- Control words
  microinstruction : out std_logic_vector(11 downto 0);
  -- LDA, ADD, SUB, HLT or OUT in binary form
  macroinstruction : in std_logic_vector(3 downto 0);
  -- CLK
  CLK              : in std_logic;
  -- CLR
  bar_CLR          : in std_logic;
  -- Halt
  bar_HLT          : out std_logic
  );
end component ctrlseq;



component accumulator is
	port (
	-- When LOW read from W bus
	bar_La : in std_logic;
	-- When HIGH write to the W bus
	Ea     : in std_logic;
	-- Clock signal
	CLK    : in std_logic;
  -- The input and output port to W bus	
	W_bus  : inout std_logic_vector (7 downto 0);
  -- The output to the addsub
  out_to_addsub: out std_logic_vector (7 downto 0)
	);
end component accumulator;


component addsub is
	port (
	-- Input from accumulator register
	in_from_acc : in std_logic_vector ( 7 downto 0);
	-- Input from B register
	in_from_bReg     : in std_logic_vector (7 downto 0);
	-- The output port to the W bus
	W_bus       : out std_logic_vector(7 downto 0);
	-- When high, performs subtraction and sends the results to
	-- W bus
	Su          : in std_logic;
	-- When high, adds accumulator and B register contents and
	-- sends the results to W_bus
	Eu          : in std_logic
	);
end component addsub;


component imar is
  port (
  -- Enable read from w_bus
  bar_lm     : in std_logic;
  -- Clock
  clk        : in std_logic; 
  -- Input from W bus
  w_bus      : in std_logic_vector(3 downto 0);
  -- Output to ram
  out_to_ram : out std_logic_vector(3 downto 0);
  -- Input memory address from switch
  s1      : in std_logic_vector (3 downto 0);
  -- run/prog  1/0
  s2      : in std_logic
  );
end component imar;

----------------------------------------
--  Intermediate signals declaration  --
----------------------------------------
signal microinstruction : std_logic_vector ( 11 downto 0);

-- Cp     : microinstruction(11)    -
-- Ep     : microinstruction(10)    -
-- bar_Lm : microinstruction(9)     -
-- bar_CE : microinstruction(8)     -
-- bar_Li : microinstruction(7)     -
-- bar_Ei : microinstruction(6)     -
-- bar_La : microinstruction(5)     -
-- Ea     : microinstruction(4)     -
-- Su     : microinstruction(3)     -
-- Eu     : microinstruction(2)     -
-- bar_Lb : microinstruction(1)     -
-- bar_Lo : microinstruction(0)     -



signal W_bus      : std_logic_vector(7 downto 0);
signal bar_CLK    : std_logic;
signal CLK        : std_logic;
signal CLR        : std_logic;
signal bar_CLR    : std_logic;
-- TODO: rever o HLT barrado
signal bar_HLT    : std_logic;

signal ram_mar_bus : std_logic_vector (3 downto 0);
signal acc_addsub_bus : std_logic_vector ( 7 downto 0);
signal regb_addsub_bus   : std_logic_vector ( 7 downto 0);
signal ir_ctrlseq_bus : std_logic_vector ( 3 downto 0);

begin

-- s5 start/clear  1/0
CLR <= '1' when s5 = '0' else  '0';
bar_CLR <= not CLR;
-- s6 single step
-- s7 manual/auto  1/0

CLK <= ((s6 and s7) or (in_CLK and not s7)) and bar_hlt;
bar_CLK <= not CLK;


------------------------------
-- Components instantiation --
------------------------------


accumulator0: accumulator port map (
                 bar_La        => microinstruction(5),
                 Ea            => microinstruction(4),
                 CLK           => CLK,
                 W_bus         => W_bus,
                 out_to_addsub => acc_addsub_bus
                 );

addsub0: addsub port map (
                 Su           => microinstruction(3),
                 Eu           => microinstruction(2),
                 W_bus        => W_bus,
                 in_from_bReg => regb_addsub_bus,
                 in_from_acc  => acc_addsub_bus
                 );

pc0: pc port map (
                 Cp      => microinstruction(11),
                 Ep      => microinstruction(10),
                 W_bus   => W_bus(3 downto 0),
                 bar_CLK => bar_CLK,
                 bar_CLR => bar_CLR
                 );

regb0 : regb port map (
                 bar_Lb        => microinstruction(1),
                 W_bus         => W_bus,
                 CLK           => CLK,
                 out_to_addsub => regb_addsub_bus
                 );

regout0 : regout port map (
                 bar_Lo  => microinstruction(0),
                 W_bus   => W_bus,
                 CLK     => CLK,
                 sap_out => sap_out
                 );

imar0 : imar port map(
                 bar_Lm     => microinstruction(9),
                 W_bus      => W_bus(3 downto 0),
                 clk        => clk,
                 out_to_ram => ram_mar_bus,
                 s1         => s1,
                 s2         => s2
                 );


iram0 : iram port map (
                 bar_CE      => microinstruction(8), 
                 W_bus       => W_bus,
                 in_from_mar => ram_mar_bus,
                 s3          => s3,
                 s4          => s4
                 );


ir0 : ir port map (
                 bar_Li        => microinstruction(7),
                 bar_Ei        => microinstruction(6),
                 W_bus         => W_bus,
                 CLK           => CLK,
                 CLR           => CLR,
                 out_to_conseq => ir_ctrlseq_bus
                 );              

ctrlseq0 : ctrlseq port map(
                 microinstruction => microinstruction,
                 macroinstruction => ir_ctrlseq_bus,
                 CLK              => CLK,
                 bar_CLR          => bar_CLR,
                 bar_HLT          => bar_HLT
                 );


end structure;




