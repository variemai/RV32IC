/*****************************************************************************
 * The Instruction Decoder module, creates the control signals,              *
 * reads from the register file and stores the information to EX_STATE reg   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/

`include "PipelineRegs.sv"

module decoder(
    input clk,
    input PipelineReg::ID_STATE id_state,
    output PipelineReg::EX_STATE ex_state,
	input PipelineReg::EX_STATE next_state,
	input PipelineReg::MEM_STATE mem_state,
	input logic valid,
	input logic kill,
	output logic stall
);

 	always_comb begin
		ex_state.pc = id_state.pc;
		if(valid && ~kill) begin
		ex_state.func7 = id_state.instruction[30];
		ex_state.func3 = id_state.instruction[14:12];
		ex_state.rs1 = id_state.instruction[19:15];
		ex_state.rd = id_state.instruction[11:7];
		ex_state.rs2 = id_state.instruction[24:20];
		case (id_state.instruction[6:0]) inside
			//`ADD, `SUB, `SLL, `SLT, `SLTU, `XOR, `SRL, `SRA, `OR, `AND: 
			7'b0110011:
			begin
				if( ((id_state.instruction[24:20] == next_state.rd || id_state.instruction[19:15] == next_state.rd) 
				&& next_state.rd != 5'b0 && next_state.RegWrite == 1 ) ||  
				((id_state.instruction[24:20] == mem_state.rd || id_state.instruction[19:15] == mem_state.rd ) 
				&& mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.ALUOp = 3'b011;
					ex_state.immediate = 32'b0;
					ex_state.RegWrite = 0;
					ex_state.func3 = 3'b0;
					stall = 1;
				end 
				else begin
					ex_state.ALUOp = 3'b010;
					ex_state.RegWrite = 1;
					ex_state.func3 = id_state.instruction[14:12];
					stall = 0; 
				end
				ex_state.jmp = 0;
				//$write("R-Format Instruction\n");
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
			end
			//`ADDI, `SUBI,
			7'b0010011:
			begin
				if( (id_state.instruction[19:15] == next_state.rd && next_state.rd != 5'b0 && next_state.RegWrite == 1 )
				|| (id_state.instruction[19:15] == mem_state.rd && mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.immediate = 32'b0;
					ex_state.RegWrite = 0;
					ex_state.func3 = 3'b0;
					stall = 1;
				end 
				else begin
					ex_state.immediate = { {21{id_state.instruction[31]}} ,id_state.instruction[30:20] };
					ex_state.RegWrite = 1;
					ex_state.func3 = id_state.instruction[14:12];
					stall = 0;
				end
				ex_state.ALUOp = 3'b011;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				ex_state.jmp = 0;
				//$write("I-Format Instruction\n");
			end
			//LUI
			7'b0110111:
			begin
				ex_state.immediate[31:12] = id_state.instruction[31:12];
				ex_state.immediate[11:0] = 12'b0;
				ex_state.ALUOp = 3'b100;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				ex_state.RegWrite = 1;
				stall = 0;
				ex_state.jmp = 0;
				//$write("LUI\n");
			end
			//AUIPC
			7'b0010111:
			begin
				ex_state.immediate[31:12] = id_state.instruction[31:12];
				ex_state.immediate[11:0] = 12'b0;
				ex_state.ALUOp = 3'b101;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				ex_state.RegWrite = 1;
				stall = 0;
				ex_state.jmp = 0;
				//$write("AUIPC\n");
			end

			//`LB, `LH, `LW, `LBU,`LHU:
			7'b0000011:
			begin
				if( (id_state.instruction[19:15] == next_state.rd && next_state.rd != 5'b0 && next_state.RegWrite == 1 )
				|| (id_state.instruction[19:15] == mem_state.rd && mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.immediate = 32'b0;
					ex_state.RegWrite = 0;
					ex_state.MemRead = 0;
					ex_state.MemToReg = 0;
					ex_state.func3 = 3'b0;
					ex_state.ALUOp = 3'b011;
					stall = 1;
				end
				else begin
					ex_state.immediate = { {21{id_state.instruction[31]}} ,id_state.instruction[30:20] };
					ex_state.ALUOp = 3'b0;
					ex_state.MemRead = 1;
					ex_state.MemToReg = 1;
					stall = 0;
					ex_state.RegWrite = 1;
				end
				ex_state.MemWrite = 0;
				ex_state.jmp = 0;
				//$write("Load Instruction!\n");
			end

			//`JAL:
			7'b1101111:
			begin
			//	$write("JAL Instruction!\n");
				ex_state.jmp = 1;
				ex_state.immediate = {{12{id_state.instruction[31]}},id_state.instruction[19:12],id_state.instruction[20],id_state.instruction[30:21],1'b0};
				ex_state.RegWrite = 1;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				ex_state.ALUOp = 110;
				stall = 0;	
			end

			//`JALR:
			7'b1100111:
			begin
				if( (id_state.instruction[19:15] == next_state.rd && next_state.rd != 5'b0 && next_state.RegWrite == 1 )
				|| (id_state.instruction[19:15] == mem_state.rd && mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.immediate = 32'b0;
					ex_state.RegWrite = 0;
					ex_state.MemRead = 0;
					ex_state.MemToReg = 0;
					ex_state.func3 = 3'b0;
					ex_state.ALUOp = 3'b011;
					ex_state.jmp = 0;
					stall = 1;
				end
				else begin
					ex_state.jmp = 1;
					ex_state.immediate = {{20{id_state.instruction[31]}} ,id_state.instruction[30:20],1'b0};
					ex_state.rd = id_state.instruction[11:7];
					ex_state.RegWrite = 1;
					ex_state.MemRead = 0;
					ex_state.MemToReg = 0;
					ex_state.ALUOp = 111;
					stall = 0;
				end	
				ex_state.MemWrite = 0;
			end

			//`SB, `SH, `SW:
			7'b0100011:
			begin
				if( ((id_state.instruction[24:20] == next_state.rd || id_state.instruction[19:15] == next_state.rd) 
				&& next_state.rd != 5'b0 && next_state.RegWrite == 1 ) ||  
				((id_state.instruction[24:20] == mem_state.rd || id_state.instruction[19:15] == mem_state.rd ) 
				&& mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.immediate = 32'b0;
					ex_state.RegWrite = 0;
					ex_state.MemRead = 0;
					ex_state.MemToReg = 0;
					ex_state.func3 = 3'b0;
					ex_state.ALUOp = 3'b011;
					stall = 1;
					ex_state.MemWrite = 0;
				end
				else begin 
					ex_state.immediate = {{21{id_state.instruction[31]}},id_state.instruction[30:25],id_state.instruction[11:7]};
					ex_state.ALUOp = 3'b0;
					ex_state.MemWrite = 1;
					ex_state.MemRead = 0;
					ex_state.MemToReg = 0;
					ex_state.RegWrite = 0;
					stall = 0;
				end
				//$write("STORE Instruction!\n");
				ex_state.jmp = 0;
			end

			//`BEQ, `BNE, `BGE, `BLTU, `BGEU:
			7'b1100011:
			begin
				if( ((id_state.instruction[24:20] == next_state.rd || id_state.instruction[19:15] == next_state.rd) 
				&& next_state.rd != 5'b0 && next_state.RegWrite == 1 ) ||  
				((id_state.instruction[24:20] == mem_state.rd || id_state.instruction[19:15] == mem_state.rd ) 
				&& mem_state.rd != 5'b0 && mem_state.RegWrite == 1) ) begin
					ex_state.rs1 = 5'b0;
					ex_state.rd = 5'b0;
					ex_state.ALUOp = 3'b011;
					ex_state.immediate = 32'b0;
					ex_state.func3 = 3'b0;
					ex_state.MemToReg = 0;
					ex_state.MemWrite = 0;
					ex_state.RegWrite = 0;
					ex_state.jmp = 0;
					stall = 1;
				end 
				else begin
					ex_state.immediate = { {20{id_state.instruction[31]}},id_state.instruction[7],id_state.instruction[30:25],id_state.instruction[11:8],1'b0};
					ex_state.ALUOp = 3'b001;
					stall = 0;
				end
				ex_state.MemWrite = 0;
				ex_state.RegWrite = 0;
				ex_state.MemRead = 0;
				ex_state.MemToReg = 0;
				//$write("LOAD Instruction!\n");
			end
			
			default: 
			begin
				stall = 0;
				ex_state.MemToReg = 0;
				ex_state.MemWrite = 0;
				ex_state.RegWrite = 0;
				$write("Unknown Instruction Format!\n");
			end
		endcase
	end else begin 
		ex_state.rs1 = 5'b0;
		ex_state.rd = 5'b0;
		ex_state.ALUOp = 3'b011;
		ex_state.immediate = 32'b0;
		ex_state.func3 = 3'b0;
		ex_state.jmp = 0; 
		ex_state.MemToReg = 0;
		ex_state.MemWrite = 0;
		ex_state.RegWrite = 0;
		stall = 0;
	end
	end

endmodule
