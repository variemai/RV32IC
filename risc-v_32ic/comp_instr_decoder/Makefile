all:	clean comp run

all2:	clean comp run_gui

clean:
	\rm -rf simv csrc simv* comp.log sim.log inter.vpd ucli.key DVEfiles .restartSimSession.tcl.old .synopsys_dve_rebuild.tcl

comp:
	vcs -sverilog comp_instr_decoder.sv comp_instr_decoder_tb.sv instructions.sv imem.sv comp_instr_decoder_top_tb.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run_gui:
	./simv -gui -l sim.log
