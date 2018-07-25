

module comp_instr_decoder_top_tb;
	bit			aclk;
	bit			aresetn;
	
	localparam 	ADDR_WIDTH = 11;
	localparam 	DATA_WIDTH = 32;
	
	logic	[ADDR_WIDTH-1:0]	addr;
	logic	[DATA_WIDTH-1:0]	dout;
	logic	[31:0]				decomp_instruction;
	logic	[15:0]				cinstruction;
	//logic [1:0]	control;
	
	comp_instr_decoder_tb tb(
		.aclk 				(aclk),
		.decomp_instruction	(decomp_instruction),
		.word				(dout),
		//.control			(control),
		.aresetn			(aresetn),
		.address			(addr),
		.cinstruction		(cinstruction)
	);
	
	imem im(
		.clk	(aclk),
		.reset	(~aresetn),
		.addr	(addr),
		.dout	(dout)
	);
	
	comp_instr_decoder decoder(
		.instruction		(cinstruction),
		.decomp_instruction	(decomp_instruction)
	);
	
	initial begin
		aclk = 0;
		
		forever begin
			#100 aclk = ~aclk;
		end
	end
	
endmodule
