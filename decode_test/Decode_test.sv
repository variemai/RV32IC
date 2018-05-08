`include "../PipelineRegs.sv"
`include "../ISA.sv"

program decode_test(
	input clk,
	input PipelineReg::EX_STATE ex_state,
	output PipelineReg::ID_STATE id_state,
	input [31:0] data0,
	input [31:0] data1
);
	logic [31:0] pc = 32'b0;
	logic [31:0] Rinstr0 = 32'b00000000001000100000000010110011; //rs2=2, rs1=4, rd=1
	logic [31:0] Rinstr1 = 32'b00000000001100101000000010110011; //rs2=3, rs1=5, rd=1
	logic [31:0] Rinstr2 = 32'b00000001010011000000000010110011; //rs2=20, rs1=24, rd=1
	logic [31:0] Iinstr = 32'b10000000000000000000000000010011;
	logic [31:0] Linstr = 32'b10000000000000000000000000000011;
 	integer i;	
	initial begin
			//@(posedge clk) begin
				issue_Rinstruction(pc, Rinstr0);
				pc = pc + 4;
				//issue_Linstruction(pc, Linstr);
				//pc = pc + 4;
				//issue_Iinstruction(pc, Iinstr);
				//pc = pc + 4;
			//end
	end


	task issue_Rinstruction(bit [31:0] _pc,bit [31:0] instruction);
		@(posedge clk) begin
			id_state.instruction = instruction;
			id_state.pc = _pc;
		end
		@(posedge clk) begin
			assert(ex_state.rd == instruction[]);
			assert(ex_state.rs1 == 5'b00100);
			assert(ex_state.rs2 == 5'b00010);
			assert(ex_state.pc == _pc);
			assert(ex_state.func3 == 3'b0);
			assert(ex_state.func7 == 7'b0);
			$write("DOUT0: %x\n",data0);
			$write("DOUT1: %x\n",data1);
		end
	endtask

	task issue_Iinstruction(bit [31:0] _pc,bit [31:0] instruction);
		@(posedge clk) begin
			id_state.instruction = instruction;
			id_state.pc = _pc;
		end
		@(posedge clk) begin
			assert(ex_state.immediate == 32'b11111111111111111111100000000000);
		end
	endtask

	task issue_Linstruction(bit [31:0] _pc,bit [31:0] instruction);
		@(posedge clk) begin
			id_state.instruction = instruction;
			id_state.pc = _pc;
		end
		@(posedge clk) begin
			assert(ex_state.immediate == 32'b11111111111111111111100000000000) else $display("Immediate: ",ex_state.immediate);
			assert(ex_state.MemRead == 1);
			assert(ex_state.Mem2Reg == 1);
		end
	endtask

endprogram
