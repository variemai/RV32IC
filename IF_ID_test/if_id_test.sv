`include "PipelineRegs.sv"
program if_id_tb(
	input clk,
	input PipelineReg::EX_STATE ex_state,
	input logic [31:0] data0,
	input logic [31:0] data1,
	input logic [31:0] jmp_pc,
	output logic reset
	);
	
	initial begin
		reset <= 1;
		repeat (2) @(posedge clk);
		reset <= 0;
		for(int i=0; i<2048; i++) begin
			issue_and_check_Instr();		
		end
	end

	task issue_and_check_Instr();
		@(posedge clk) begin
			$write("PC: %d\nRD: %b\nJMP_PC: %d\nIMMEDIATE: %d\n",ex_state.pc,ex_state.rd,jmp_pc,ex_state.immediate);
		end
	endtask

endprogram
