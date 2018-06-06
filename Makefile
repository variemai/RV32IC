all: clean all_states run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

all_states:
	vcs -sverilog \
	IF_ID_test/Decoder.sv IF_ID_test/regfile.sv IF_ID_test/RegFile.sv IF_ID_test/IFetch.sv IF_ID_test/imem.sv IF_ID_test/top.sv IF_ID_test/ID_EX_reg.sv IF_ID_test/if_id_test.sv \
	ex_state/test/alu.test_top.sv ex_state/rtl/alu.sv ex_state/test/alu_test.sv \
	dmem_state/test/dmem.test_top.sv dmem_state/rtl/dmem.sv dmem_state/test/dmem_test.sv \
	-debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
