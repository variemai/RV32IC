all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log inter.vpd

comp:
	vcs -sverilog regfile.sv RegFile.sv reg_test.sv reg_test_top.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
