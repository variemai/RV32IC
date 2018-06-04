`include "../PipelineRegs.sv"
program if_id_tb(
	input clk,
	input PipelineReg::EX_STATE ex_state,
	input logic [31:0] data0,
	input logic [31:0] data1,
	output logic reset
	);
	
	initial begin
		reset = 1;
		@(posedge clk)
		reset = 0;
		for(int i=0; i<15; i++) begin
			issue_and_check_Instr();		
		end
	end

	task issue_and_check_Instr();
		@(posedge clk) begin
			$write("PC: %d\nRS1: %b\nRS2: %b\nRD: %b\nDATA0: %x\nDATA1: %x\n",ex_state.pc,ex_state.rs1,ex_state.rs2,ex_state.rd,data0,data1);
		end
	endtask

endprogram
