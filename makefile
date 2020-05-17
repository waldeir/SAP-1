.PHONY: all

all: work/sap1_tb.o work/sap1.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/mar.o work/ram.o work/ir.o work/ctrlseq.o work/ringcounter.o sap1_tb work/jk-flipflop.o    


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

work/ram.o: src/ram.vhd          
	@echo Analyzing ram.vhd
	$(CC) -a --workdir=work src/ram.vhd

work/ir.o: src/ir.vhd           
	@echo Analyzing ir.vhd
	$(CC) -a --workdir=work src/ir.vhd

work/ctrlseq.o: src/ctrlseq.vhd      
	@echo Analyzing ctrlseq.vhd
	$(CC) -a --workdir=work src/ctrlseq.vhd

work/ringcounter.o: src/ringcounter.vhd
	@echo Analyzing ringcounter.vhd
	$(CC) -a --workdir=work src/ringcounter.vhd

work/sap1.o: src/sap1.vhd          
	@echo Analyzing sap1.vhd
	$(CC) -a --workdir=work src/sap1.vhd 

work/sap1_tb.o: src/sap1_tb.vhd
	@echo Analyzing sap1_tb.vhd
	$(CC) -a --workdir=work src/sap1_tb.vhd 

sap1_tb: work/sap1_tb.o work/sap1.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/mar.o work/ram.o work/ir.o work/ctrlseq.o work/ringcounter.o work/jk-flipflop.o        
	@echo Elaborating sap1_tb
	$(CC) -e --workdir=work sap1_tb 


clean :
	rm work/*.o sap1_tb *.o work/*.cf
