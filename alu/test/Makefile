all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log

comp:
	vcs -sverilog alu.test_top.v ../rtl/alu.v alu_test.v -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log

