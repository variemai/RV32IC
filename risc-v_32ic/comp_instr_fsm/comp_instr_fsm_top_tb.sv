

module comp_instr_fsm_top_tb;
	bit			aclk;
	bit			aresetn;
	logic [3:0]	instruction;
	logic [1:0]	fsm_out;
	
	comp_instr_fsm_tb tb(
		.aclk 				(aclk),
		.fsm_out			(fsm_out),
		.aresetn			(aresetn),
		.instruction		(instruction)
	);
	
	comp_instr_fsm fsm(
		.aclk			(aclk),
		.aresetn		(aresetn),
		.instruction	(instruction),
		.fsm_out		(fsm_out)
	);
	
	initial begin
		aclk = 0;
		
		forever begin
			#100 aclk = ~aclk;
		end
	end
	
endmodule
