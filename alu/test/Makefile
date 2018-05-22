all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

comp:
	vcs -sverilog alu.test_top.sv ../rtl/alu.sv alu_test.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log

