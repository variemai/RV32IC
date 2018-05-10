module Imem_test_top;
	bit clk;
	wire [31:0] pc;
	logic [31:0] data_from_mem;

	IFetch dut(
		.clk(clk),
		.pc_in(pc),
		.pc_out(pc),
		.instruction(data_from_mem)
	);

	Imem_test tb(
		.clk(clk),
		.din(data_from_mem),
		.pc(pc)
	);

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end
endmodule
