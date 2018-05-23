`include "../PipelineRegs.sv"
module IFetch(
	input clk,
	input logic enable,
	input logic [31:0] pc_in,
	input logic [31:0] stall_pc,
	output logic [31:0] pc_out,
	output logic [31:0] instruction,
	input reset
	);
	

	always_ff @(posedge clk) begin 
		if(reset) begin 
			pc_out <= 32'b0;
		end
		else begin
			if(enable) pc_out <= pc_in + 4;
			else pc_out <= stall_pc;
		end
	end

	imem InstructionMem(
		.clk(clk),
		.addr(pc_out[10:2]),
		.dout(instruction)
	);
	

endmodule
