program Imem_test(
    input clk,
	output logic reset,
    input logic [7:0] data_in,
    output logic [7:0] address,
    output logic we,
	output logic oe,
    output logic [7:0] data_out
    );
    logic [7:0] addr = 8'b00000000;
	logic [7:0] data_to_write = 8'b00000000;
	logic [7:0] addr_to_read = 8'b00000000;
	logic [3:0] i=4'b0000;
	logic [3:0] j=4'b0000;
	always @(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			if(i<16)
			begin
				data_out <= data_to_write+i;
				we <= 1;
				oe <= 0;
				address <= addr + i;
				i<=i+1;
			end
			else
			begin
				if(j<16)
				begin
				data_to_write <= 0;
				we <= 0;
				oe <= 1;
				data_out <= data_to_write;
				address <= addr_to_read+j;
				j<=j+1;
				$display("Addr: %b, Data: %b",address,data_in);
				end
				else $finish;
			end

		end	
	end

	
endprogram
