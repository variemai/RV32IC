all: clean alu run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

alu:
	vcs -sverilog alu.test_top.sv ../rtl/alu.sv alu_test.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log

