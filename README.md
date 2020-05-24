Language: [Portuguese](https://github.com/waldeir/SAP-1/blob/master/README.pt.md)

# Simple As Possible computer - 1  (SAP-1)

* [Introduction](#introduction)
* [The computer](#the-computer)
   * [Debounce circuit](#debounce-circuit)
* [SAP-1 with no Input switches](#sap-1-with-no-input-switches)
* [Simulation with GHDL](#simulation-with-ghdl)


# Introduction

This is a VHDL implementation of the well known computer SAP-1, described in
the book [Malvino - Digital Computer Electronics - 3rd Edition][book]. The **Figure
1** shows the block diagram of the computational unit, where the active states of the signals 
where chosen to match the ones described in the book. Therefore the same
waveforms presented in the SAP-1 chapter can be visualized in the simulation.


![](images/isap1_block_diagram.png)

**Figure 1**: Block diagram of SAP-1 with data entries. 
Beside each signal, there is how its name is referred into the VHDL code.

# The computer

As shown in **Figure 2**, the computer has eight inputs: the switches `s1` to
`s7`, described in **Table 1**, and the clock input `in_clk`. The program is loaded into
the 8 vs 16 bits RAM memory before the computer run, using the switches `s1`, `s3`
and `s4`. While `s5` is set to 0 (clear) and `s2` is set to 0 (prog), data and
its destination address are fed respectively to `s3` and `s1` and a pulse in
`s4` is performed to write the information. The operation is repeated until all
the program is recorded, then `s2` is set to 0 (run), connecting the *Memory Address Register* (MAR) to the
W bus.

If `s7` is 0 (auto), the program starts when `s5` is 1 (start) and the computer
will run until it finds the instruction HLT. Otherwise, if `s7` is 1 (manual),
the clock must be manually provided by pressing `s6` repeatedly.


![](images/isap1_top_level.png)

**Figure 2**: Inputs and outputs of this SAP-1 implementation.

**Table 1**: SAP-1 Switches

| Switch        | Function      | 
|:-------------:|---------------| 
| `s1`          | Memory Address| 
| `s2`          | '1' (run): Connects the MAR input to the W bus - '0' (program): Connects the MAR input to `s1`|
| `s3`          | Input of data | 
| `s4`          | '1' (read): Memory is ready be read by the SAP-1 - '0' (write): write to the RAM the content of `s3` in the address specified by `s1` | 
| `s5`          | '1' (start): Puts `clr` and `bar_clr` signals to the inactive states, starting the computer - 0 (clear): Resets the Program Counter to 0, the Ring Counter to the T1 state and Instruction Register to '00000000' | 
| `s6`          | Single step | 
| `s7`          | '1' (manual): Clock is provided by successively pushing `s6` - '0' (auto): clock is read from `in_clk`| 


## Debounce circuit.

A debounce circuit was implemented in the file `debounce.vhd` and instantiated
to the switches `s2`, `s4`, `s5`, `s6`, `s7`. To filter the ripple of a
commutation it monitors the state of a switch and if it changes the circuit
stores the value and waits for three clock cycles then read the input again, if
the value remains the same then the new input is passed on. 

In order to reduce simulation time the amount of clock cycles the debounce
circuit  waits is 3, which for the current simulation frequency (100 MHz) it
leads a delay of 30 ns. However, in a realistic scenario this delay should be
around 10 ms, which can be achieved by changing the constant

```vhdl
constant debounce_ticks: integer := 3;
```
in the `isap1.vhd` file, accordingly to the selected clock.

## SAP-1 with no Input switches

This implementation is mainly intended to provide a way to see the internal
signals of SAP-1 during an execution of a program. Therefore a version with no
inputs is also provided, where the simulation is performed without the
recording step. The program is written direct by the user to the RAM file
`ram.vhd` and the start of the execution is controlled with the `s5` switch.

The **Figure 3** shows the block diagram with the *Memory Address Register*
(`imar.vhd`) and RAM (`iram.vhd`) replaced by their version with no input,
`mar.vhd` and `ram.vhd`, respectively. The **Figure 4** presents the resulting
simplified version of the SAP-1.



![](images/block_diagram_sap1.png)

**Figure 3**: Structural model of SAP-1 without the input switches.

![](images/sap1_top_level.png)

**Figure 4**: SAP-1 With just the start/clear switch.

# Simulation with GHDL

The simulation is performed with the free software [GHDL][ghdl], which uses the
\*.vhd files to generate executables that can be run by your PC and provide
waveform outputs.  If you are in Linux, make sure to have *git*, *make* and
[GHDL][ghdl] installed and run:

```bash
git clone https://github.com/waldeir/SAP-1
cd SAP-1/
make
```

That will produce the executables `isap1_tb` and `sap1_tb`. The first is the
simulation for the SAP-1 in **Figure 2**, the latter is for the version with
no input in **Figure 4**. You can obtain the waveforms vs time graphs of either
simulation by running in linux command line: 

```bash
./sap_tb --vcd=waveform.vcd
```
or
```
./isap_tb --vcd=waveform.vcd
```

The procedure generates the waveform file `waveform.vcd`, that can be opened in
a program like *gtkwave*, as in **Figure 5**.

![](images/isap1_waveforms.png)

**Figure 5**: Waveforms of a SAP-1 simulation.

Custom programs can be written to the testbench file `isap1_tb.vhd` where they
will be loaded to the SAP-1's RAM and then executed.

[gtkwave]:http://gtkwave.sourceforge.net/ "Wave viewer"

[book]:https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945 "https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945"

[ghdl]:http://ghdl.free.fr/ "VHDL simulator"
