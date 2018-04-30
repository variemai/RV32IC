module sram
#(
//------------------------------------------------
parameter ADDR_WIDTH = 5,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 32
//------------------------------------------------
)   (
	input clk,
	input we,
	input [ADDR_WIDTH-1:0] addr,
	input [DATA_WIDTH-1:0] din,
	output [DATA_WIDTH-1:0] dout
	);

	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	logic [DATA_WIDTH-1:0] dout;
	initial begin
		$readmemb("regfile.data", RAM, 0, 10);
	end
	always @(posedge clk) begin
		if(we)
			RAM[addr] <= din;
		else
			dout <= RAM[addr];
	end
	
endmodule
