program Imem_test(
    input clk,
    input logic [31:0] din,
	input [31:0] pc
    );
	
	initial begin
		for(int i=0; i<10; i++) begin
			checkReadOP(pc);
		end
	end
/******************************************************
	task checkWriteOP(bit [31:0] data, bit [8:0] addr);
		
	endtask
*******************************************************/

	task checkReadOP(bit [31:0] addr);
		@(posedge clk) $write("DATA: %b, ADDR: %b\n",din,addr);
	endtask

endprogram
