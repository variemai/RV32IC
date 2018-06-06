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
    input PipelineReg::ID_STATE id_state,
    output PipelineReg::EX_STATE ex_state,
	input PipelineReg::EX_STATE next_state,
	output logic stall,
	input reset
);

	always_comb begin
		if( (id_state.instruction[24:20] == next_state.rd || id_state.instruction[19:15] == next_state.rd) && (next_state.rd != 5'b0) ) begin
			ex_state.rs1 = 5'b0;
			ex_state.rd = 5'b0;
			ex_state.rs2 = 5'b0;
			stall = 1;
			ex_state.pc = id_state.pc;
		end
		else begin
			ex_state.rs1 = id_state.instruction[19:15];
			ex_state.rd = id_state.instruction[11:7];
			ex_state.rs2 = id_state.instruction[24:20];
			//stall = 0;
			ex_state.pc = id_state.pc;
			ex_state.func3 = id_state.instruction[14:12];
			ex_state.func7 = id_state.instruction[31:25];

			casez(id_state.instruction)


			`ADD, `SUB, `SLL, `SLT, `SLTU, `XOR, `SRL, `SRA, `OR, `AND: 
			begin
				ex_state.ALUOp = 3'b010;
				ex_state.ALUsrc = 2'b00;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				stall = 0; 
				//$write("R-Format Instruction\n");
			end

			`ADDI, `SLTI, `SLTIU, `XORI, `ORI:
			begin
				ex_state.immediate = { {21{id_state.instruction[31]}} ,id_state.instruction[30:20] };
				ex_state.ALUOp = 3'b011;
				ex_state.ALUsrc = 2'b01;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				stall = 0;
				//$write("I-Format Instruction\n");
			end

			`SLLI, `SRLI, `SRAI:
			begin
				//TODO implementation of these instructions might need separate cases
			end

			`LUI:
			begin
				ex_state.immediate[31:12] = id_state.instruction[31:12];
				ex_state.immediate[11:0] = 12'b0;
				ex_state.ALUOp = 3'b100;
				ex_state.ALUsrc = 2'b01;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				stall = 0;
			end

			`AUIPC:
			begin
				ex_state.immediate[31:12] = id_state.instruction[31:12];
				ex_state.immediate[11:0] = 12'b0;
				ex_state.ALUOp = 3'b101;
				ex_state.ALUsrc = 2'b10;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				stall = 0;
			end

			`LB, `LH, `LW, `LBU,`LHU:
			begin
				ex_state.immediate = { {21{id_state.instruction[31]}} ,id_state.instruction[30:20] };
				ex_state.ALUOp = 3'b0;
				ex_state.MemRead = 1;
				ex_state.MemToReg = 1;
				ex_state.MemWrite = 0;
				ex_state.ALUsrc = 2'b01;
				stall = 0;
				//$write("Load Instruction!\n");
			end

			`SB, `SH, `SW:
			begin
				ex_state.immediate = {{21{id_state.instruction[31]}},id_state.instruction[30:25],id_state.instruction[11:7]};
				ex_state.ALUOp = 3'b0;
				ex_state.MemWrite = 1;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.ALUsrc = 2'b01;
				stall = 0;
			end

			`BEQ, `BNE, `BGE, `BLTU, `BGEU:
			begin
				ex_state.immediate = { {21{id_state.instruction[31]}} ,id_state.instruction[30:20] };
				ex_state.ALUOp = 3'b001;
				ex_state.MemWrite = 0;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.ALUsrc = 2'b00;
				stall = 1;
			end
			default: begin
				stall = 0;
				//$write("Unknown Instruction Format!\n");
			end
			endcase
		end
	end

endmodule
