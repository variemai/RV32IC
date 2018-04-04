`include "../PipelineRegs.sv"
module decode_test_top;
	bit clk;
	PipelineReg::ID_STATE id_state;
	PipelineReg::EX_STATE ex_state;
	logic reset;

	decoder dut(
		.clk(clk),
		.reset(reset),
		.id_state(id_state),
		.ex_state(ex_state)
	);
	
	decode_test tb(
		.clk(clk),
		.ex_state(ex_state),
		.id_state(id_state)
	);

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end
endmodule
