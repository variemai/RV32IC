

module comp_instr_fsm(
	input  logic			aclk,
	input  logic			aresetn,
	input  logic	[3:0]	instruction,
	output logic	[2:0]	fsm_out);


	enum bit [2:0] { idle=3'b000, bothcomp=3'b001, compregular=3'b010, regularcomp=3'b011, bothcompsec=3'b100 } curr_state, next_state;

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
					next_state =	bothcompsec;
				end
			bothcompsec:
				begin
					next_state = 	idle;
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
					fsm_out = 3'b000;
				end
			bothcomp:
				begin
					fsm_out = 3'b001;
				end
			bothcompsec:
				begin
					fsm_out = 3'b100;
				end
			compregular:
				begin
					fsm_out = 3'b010;
				end
			regularcomp:
				begin
					fsm_out = 3'b011;
				end
			default:
				begin
					fsm_out = 3'b000;
				end
		endcase
	end
endmodule
