`include "../PipelineRegs.sv"
module IFetch(
	input clk,
	input logic [31:0] pc_in,
	output logic [31:0] pc_out,
	output logic [31:0] instruction 
	);
	
	initial begin
		pc_out <= 32'b0;
	end
	
	always @(posedge clk) begin
		pc_out<= pc_in +4;
	end

	imem InstructionMem(
		.clk(clk),
		.addr(pc_out[10:2]),
		.dout(instruction)
	);

endmodule
