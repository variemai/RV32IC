`include "PipelineRegs.sv"

program testbench(
	input clk,
	input PipelineReg::MEM_STATE mem_state,
	input PipelineReg::EX_STATE ex_state,
	output logic reset
	);
	

	initial begin
		reset <= 1;
		repeat (2) @(posedge clk); 
		reset <= 0;
		for(int i=0; i<100; i++) begin
			@(posedge clk)
			//read_mem_state();
			read_ex_state();
		end
	end

	task read_mem_state();
		$write("PC: %d\nALUout: %d\n",mem_state.pc,mem_state.ALUOutput);
		$write("RD: %d\nRegWrite: %d\n",mem_state.rd2,mem_state.RegWrite);
	endtask

	task read_ex_state();
		$write("PC :%d\nRD :%d\n",ex_state.pc, ex_state.rd);
		$write("IMM: %d\nALUOp :%d\n",ex_state.immediate,ex_state.ALUOp);
	endtask


endprogram
