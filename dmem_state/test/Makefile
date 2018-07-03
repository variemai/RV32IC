all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key

comp:
	vcs -sverilog dmem.test_top.sv dmem_test.sv ../rtl/dmem.sv ../rtl/mem_sync_sp.sv -debug_all -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
