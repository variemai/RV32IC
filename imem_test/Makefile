all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log

comp:
	vcs -sverilog Imem_test_top.sv ../Imem.sv Imem_test.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
