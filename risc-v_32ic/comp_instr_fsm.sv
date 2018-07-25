

module comp_instr_fsm(
	input  logic			aclk,
	input  logic			aresetn,
	input  logic	[3:0]	instruction,
	output logic	[1:0]	fsm_out);


	enum bit [1:0] { idle=2'b00, bothcomp=2'b01, compregular=2'b10, regularcomp=2'b11 } curr_state, next_state;

	always_ff @(posedge aclk) begin
		if (~aresetn)	curr_state <= #1	idle;
		else			curr_state <= #1	next_state;
	end


	always_comb begin
		
		//next_state = curr_state;
		
		case(curr_state)
			idle:
				begin
					next_state =	(instruction[1:0] != 2'b11 & instruction[3:2] != 2'b11) ? bothcomp :
									(instruction[1:0] != 2'b11 & instruction[3:2] == 2'b11) ? compregular : idle;
				end
			bothcomp:
				begin
					next_state =	idle;
				end
			compregular:
				begin
					next_state = 	(instruction[3:2] == 2'b11) ? compregular : regularcomp;
				end
			regularcomp:
				begin
					next_state =	idle;
				end
			default: next_state =	idle;
		endcase
	end



	always_comb begin
		case(curr_state)
			idle:
				begin
					fsm_out = 2'b00;
				end
			bothcomp:
				begin
					fsm_out = 2'b01;
				end
			compregular:
				begin
					fsm_out = 2'b10;
				end
			regularcomp:
				begin
					fsm_out = 2'b11;
				end
			default:
				begin
					fsm_out = 2'b00;
				end
		endcase
	end
endmodule
