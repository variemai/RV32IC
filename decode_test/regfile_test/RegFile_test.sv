program RegisterFile_test(
	input clk,
	output logic we,
	output logic [4:0] read_addr0,
	output logic [4:0] read_addr1,
	output logic [4:0] write_addr,
	output logic [31:0] din,
	input logic [31:0] dout0,
	input logic [31:0] dout1
);
	logic [4:0] ra1 = 5'b0;
	logic [4:0] ra2 = 5'b00011;
	integer i;
	initial begin
		for(i=0; i<8; i++) begin
			write_all();
			ra1 = ra1 + 1;
			ra2 = ra2 + 1;
		end
		ra1 = 5'b0;
		ra2 = 5'b1;
		for(i=0; i<8; i++) begin
			read_all();
			ra1 = ra1 + 1;
			ra2 = ra2 + 1;
		end
		ra1 = 5'b0;
		ra2 = 5'b1;
		readwrite();
	end

	task read_all();
		$write("READ ADDR: %d %d\n",ra1,ra2);
		
		@(posedge clk) begin
			read_addr0 <= ra1;
			read_addr1 <= ra2;
		end
		@(posedge clk) begin
			$write("DOUT0: %b\n",dout0);
			$write("DOUT1: %b\n",dout1);
		end
	endtask

	task write_all();
		$write("WRITE ADDR: %d\n",ra1);
		@(posedge clk) begin
			write_addr <= ra1;
			din <= ra2;
			we <= 1;
		end
		@(posedge clk) begin
			we <= 0;
		end
	endtask

	task readwrite();
		@(posedge clk) begin
			write_addr <= ra1;
			we <= 1;
			din <= 32'b0;
			read_addr0 <= ra1;
			read_addr1 <= ra2;
		end
		@(posedge clk) begin
			we <= 0;
			$write("DOUT0: %b\n",dout0);
			$write("DOUT1: %b\n",dout1);
		end
	endtask

endprogram
