program Imem_test(
    input clk,
    input logic [31:0] din,
    output logic [8:0] address,
    output logic we,
    output logic [31:0] dout
    );
	logic [31:0] addr = 32'b0;
	integer i;
	begin
		for(i=0; i<10; i++) begin
			checkReadOP(addr);
			addr = addr +1;
		end
	end
/******************************************************
	task checkWriteOP(bit [31:0] data, bit [8:0] addr);
		
	endtask
*******************************************************/

	task checkReadOP(bit [8:0] addr);
	@(posedge clk) begin
		address <= addr;
		we <= 0;
	end
	@(posedge clk) $write("DATA: %b, ADDR: %b",din,addr);
	endtask

endprogram
