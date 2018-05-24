`include "../PipelineRegs.sv"


module id_ex_reg(
	input clk,
	input PipelineReg::EX_STATE in,
	output PipelineReg::EX_STATE out
	//input enable
);

always_ff @(posedge clk) begin
	//if(enable)
		out <= in;
end

endmodule
