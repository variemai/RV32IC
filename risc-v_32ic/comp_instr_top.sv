

module comp_instr_top(
	input  bit				aclk,
	input  logic			aresetn,
	input  logic	[31:0]	instruction,
	output logic	[31:0]	decomp_instruction,
	output logic	[1:0]	control
	);
	
	//logic	[1:0]	control;

	comp_instr_fsm fsm(
		.aclk			(aclk),
		.aresetn		(aresetn),
		.instruction	({instruction[17:16],instruction[1:0]}),
		.fsm_out		(control)
		);

	comp_instr_demux demux(
		.aclk				(aclk),
		.aresetn			(aresetn),
		.input_word			(instruction),
		.control			(control),
		.decomp_instruction	(decomp_instruction)
	);
	
endmodule
