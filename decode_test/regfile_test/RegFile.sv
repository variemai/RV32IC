module RegFile(
	input clk,
	input we,
	input logic [4:0] read_addr0,
	input logic [4:0] read_addr1,
	input logic [4:0] write_addr,
	input logic [31:0] din,
	output logic [31:0] dout0,
	output logic [31:0] dout1
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
