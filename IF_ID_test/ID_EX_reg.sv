`include "PipelineRegs.sv"


module id_ex_reg(
	input clk,
	input reset,
	input PipelineReg::EX_STATE in,
	output PipelineReg::EX_STATE out
	//input enable
);

always_ff @(posedge clk) begin
	//if(enable)
	if(reset) begin
		/*
		out.rs1 = 5'b0;
		out.rd = 5'b0;
		out.ALUOp = 3'b011;
		out.ALUsrc = 2'b01;
		out.immediate = 32'b0;
		out.RegWrite = 0;
		out.func3 = 3'b0;
		*/
		out <= 0;
	end else begin
		out <= in;
	end
end

endmodule
