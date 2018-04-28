/*****************************************************************************
 * The Instruction Decoder module, creates the control signals,              *
 * reads from the register file and stores the information to EX_STATE reg   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/
`include "../PipelineRegs.sv"
`include "../ISA.sv"
module decoder(
    input clk,
    input reset,
    input PipelineReg::ID_STATE id_state,
    output PipelineReg::EX_STATE ex_state
    );
	
	always @(posedge clk) begin
		//Important send rs, rt, rd to read from regfile
		ex_state.pc <= id_state.pc;
		ex_state.rs1 <= id_state.instruction[19:15];
		ex_state.func3 <= id_state.instruction[14:12];
		ex_state.func7 <= id_state.instruction[31:25];
		casez(id_state.instruction)
			`ADD, `SUB, `SLL, `SLT, `SLTU, `XOR, `SRL, `SRA, `OR, `AND: 
			begin
				ex_state.rd <= id_state.instruction[11:7];
				ex_state.rs2 <= id_state.instruction[24:20];
				ex_state.ALUOp <= 3'b010;
				ex_state.ALUsrc <= 2'b00;
				$write("R-Format Instruction\n");
			end
			`ADDI, `SLTI, `SLTIU, `XORI, `ORI, `ANDI, `SLLI, `SRLI, `SRAI:
			begin
				ex_state.rd <= id_state.instruction[11:7];
				ex_state.ALUOp <= 3'b011;
				ex_state.ALUsrc <= 2'b01;
				//TODO WORK ON THIS
				ex_state.immediate <= { {16{id_state.instruction[31]}} ,id_state.instruction[31:20] };
				$write("I-Format Instruction\n");
			end
			`LUI:
			begin
				ex_state.immediate[31:12] <= id_state.instruction[31:12];
				ex_state.immediate[11:0] <= 12'b0;
				ALUsrc <= 2'b01;
				ex_state.ALUOp <= 3'b100;
			end
			`AUIPC:
				ex_state.immediate[31:12] <= id_state.instruction[31:12];
				ex_state.immediate[11:0] <= 12'b0;
				ex_state.ALUop <= 3'b101;
				ALUSrc <= 2'b10;
			begin

			end

			default: begin
				$write("Unknown Instruction Format!\n");
			end
		endcase
	end
endmodule
