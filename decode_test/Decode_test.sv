`include "../PipelineRegs.sv"
`include "../ISA.sv"

program decode_test(
	input clk,
	input PipelineReg::EX_STATE ex_state,
	output PipelineReg::ID_STATE id_state
);
	logic [31:0] pc = 31'b0;
	initial begin
		issue_r_instruction(pc);
		//pc = pc + 4;
	end


	task issue_r_instruction(bit [31:0] pc);
		@(posedge clk) begin
			id_state.instruction <= 32'b00000000000100010000000000110011;
			id_state.pc <= pc;
		end
		@(posedge clk) begin
			assert(ex_state.rd == 5'b0);
			assert(ex_state.rs1 == 5'b10);
			assert(ex_state.rs2 == 5'b01);
			assert(ex_state.pc == 5'b0);
			assert(ex_state.pc == pc);
			assert(ex_state.func3 == 3'b0);
			assert(ex_state.func7 == 7'b0);
		end
	endtask

endprogram
