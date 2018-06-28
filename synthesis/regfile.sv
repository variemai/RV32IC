module regfile
#(
//------------------------------------------------
parameter ADDR_WIDTH = 5,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 32
//------------------------------------------------
)   (
	input clk,
	input we,
	input [ADDR_WIDTH-1:0] read_addr,
	input [ADDR_WIDTH-1:0] write_addr,
	input [DATA_WIDTH-1:0] din,
	output logic [DATA_WIDTH-1:0] dout
	);

	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	logic [DATA_WIDTH-1:0] dout;
	
	initial begin
		$readmemh("regfile.data", RAM, 0, 32);
	end
	
	always @(posedge clk) begin
		if(we) begin
			if(write_addr != 0 ) begin
				RAM[write_addr] <= din;
			end
			if(read_addr == write_addr) begin 
				dout <= din;
			end
			else dout <= RAM[read_addr];
		end
		else
			dout <= RAM[read_addr];
	end
	
endmodule
