# Simple As Possible computer - 1  (SAP-1)

This is a VHDL implementation of SAP-1, as described in the book "Malvino -
Digital Computer Electronics". 

It uses behavioral modeling to create the blocks of the computer and structural
model to assemble these block in a computational unit, which can be simulated with ghdl. 

You can program the computer writing in the file ```RAM.vhd``` and simulate the
result with the provided testbench, which is the file ```sap1_tb.vhd```.

The simulations were perfomed with *ghdl*. If you are in linux be sure to have the program ghdl instaled and run

```bash
make
./sap1_tb --vcd=waveform.vcd
```

The procedure generates the waveform file ```waveform.vcd```, that can be opened in a program like *gtkwave*.


