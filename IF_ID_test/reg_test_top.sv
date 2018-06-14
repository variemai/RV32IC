module reg_test_top;
	bit clk;
	bit we;
	logic [4:0] read_addr0;
	logic [4:0] read_addr1;
	logic [4:0] write_addr;
	logic [31:0] din;
	logic [31:0] dout0;
	logic [31:0] dout1;


	RegFile registerfile(
		.clk(clk),
		.we(we),
		.read_addr0(read_addr0),
		.read_addr1(read_addr1),
		.write_addr(write_addr),
		.din(din),
		.dout0(dout0),
		.dout1(dout1)
	);

	reg_test tb(
		.clk(clk),
		.we(we),
		.read_addr0(read_addr0),
		.read_addr1(read_addr1),
		.write_addr(write_addr),
		.din(din),
		.dout0(dout0),
		.dout1(dout1)
	);

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end

endmodule
