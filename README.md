Language: [Portuguese](https://github.com/waldeir/SAP-1/blob/master/README.pt.md)

# Simple As Possible computer - 1  (SAP-1)

This is a VHDL implementation of the well known computer SAP-1, described in
the book [Malvino - Digital Computer Electronics - 3rd Edition][book].  It uses
behavioral modeling to create the blocks of the computer and structural
modeling to assemble these blocks into a computational unit, **Figure 1**. The
signals active states where chosen to match the ones described in the book,
therefore the same waveforms presented in the SAP-1 chapter can be visualized
in the simulation.

![](images/block_diagram_sap1.png)

**Figure 1**: Structural model of SAP1, where each block uses behavioral modelling.
Beside each signal, there is their name implemented in the VHDL code.

## Particularities of this implementation

The aim of this implementation is to provide a way to see the internal
signals, **Figure 1**, of SAP-1, during a computer run. The blocks of the
computer where implemented with the same inputs and outputs as specified in
[Malvino - Digital Computer Electronics - 3rd Edition][book], except the
Controller Sequencer, which does not have the outputs `clr`, `bar_clr`, `clk`
and `bar_clk`, but instead has a `clk` input. As shown in **Figure 2**, these
signals are provided from the outside of the SAP-1 block and are distributed to
the corresponding units.

![](images/sap1_top_level.png)

**Figure 2**: Inputs and outputs of this SAP-1 implementation.

The **input of data** through *Memory Address Register* (MAR) was not implemented, but you
can program the computer directly writing in the file `RAM.vhd` and simulate
the result with the provided *testbench*, which is the file `sap1_tb.vhd`.

Although the signals `clr` and `bar_clr` appear in the block diagrams, they
remain disabled throughout the simulation, because they are only used to switch
to **input of data** mode, which was not implemented.

### Data Input

The **Figure 3** shows the implementation of the  input and data on SAP-1. In order to compile this version run:


![](images/isap1_block_diagram.png)

**Figure 3**: Block diagram of SAP-1 with data entries. 

```bash
make isap1_tb
./isap1_tb --vcd=waveform.vcd
```

The *testbench* `isap1_tb.vhd` uses the input switches of SAP-1, shown in **Figure 4**, to load and run three differente programs.


![](images/isap1_top_level.png)

**Figure 4**: SAP-1 with its input switches.

## Linux and GHDL

If you are in linux be sure to have the programs *ghdl* and *git* installed and run

```bash
git clone https://github.com/waldeir/SAP-1
cd SAP-1/
make
./sap1_tb --vcd=waveform.vcd
```

The procedure generates the waveform file `waveform.vcd`, that can be opened in
a program like *gtkwave*. The names of signal variables are presented in
**Figure 1**, and their behavior during time are stored in the file
`waveform.vcd`.


[book]:https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945 "https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945"
