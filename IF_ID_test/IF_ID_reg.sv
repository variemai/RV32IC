`include "../PipelineRegs.sv"


module if_id_reg(
	input clk,
	input logic [31:0] pc_in,
	output logic [31:0] pc_out,
	input enable
);	

always_ff @(posedge clk) begin
	if(enable)
		pc_out <= pc_in;
end

endmodule
