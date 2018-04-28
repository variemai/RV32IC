`include "../PipelineRegs.sv"
`include "../ISA.sv"

program decode_test(
	input clk,
	input PipelineReg::EX_STATE ex_state,
	output PipelineReg::ID_STATE id_state
);
	logic [31:0] pc = 31'b0;
	integer i;
	initial begin
		for(i=0; i<2; i++) begin
			@(posedge clk) begin
				issue_instruction(pc,32'b00000000000100010000000000110011);
				pc <= pc + 4;
				//issue_instruction(pc,
			end
		end
	end


	task issue_instruction(bit [31:0] _pc,bit [31:0] instruction);
		@(posedge clk) begin
			id_state.instruction = instruction;
			id_state.pc = _pc;
		end
		@(posedge clk) begin
			assert(ex_state.rd == 5'b0);
			assert(ex_state.rs1 == 5'b10);
			assert(ex_state.rs2 == 5'b01);
			assert(ex_state.pc == _pc);
			assert(ex_state.func3 == 3'b0);
			assert(ex_state.func7 == 7'b0);
		end
	endtask

endprogram
