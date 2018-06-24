module imem
#(
//------------------------------------------------
parameter ADDR_WIDTH = 11,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 2048
//------------------------------------------------
)   (
	input clk,
	input reset,
	input [ADDR_WIDTH-1:0] addr,
	output logic [DATA_WIDTH-1:0] dout
	);

	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	initial begin
		$readmemb("branch_code.bin", RAM, 0, 9);
	end
	always_ff @(posedge clk) begin
		if(reset) dout <= 0;
		dout <= RAM[addr];
	end
	
endmodule
