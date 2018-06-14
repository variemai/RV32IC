`include "PipelineRegs.sv"

program testbench(
	input clk,
	input PipelineReg::MEM_STATE mem_state,
	output logic reset
	);
	

	initial begin
		reset <= 0;
		repeat (2) @(posedge clk); 
		reset <= 1;
		for(int i=0; i<100; i++) begin
			@(posedge clk)
			read_mem_state();
		end
	end

	task read_mem_state();
		$write("PC: %d\nALUout: %d\n",mem_state.pc,mem_state.ALUOutput);
		$write("RD: %d\nRegWrite: %d\n",mem_state.rd2,mem_state.RegWrite);
	endtask


endprogram
