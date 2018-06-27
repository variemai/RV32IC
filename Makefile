all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key inter.vpd DVEfiles .restartSimSession.tcl.old .synopsys_dve_rebuild.tcl

comp:
	vcs -sverilog \
	IF_ID_test/Decoder.sv IF_ID_test/regfile.sv IF_ID_test/RegFile.sv IF_ID_test/IFetch.sv IF_ID_test/imem.sv IF_ID_test/ID_EX_reg.sv \
	ex_state/rtl/alu.sv \
	dmem_state/rtl/dmem.sv \
	top.sv dmem_tb.sv \
	-debug_all -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
