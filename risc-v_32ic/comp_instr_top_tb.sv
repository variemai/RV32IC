

module comp_instr_top_tb();
	bit				aclk;
	bit				aresetn;
	//logic	[31:0]	instruction;
	logic	[31:0]	decomp_instruction;
	logic 	[1:0]	control;
	
	localparam 	ADDR_WIDTH = 11;
	localparam 	DATA_WIDTH = 32;
	
	logic	[ADDR_WIDTH-1:0]	addr;
	logic	[DATA_WIDTH-1:0]	dout;
	
	comp_instr_top dut(
		.aclk				(aclk),
		.aresetn			(aresetn),
		.instruction		(dout),
		.decomp_instruction	(decomp_instruction),
		.control			(control)
	);
	
	imem imem(
		.clk		(aclk),
		.reset		(~aresetn),
		.addr		(addr),
		.dout		(dout)
	);
	
	comp_instr_dut_tb tb(
		.aclk				(aclk),
		.aresetn			(aresetn),
		.decomp_instruction	(decomp_instruction),
		.word				(dout),
		.address			(addr),
		.control			(control)
	);
	
	initial begin
		aclk = 0;
		
		forever begin
			#100 aclk = ~aclk;
		end
	end
	
endmodule
