

//`include "PipelineRegs.sv"


module comp_instr_demux(
	input					aclk,
	input  logic			aresetn,
	input  logic	[31:0]	input_word,
	input  logic	[1:0]	control,
	output logic	[31:0]	decomp_instruction);
	
	
	logic	[15:0]	instruction;
	logic	[31:0]	next_instr;
	logic	[31:0]	regular_instr;

	always_ff @(posedge aclk)	begin
		if (~aresetn) begin
			next_instr <= #1 0;
		end else begin
			next_instr <= #1 input_word;
		end
	end

	comp_instr_decoder cdecoder(
		.instruction			(instruction),
		.decomp_instruction		(regular_instr));

	always_comb	begin
		if(control == 2'b00) begin
			instruction	= input_word[15:0];
			if(input_word[1:0] == 2'b11) begin
				decomp_instruction		= input_word;
			end else begin
				decomp_instruction		= regular_instr;
			end
		end else if(control == 2'b01) begin
			instruction					= next_instr[31:16];
			decomp_instruction			= regular_instr;
		end else if (control == 2'b10) begin
			instruction					= next_instr[31:16];
			decomp_instruction[31:16]	= input_word[15:0];
			decomp_instruction[15:0]	= next_instr[31:16];
		end else begin
			instruction					= next_instr[31:16];
			decomp_instruction			= regular_instr;
		end

		/*case(instruction[1:0])
			2'b11:
				begin
					decomp_instruction = instruction;		
				end
			default:
				begin
					
				end
		endcase*/
	end
	/*assign decomp_instruction = (instruction[1:0] == 2'b11)
								? instruction
								: */
endmodule
