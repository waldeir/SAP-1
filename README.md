# Simple As Possible computer - 1  (SAP-1)

This is a VHDL implementation of SAP-1, as described in the book "Malvino -
Digital Computer Electronics". 

![](images/block_diagram_sap1.png)

**Figure 1**: Structural model of SAP1 where each block uses behavioral model.

The simulations were perfomed with *ghdl*. If you are in linux be sure to have the program ghdl instaled and run

```bash
make
./sap1_tb --vcd=waveform.vcd
```

The procedure generates the waveform file ```waveform.vcd```, that can be opened in a program like *gtkwave*.


