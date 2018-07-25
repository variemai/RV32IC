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
		//$readmemh("ldst_code.hex", RAM, 0, 2048);
		$readmemb("compressed_instr.bin", RAM, 0, 32);
	end
	always_ff @(posedge clk) begin
		if(reset) dout <= 0;
		dout <= RAM[addr];
	end
	
endmodule
