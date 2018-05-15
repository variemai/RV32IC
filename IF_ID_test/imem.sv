module imem
#(
//------------------------------------------------
parameter ADDR_WIDTH = 9,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 512
//------------------------------------------------
)   (
	input clk,
	input [ADDR_WIDTH-1:0] addr,
	output logic [DATA_WIDTH-1:0] dout
	);

	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	initial begin
		$readmemb("instr_dependencies.data", RAM, 0, 10);
	end
	always @(posedge clk) begin
		dout <= RAM[addr];
	end
	
endmodule
