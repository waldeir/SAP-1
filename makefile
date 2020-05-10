.PHONY: all

all: work/sap1_tb.o work/sap.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/mar.o work/ram.o work/ir.o work/ctrlseq.o work/ringcounter.o sap1_tb     


CC = ghdl

work/accumulator.o: accumulator.vhd
	@echo Analyzing accumulator.vhd
	$(CC) -a --workdir=work accumulator.vhd

work/addsub.o: addsub.vhd       
	@echo Analyzing addsub.vhd       
	$(CC) -a --workdir=work addsub.vhd

work/pc.o: pc.vhd           
	@echo Analyzing pc.vhd
	$(CC) -a --workdir=work pc.vhd

work/regb.o: regb.vhd         
	@echo Analyzing regb.vhd
	$(CC) -a --workdir=work regb.vhd

work/regout.o: regout.vhd       
	@echo Analyzing regout.vhd
	$(CC) -a --workdir=work regout.vhd

work/mar.o: mar.vhd          
	@echo Analyzing mar.vhd
	$(CC) -a --workdir=work mar.vhd

work/ram.o: ram.vhd          
	@echo Analyzing ram.vhd
	$(CC) -a --workdir=work ram.vhd

work/ir.o: ir.vhd           
	@echo Analyzing ir.vhd
	$(CC) -a --workdir=work ir.vhd

work/ctrlseq.o: ctrlseq.vhd      
	@echo Analyzing ctrlseq.vhd
	$(CC) -a --workdir=work ctrlseq.vhd

work/ringcounter.o: ringcounter.vhd
	@echo Analyzing ringcounter.vhd
	$(CC) -a --workdir=work ringcounter.vhd

work/sap.o: sap.vhd          
	@echo Analyzing sap.vhd
	$(CC) -a --workdir=work sap.vhd 

work/sap1_tb.o: sap1_tb.vhd
	@echo Analyzing sap1_tb.vhd
	$(CC) -a --workdir=work sap1_tb.vhd 

sap1_tb: work/sap1_tb.o work/sap.o work/accumulator.o work/addsub.o work/pc.o work/regb.o work/regout.o work/mar.o work/ram.o work/ir.o work/ctrlseq.o work/ringcounter.o         
	@echo Elaborating sap1_tb
	$(CC) -e --workdir=work sap1_tb 


clean :
	rm work/*.o sap1_tb *.o work/*.cf
