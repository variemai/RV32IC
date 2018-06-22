module imem
#(
//------------------------------------------------
parameter ADDR_WIDTH = 11,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 2048
//------------------------------------------------
)   (
	input clk,
	input [ADDR_WIDTH-1:0] addr,
	output logic [DATA_WIDTH-1:0] dout
	);

	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	initial begin
		$readmemb("dmem_instr.data", RAM, 0, 32);
	end
	always_ff @(posedge clk) begin
		dout <= RAM[addr];
	end
	
endmodule
