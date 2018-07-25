

//`include "PipelineRegs.sv"


module comp_instr_demux(
	input					aclk,
	input  logic			aresetn,
	input  logic	[31:0]	input_word,
	input  logic	[2:0]	control,
	output logic	[31:0]	reg_out,
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
		if(control == 3'b000) begin
			instruction	= input_word[15:0];
			if(input_word[1:0] == 2'b11) begin
				decomp_instruction		= input_word;
			end else begin
				decomp_instruction		= regular_instr;
			end
		end else if(control == 3'b001) begin
			instruction					= next_instr[31:16];
			decomp_instruction			= regular_instr;
		end else if (control == 3'b010) begin
			instruction					= next_instr[31:16];
			decomp_instruction[31:16]	= input_word[15:0];
			decomp_instruction[15:0]	= next_instr[31:16];
		end else if (control == 3'b100) begin
			reg_out = next_instr;
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
