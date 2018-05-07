module RegFile(
	input clk,
	input we,
	input [4:0] read_addr0,
	input [4:0] read_addr1,
	input [4:0] write_addr,
	input [31:0] din,
	output [31:0] dout0,
	output [31:0] dout1
);

	regfile regfile1(
		.clk(clk),
		.we(we),
		.read_addr(read_addr0),
		.write_addr(write_addr),
		.din(din),
		.dout(dout0)
	);

	regfile regfile2(
		.clk(clk),
		.we(we),
		.read_addr(read_addr1),
		.write_addr(write_addr),
		.din(din),
		.dout(dout1)
	);

endmodule
