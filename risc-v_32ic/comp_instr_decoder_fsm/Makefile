all:	clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log inter.vpd ucli.key DVEfiles .restartSimSession.tcl.old .synopsys_dve_rebuild.tcl

comp:
	vcs -sverilog comp_instr_decoder.sv comp_instr_fsm.sv comp_instr_decoder_fsm_tb.sv instructions.sv imem.sv comp_instr_decoder_fsm_top_tb.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

