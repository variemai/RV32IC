all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log

comp:
	vcs -sverilog RegFile.sv regfile.sv Decode_test_top.sv Decode_test.sv Decoder.sv -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log
