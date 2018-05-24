all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log

comp:
	vcs -sverilog Decoder.sv regfile.sv RegFile.sv IFetch.sv imem.sv top.sv if_id_test.sv ID_EX_reg.sv  -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
