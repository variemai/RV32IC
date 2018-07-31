

module comp_instr_top(
	input  bit				aclk,
	input  logic			aresetn,
	input  logic 			stall,
	input  logic	[31:0]	instruction,
	output logic	[31:0]	decomp_instruction,
	output logic	[2:0]	control
	);
	
	//logic	[1:0]	control;
	logic	[31:0]	reg_out;
	logic	[31:0]	i_demux;

	comp_instr_fsm fsm(
		.aclk			(aclk),
		.aresetn		(aresetn),
		.instruction	({instruction[17:16],instruction[1:0]}),
		.fsm_out		(control),
		.stall			(stall)
		);
	
	always_comb begin
		if (control == 3'b100) begin 
			i_demux = reg_out;
		end else i_demux = instruction;
	end

	comp_instr_demux demux(
		.aclk				(aclk),
		.aresetn			(aresetn),
		.stall				(stall),
		.input_word			(i_demux),
		.control			(control),
		.decomp_instruction	(decomp_instruction),
		.reg_out			(reg_out)
	);
	
endmodule
