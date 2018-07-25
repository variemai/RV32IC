
`include "instructions.sv"
module comp_instr_decoder(
	input  logic	[15:0]	instruction,
	output logic	[31:0]	decomp_instruction);


	//RES | NSE -> invalid
	//HINT 		-> C.NOP

	always_comb begin
		casez(instruction)
			`C_ADDI4SPN://addi rd' , x2, nzuimm[9:2] | RES nzuimm=0
				begin
					//immidiate[31:20]
					decomp_instruction[31:30] 	= 2'b00;
					decomp_instruction[29:26] 	= instruction[10:7];
					decomp_instruction[25:24] 	= instruction[12:11];
					decomp_instruction[23]		= instruction[5];
					decomp_instruction[22]		= instruction[6];
					decomp_instruction[21:20]	= 2'b00;
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[4:2];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_LW:		//lw rd', offset[6:2](rs1')
				begin
					//immidate[31:20]
					decomp_instruction[31:27] 	= 5'b00000;
					decomp_instruction[26]		= instruction[5];
					decomp_instruction[25:23]	= instruction[12:10];
					decomp_instruction[22]		= instruction[6];
					decomp_instruction[21:20]	= 2'b00;
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[4:2];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0000011;
				end
			`C_SW:		//sw rs2', offset[6:2](rs1')
				begin
					//immidate[31:25],immidiate[11:7]
					decomp_instruction[31:27]	= 5'b00000;
					decomp_instruction[26]		= instruction[5];
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[11:10]	= instruction[11:10];
					decomp_instruction[9]		= instruction[6];
					decomp_instruction[8:7]		= 2'b00;
					//rs2[24:20]
					decomp_instruction[24:23]	= 2'b00;
					decomp_instruction[22:20]	= instruction[4:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b010;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0100011;
				end
			`C_NOP:		//addi x0, x0, 0
				begin
					//immidiate[31:20]
					decomp_instruction[31:20] 	= 12'b000000000000;
					//rs1[19:15]
					decomp_instruction[19:15]	= 5'b00000;
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:7]	= 5'b00000;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_ADDI:	//addi rd, rd, nzimm[5:0] | HINT nzimm=0
						//rd must be !=0, otherwise instruction has no effect	
				begin
					//immidiate[31:20]
					decomp_instruction[31:26] 	= 6'b000000;
					decomp_instruction[25] 		= instruction[12];
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_JAL:		//jal x1, offset[11:1] 
				begin
					//immidiate[31:12]
					decomp_instruction[31]		= 1'b0;
					decomp_instruction[30]		= instruction[8];
					decomp_instruction[29:28]	= instruction[10:9];
					decomp_instruction[27]		= instruction[6];
					decomp_instruction[26]		= instruction[7];
					decomp_instruction[25]		= instruction[2];
					decomp_instruction[24]		= instruction[11];
					decomp_instruction[23:21]	= instruction[5:3];
					decomp_instruction[20]		= instruction[12];
					decomp_instruction[19:12]	= 8'b00000000;
					//x1[11:7]
					decomp_instruction[11:7]	= 5'b00001;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1101111;
				end
			`C_LI:		//addi rd, x0, imm[5:0] | HINT rd=0
				begin
					//immidiate[31:20]
					decomp_instruction[31:26]	= 6'b000000;
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:15]	= 5'b00000;
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_ADDI16SP://addi x2, x2, nzimm[9:4] | RES nzimm=0
						//rs1 must be =2, otherwise LUI must executed	
				begin
					//immidiate[31:20]
					decomp_instruction[31:30]	= 2'b00;
					decomp_instruction[29]		= instruction[12];
					decomp_instruction[28:27]	= instruction[4:3];
					decomp_instruction[26]		= instruction[5];
					decomp_instruction[25]		= instruction[2];
					decomp_instruction[24]		= instruction[6];
					decomp_instruction[23:20]	= 4'b0000;
					//rs1[19:15] == x2
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_LUI:		//lui rd, nzuimm[17:12] | RES nzimm=0 | HINT rd=0
						//rd must be != 2, otherwise ADDI16SP must executed
				begin
					//immidate[31:12]
					decomp_instruction[31:18]	= 14'b00000000000000;
					decomp_instruction[17]		= instruction[12];
					decomp_instruction[16:12]	= instruction[6:2];
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					//decomp_instruction[6:0]	= 7'b0110111;
					decomp_instruction[6:4]		= instruction[15:13];
					decomp_instruction[3:2]		= instruction[1:0];
					decomp_instruction[1:0]		= 2'b11;
				end
			`C_SRLI:	//srli rd', rd', shamt[5:0] | NSE nzuimm[5]=1
				begin
					//immidiate[31:26]
					decomp_instruction[31:26]	= 6'b000000;
					//shamt[25:20]
					decomp_instruction[25]		= instruction[12];//shamt[5]
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b101;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_SRLI64:	// HINT
				begin
				
				end
			`C_SRAI:	//srai rd', rd', shamt[5:0] | NSE nzuimm[5]=1
				begin
					//immidiate[31:26]
					decomp_instruction[31:26]	= 6'b010000;
					//shamt[25:20]
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b101;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_SRAI64:	// HINT
				begin

				end
			`C_ANDI:	//andi rd', rd', imm[5:0]
				begin
					//immidiate[31:20]
					decomp_instruction[31:26]	= 6'b000000;
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b111;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_SUB:		//sub rd', rd', rs2'
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0100000;
					//rs2[24:20]
					decomp_instruction[24:23]	= 2'b00;
					decomp_instruction[22:20]	= instruction[4:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_XOR:		//xor rd', rd', rs2'
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0000000;
					//rs2[24:20]
					decomp_instruction[24:23]	= 2'b00;
					decomp_instruction[22:20]	= instruction[4:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b100;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_OR:		//or rd', rd', rs2'
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0000000;
					//rs2[24:20]
					decomp_instruction[24:23]	= 2'b00;
					decomp_instruction[22:20]	= instruction[4:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b110;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_AND:		//and rd', rd', rs2'
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0000000;
					//rs2[24:20]
					decomp_instruction[24:23]	= 2'b00;
					decomp_instruction[22:20]	= instruction[4:2];
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b111;
					//rd[11:7]
					decomp_instruction[11:10]	= 2'b00;
					decomp_instruction[9:7]		= instruction[9:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_J:		//jal x0, offset[11:1]
				begin
					//immidiate[31:12]
					decomp_instruction[31]		= 1'b0;
					decomp_instruction[30]		= instruction[8];
					decomp_instruction[29:28]	= instruction[10:9];
					decomp_instruction[27]		= instruction[6];
					decomp_instruction[26]		= instruction[7];
					decomp_instruction[25]		= instruction[2];
					decomp_instruction[24]		= instruction[11];
					decomp_instruction[23:21]	= instruction[5:3];
					decomp_instruction[20]		= instruction[12];
					decomp_instruction[19:12]	= 8'b00000000;
					//rd[11:7] = x0
					decomp_instruction[11:7]	= 5'b00000;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1101111;
				end
			`C_BEQZ:	//beq rs1', x0, offset[8:1]
				begin
					//immidiate[31:25], immidiate[11:7]
					decomp_instruction[31:29]	= 3'b000;
					decomp_instruction[28]		= instruction[12];
					decomp_instruction[27:26]	= instruction[6:5];
					decomp_instruction[25]		= instruction[2];
					decomp_instruction[11:10]	= instruction[11:10];
					decomp_instruction[9:8]		= instruction[4:3];
					decomp_instruction[7]		= 1'b0;
					//rs2[24:20]
					decomp_instruction[24:20]	= 5'b00000;
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1100011;
				end
			`C_BNEZ:	//bne rs1', x0, offset[8:1]
				begin
					//immidiate[31:25], immidiate[11:7]
					decomp_instruction[31:29]	= 3'b000;
					decomp_instruction[28]		= instruction[12];
					decomp_instruction[27:26]	= instruction[6:5];
					decomp_instruction[25]		= instruction[2];
					decomp_instruction[11:10]	= instruction[11:10];
					decomp_instruction[9:8]		= instruction[4:3];
					decomp_instruction[7]		= 1'b0;
					//rs2[24:20]
					decomp_instruction[24:20]	= 5'b00000;
					//rs1[19:15]
					decomp_instruction[19:18]	= 2'b00;
					decomp_instruction[17:15]	= instruction[9:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b001;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1100011;
				end
			`C_SLLI:	//slli rd, rd, shamt[5:0] | HINT rd=0 | NSE nzuimm[5]=1
				begin
					//immidiate[31:26]
					decomp_instruction[31:26]	= 6'b000000;
					//shamt[25:20]
					decomp_instruction[25]		= instruction[12];//shamt[5]
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b001;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0010011;
				end
			`C_SLLI64:	// HINT
				begin

				end
			`C_LWSP:	//lw rd, offset[7:2](x2) | RES rd=0
				begin
					//immediate[31:20]
					decomp_instruction[31:28]	= 4'b0000;
					decomp_instruction[27:26]	= instruction[3:2];
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[24:22]	= instruction[6:4];
					decomp_instruction[21:20]	= 2'b00;
					//rs1[19:15]=x2
					decomp_instruction[19:15]	= 5'b00010;
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0000011;
				end
			`C_JR:		//jalr x0, rs1, 0 | RES rs1=0
				begin
					//immidiate[31:20]
					decomp_instruction[31:20]	= 12'b000000000000;
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= instruction[15:13];
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[6:2];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1100111;
				end
			`C_MV:		//add rd, x0, rs2 | HINT rd=0
						//rs2 must be !=0, not sure if must be checked
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0000000;
					//rs2[24:20]
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]=x0
					decomp_instruction[19:15]	= 5'b00000;
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_EBREAK:	//ebreak
				begin
					decomp_instruction[31:16]	= 16'h0010;
					decomp_instruction[15:0]	= 16'h0073;
				end
			`C_JALR:	//jalr x1, rs1, 0
						//rs1 must be !=0, otherwise what?
				begin
					//immidiate[31:20]
					decomp_instruction[31:20]	= 12'h000;
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]=x1
					decomp_instruction[11:7]	= 5'b00001;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b1100111;
				end
			`C_ADD:		//add rd, rd, rs2 | HINT rd=0
				begin
					//funct7[31:25]
					decomp_instruction[31:25]	= 7'b0000000;
					//rs2[24:20]
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]
					decomp_instruction[19:15]	= instruction[11:7];
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b000;
					//rd[11:7]
					decomp_instruction[11:7]	= instruction[11:7];
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0110011;
				end
			`C_SWSP:	//sw rs2, offset[7:2](x2)
				begin
					//immidiate[31:25], immidiate[11:7]
					decomp_instruction[31:28]	= 4'h0;
					decomp_instruction[27:26]	= instruction[8:7];
					decomp_instruction[25]		= instruction[12];
					decomp_instruction[11:9]	= instruction[11:9];
					decomp_instruction[8:7]		= 2'b00;
					//rs2[24:20]
					decomp_instruction[24:20]	= instruction[6:2];
					//rs1[19:15]=x2
					decomp_instruction[19:15]	= 5'b00010;
					//funct3[14:12]
					decomp_instruction[14:12]	= 3'b010;
					//opcode[6:0]
					decomp_instruction[6:0]		= 7'b0100011;
				end
			default:
				begin

				end
		endcase
	end
endmodule
