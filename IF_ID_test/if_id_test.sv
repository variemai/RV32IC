`include "../PipelineRegs.sv"
program if_id_tb(
	input clk,
	output logic [31:0] pc,
	input PipelineReg::EX_STATE ex_state,
	input logic [31:0] data0,
	input logic [31:0] data1
	);
	
	logic [31:0] pc_out;
	initial begin
		pc_out = 32'b0;
		for(int i=0; i<4; i++) begin
			issue_and_check_Instr();		
		//@(posedge clk)$write("RS1: %b\nRS2: %b\nRD: %b\nDATA: %b\n",rs1,rs2,rd,write_data);
		end	
	end

	task issue_and_check_Instr();
		@(posedge clk) begin
			pc <= pc_out;
			//pc_out <= pc +4;
			$write("PC: %d\nRS1: %b\nRS2: %b\nRD: %b\nDATA0: %x\nDATA1: %x\n",ex_state.pc,ex_state.rs1,ex_state.rs2,ex_state.rd,data0,data1);
		end
	endtask

endprogram
