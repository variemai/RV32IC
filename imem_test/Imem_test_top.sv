module Imem_test_top;
	bit clk;
	logic [8:0] address;
	logic [31:0] data_to_mem;
	logic [31:0] data_from_mem;
	logic we;

	sram dut(
		.clk(clk),
		.addr(address),
		.din(data_to_mem),
		.dout(data_from_mem),
		.we(we)
	);

	Imem_test tb(
		.clk(clk),
		.address(address),
		.din(data_from_mem),
		.dout(data_to_mem),
		.we(we)
	);

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end
endmodule
