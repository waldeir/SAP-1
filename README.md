# Simple As Possible computer - 1  (SAP-1)

This is a VHDL implementation of the well known computer SAP-1, described in
the book
[Malvino - Digital Computer Electronics - 3rd Edition](https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945).
It uses behavioral modeling
to create the blocks of the computer and structural modeling to assemble these
block into a computational unit. The signals active states where chosen to
match the ones described in the book, therefore the same waveforms presented in
the SAP-1 chapter can be visualized in the simulation.

![](images/block_diagram_sap1.png)

**Figure 1**: Structural model of SAP1 where each block uses behavioral model.


You can program the computer writing in the file `RAM.vhd` and simulate the
result with the provided *testbench*, which is the file `sap1_tb.vhd`.


## Linux and GHDL

If you are in linux be sure to have the program ghdl installed and run

```bash
git clone https://github.com/waldeir/sap1
cd sap1/
make
./sap1_tb --vcd=waveform.vcd
```

The procedure generates the waveform file `waveform.vcd`, that can be opened in
a program like *gtkwave*. The variable names of signals are presented in
**Figure 1**, and their behavior during time are stored in the file
`waveform.vcd`.


