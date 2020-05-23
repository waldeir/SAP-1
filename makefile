.PHONY: all

# To enable data inputs use:
# make isap1_tb

all: isap1_tb sap1_tb 

CC = ghdl

work/accumulator.o: src/accumulator.vhd
	@echo Analyzing accumulator.vhd
	$(CC) -a --workdir=work src/accumulator.vhd

work/addsub.o: src/addsub.vhd       
	@echo Analyzing addsub.vhd       
	$(CC) -a --workdir=work src/addsub.vhd

work/jk-flipflop.o: src/jk-flipflop.vhd
	@echo Analyzing jk-flipflop.vhd
	$(CC) -a --workdir=work src/jk-flipflop.vhd

work/pc.o: src/pc.vhd           
	@echo Analyzing pc.vhd
	$(CC) -a --workdir=work src/pc.vhd

work/regb.o: src/regb.vhd         
	@echo Analyzing regb.vhd
	$(CC) -a --workdir=work src/regb.vhd

work/regout.o: src/regout.vhd       
	@echo Analyzing regout.vhd
	$(CC) -a --workdir=work src/regout.vhd

work/mar.o: src/mar.vhd          
	@echo Analyzing mar.vhd
	$(CC) -a --workdir=work src/mar.vhd

work/imar.o: src/imar.vhd          
	@echo Analyzing imar.vhd
	$(CC) -a --workdir=work src/imar.vhd

work/ram.o: src/ram.vhd          
	@echo Analyzing ram.vhd
	$(CC) -a --workdir=work src/ram.vhd

work/iram.o: src/iram.vhd          
	@echo Analyzing iram.vhd
	$(CC) -a --workdir=work src/iram.vhd

work/ir.o: src/ir.vhd           
	@echo Analyzing ir.vhd
	$(CC) -a --workdir=work src/ir.vhd

work/ctrlseq.o: src/ctrlseq.vhd      
	@echo Analyzing ctrlseq.vhd
	$(CC) -a --workdir=work src/ctrlseq.vhd

work/ringcounter.o: src/ringcounter.vhd
	@echo Analyzing ringcounter.vhd
	$(CC) -a --workdir=work src/ringcounter.vhd

work/debounce.o: src/debounce.vhd
	@echo Analyzing debounce.vhd
	$(CC) -a --workdir=work src/debounce.vhd

work/sap1.o: src/sap1.vhd          
	@echo Analyzing sap1.vhd
	$(CC) -a --workdir=work src/sap1.vhd 

work/isap1.o: src/isap1.vhd          
	@echo Analyzing isap1.vhd
	$(CC) -a --workdir=work src/isap1.vhd 

work/sap1_tb.o: src/sap1_tb.vhd
	@echo Analyzing sap1_tb.vhd
	$(CC) -a --workdir=work src/sap1_tb.vhd 


work/isap1_tb.o: src/isap1_tb.vhd
	@echo Analyzing isap1_tb.vhd
	$(CC) -a --workdir=work src/isap1_tb.vhd 


sap1_tb: work/sap1_tb.o work/sap1.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/mar.o work/ram.o work/ir.o work/ctrlseq.o work/ringcounter.o work/jk-flipflop.o work/debounce.o
	@echo Elaborating sap1_tb
	$(CC) -e --workdir=work sap1_tb 

isap1_tb: work/isap1_tb.o work/isap1.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/imar.o work/iram.o work/ir.o work/ctrlseq.o work/ringcounter.o work/jk-flipflop.o work/debounce.o       
	@echo Elaborating isap1_tb
	$(CC) -e --workdir=work isap1_tb 

clean :
	rm work/*.o *.o work/*.cf sap1_tb isap1_tb
