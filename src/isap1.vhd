library IEEE;
use IEEE.std_logic_1164.ALL;

-- Switches s1 to s6 are described in 
-- Malvino - Digital Computer Electronics - 3rd Edition
entity isap1 is
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
end entity isap1;

architecture structure of isap1 is

------------------------------
--  Components declaration  --
------------------------------
  
 component pc is
	port (
	-- The output port to W bus
	w_bus   : out std_logic_vector ( 3 downto 0);
	-- Outputs the counter value to w_bus
	ep      : in  std_logic;
	-- Increment program counter by 1
	cp      : in std_logic;
	bar_clk : in std_logic;
	-- Reset counter to 0000 asynchronously
	bar_clr     : in std_logic
	);
end component pc;
 
component regb is
    
  port (
  -- Read from W bus 
  bar_lb   : in std_logic;
  -- Clock
  clk      : in std_logic;
  -- The input port from W bus 
  w_bus    : in std_logic_vector(7 downto 0);
  -- The output to the addsub
  out_to_addsub  : out std_logic_vector(7 downto 0)
    
  );
end component regb;


component regout is
    
  port (
  -- Read from W bus 
  bar_lo   : in std_logic;
  -- Clock
  clk      : in std_logic;
  -- The input port from W bus 
  w_bus    : in std_logic_vector(7 downto 0);
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
end component ir;


component ctrlseq is
  port (
  -- Control words
  microinstruction : out std_logic_vector(11 downto 0);
  -- LDA, ADD, SUB, HLT or OUT in binary form
  macroinstruction : in std_logic_vector(3 downto 0);
  -- clk
  clk              : in std_logic;
  -- clr
  bar_clr          : in std_logic;
  -- Halt
  bar_hlt          : out std_logic
  );
end component ctrlseq;



component accumulator is
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
end component accumulator;


component addsub is
	port (
	-- Input from accumulator register
	in_from_acc : in std_logic_vector ( 7 downto 0);
	-- Input from B register
	in_from_bReg     : in std_logic_vector (7 downto 0);
	-- The output port to the W bus
	w_bus       : out std_logic_vector(7 downto 0);
	-- When high, performs subtraction and sends the results to
	-- W bus
	su          : in std_logic;
	-- When high, adds accumulator and B register contents and
	-- sends the results to w_bus
	eu          : in std_logic
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

-- cp     : microinstruction(11)    -
-- ep     : microinstruction(10)    -
-- bar_lm : microinstruction(9)     -
-- bar_ce : microinstruction(8)     -
-- bar_li : microinstruction(7)     -
-- bar_ei : microinstruction(6)     -
-- bar_la : microinstruction(5)     -
-- ea     : microinstruction(4)     -
-- su     : microinstruction(3)     -
-- eu     : microinstruction(2)     -
-- bar_lb : microinstruction(1)     -
-- bar_lo : microinstruction(0)     -



signal w_bus      : std_logic_vector(7 downto 0);
signal bar_clk    : std_logic;
signal clk        : std_logic;
signal clr        : std_logic;
signal bar_clr    : std_logic;
-- TODO: rever o HLT barrado
signal bar_hlt    : std_logic;

signal ram_mar_bus : std_logic_vector (3 downto 0);
signal acc_addsub_bus : std_logic_vector ( 7 downto 0);
signal regb_addsub_bus   : std_logic_vector ( 7 downto 0);
signal ir_ctrlseq_bus : std_logic_vector ( 3 downto 0);

begin

-- s5 start/clear  1/0
clr <= '1' when s5 = '0' else  '0';
bar_clr <= not clr;
-- s6 single step
-- s7 manual/auto  1/0

clk <= ((s6 and s7) or (in_clk and not s7)) and bar_hlt;
bar_clk <= not clk;


------------------------------
-- Components instantiation --
------------------------------


accumulator0: accumulator port map (
                 bar_la        => microinstruction(5),
                 ea            => microinstruction(4),
                 clk           => clk,
                 w_bus         => w_bus,
                 out_to_addsub => acc_addsub_bus
                 );

addsub0: addsub port map (
                 su           => microinstruction(3),
                 eu           => microinstruction(2),
                 w_bus        => w_bus,
                 in_from_bReg => regb_addsub_bus,
                 in_from_acc  => acc_addsub_bus
                 );

pc0: pc port map (
                 cp      => microinstruction(11),
                 ep      => microinstruction(10),
                 w_bus   => w_bus(3 downto 0),
                 bar_clk => bar_clk,
                 bar_clr => bar_clr
                 );

regb0 : regb port map (
                 bar_lb        => microinstruction(1),
                 w_bus         => w_bus,
                 clk           => clk,
                 out_to_addsub => regb_addsub_bus
                 );

regout0 : regout port map (
                 bar_lo  => microinstruction(0),
                 w_bus   => w_bus,
                 clk     => clk,
                 sap_out => sap_out
                 );

imar0 : imar port map(
                 bar_lm     => microinstruction(9),
                 w_bus      => w_bus(3 downto 0),
                 clk        => clk,
                 out_to_ram => ram_mar_bus,
                 s1         => s1,
                 s2         => s2
                 );


iram0 : iram port map (
                 bar_ce      => microinstruction(8), 
                 w_bus       => w_bus,
                 in_from_mar => ram_mar_bus,
                 s3          => s3,
                 s4          => s4
                 );


ir0 : ir port map (
                 bar_li        => microinstruction(7),
                 bar_ei        => microinstruction(6),
                 w_bus         => w_bus,
                 clk           => clk,
                 clr           => clr,
                 out_to_conseq => ir_ctrlseq_bus
                 );              

ctrlseq0 : ctrlseq port map(
                 microinstruction => microinstruction,
                 macroinstruction => ir_ctrlseq_bus,
                 clk              => clk,
                 bar_clr          => bar_clr,
                 bar_hlt          => bar_hlt
                 );


end structure;




