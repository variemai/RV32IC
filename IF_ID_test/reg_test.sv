program reg_test(
	input clk,
	output logic we,
	output logic [4:0] read_addr0,
	output logic [4:0] read_addr1,
	output logic [4:0] write_addr,
	output logic [31:0] din,
	input logic [31:0] dout0,
	input logic [31:0] dout1
	);

	logic [4:0] address;
	initial begin
		address = 4'b0;
		for(int i=0; i<32; i++) begin
			write_data(address,address);
			address = address + 1;
		end
		address = 4'b0;
		for(int i=0; i<16; i++) begin
			read_data(address);
			address = address + 1;	
		end
	end

	task write_data(bit [4:0] addr, bit [4:0] data);
		@(posedge clk) begin
			we <= 1;
			write_addr <= addr;
			din <= data;
		end
	endtask

	task read_data(bit [4:0] addr);
		@(posedge clk) begin
			we <= 0 ;
			read_addr0 <= address;
			read_addr1 <= address + 1;
			$write("DOUT0 : %d\nDOUT1: %d\n",dout0,dout1);
		end
	endtask
		
endprogram
	
