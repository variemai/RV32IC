program RegisterFile_test(
	input clk,
	output we,
	output logic [4:0] read_addr0,
	output logic [4:0] read_addr1,
	output logic [4:0] write_addr,
	output logic [31:0] din,
	input logic [31:0] dout0,
	input logic [31:0] dout1
);
	logic [4:0] ra1 = 5'b0;
	logic [4:0] ra2 = 5'b00001;
	integer i;
	initial begin
		//for(i=0; i<4; i++) begin
		//	ra1 = ra1+1;
		//	ra2 = ra2+1;
			@(posedge clk) begin
				read(ra1,ra2);
			end
		//end
	end

	task read(ra1,ra2);
		read_addr0 = ra1;
		read_addr1 = ra2;
		@(posedge clk) begin
			$write("DOUT0: %b\n",dout0);
			$write("DOUT1: %b\n",dout1);
		end
	endtask
	

endprogram
