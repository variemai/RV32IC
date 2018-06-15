`include "PipelineRegs.sv"

program testbench(
	input clk,
	input PipelineReg::WBACK_STATE wb_state,
	input PipelineReg::EX_STATE ex_state,
	output logic reset
	);
	

	initial begin
		reset <= 1;
		repeat (2) @(posedge clk); 
		reset <= 0;
		for(int i=0; i<32; i++) begin
			@(posedge clk)
			read_wb_state();
			//read_ex_state();
		end
	end

	task read_wb_state();
		$write("PC: %d\nALUout: %d\n",wb_state.pc,wb_state.final_out);
		$write("RD: %d\nRegWrite: %d\n",wb_state.rd,wb_state.RegWrite);
	endtask

	task read_ex_state();
		$write("PC :%d\nRD :%d\n",ex_state.pc, ex_state.rd);
		$write("IMM: %d\nALUOp :%d\n",ex_state.immediate,ex_state.ALUOp);
	endtask


endprogram
